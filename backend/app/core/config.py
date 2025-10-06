from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://repair_user:secure123@localhost:5432/repair_platform"
    SECRET_KEY: str = "your-secret-key-here"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    SMS_SERVICE_MOCK: bool = True  # в реальности — интеграция с SMS-провайдером

settings = Settings()