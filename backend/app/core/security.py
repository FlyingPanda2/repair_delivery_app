import secrets
from datetime import datetime, timedelta
from jose import jwt
from .config import settings

# В реальности — Redis или БД для хранения кодов
SMS_CODES = {}

def send_sms_code(phone: str):
    code = secrets.randbelow(10000)
    SMS_CODES[phone] = {"code": f"{code:04d}", "expires": datetime.utcnow() + timedelta(minutes=5)}
    print(f"[MOCK SMS] Code for {phone}: {code:04d}")

def verify_code(phone: str, code: str) -> bool:
    record = SMS_CODES.get(phone)
    if not record:
        return False
    if datetime.utcnow() > record["expires"]:
        del SMS_CODES[phone]
        return False
    return record["code"] == code

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm="HS256")