from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://repair_delivery_db_user:3TCn3Nx02DLBCW56pGh91Xy47VwFQFy7@dpg-d3i0a58gjchc73arim0g-a/repair_delivery_db"
    SECRET_KEY: str = ""
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    SMS_SERVICE_MOCK: bool = True  # в реальности — интеграция с SMS-провайдером

settings = Settings()