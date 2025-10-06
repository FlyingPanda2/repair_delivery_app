from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.orm import Session
from ..database import get_db
from ..schemas import auth as auth_schemas
from ..models.user import User
from ..core.security import create_access_token, verify_code, send_sms_code

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/request-code")
def request_code(
    data: auth_schemas.PhoneRequest,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db)
):
    user = db.query(User).filter(User.phone == data.phone).first()
    if not user:
        user = User(phone=data.phone, role="client")
        db.add(user)
        db.commit()
    # Отправка кода (в реальности — через SMS-провайдера)
    background_tasks.add_task(send_sms_code, data.phone)
    return {"ok": True}

@router.post("/verify-code", response_model=auth_schemas.Token)
def verify_code_endpoint(
    data: auth_schemas.CodeRequest,
    db: Session = Depends(get_db)
):
    if not verify_code(data.phone, data.code):
        raise HTTPException(status_code=400, detail="Invalid code")
    access_token = create_access_token(data={"sub": data.phone})
    return {"access_token": access_token, "token_type": "bearer"}