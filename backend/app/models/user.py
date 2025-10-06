from sqlalchemy import Column, Integer, String, Enum as SQLEnum, Boolean
from .base import Base

# Вариант 1: Используем обычный Enum со строками
USER_ROLES = ["client", "pvz", "service", "admin"]

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    phone = Column(String, unique=True, index=True)
    email = Column(String, nullable=True)
    name = Column(String, nullable=True)
    role = Column(SQLEnum(*USER_ROLES, name="user_role"), default="client")
    is_verified = Column(Boolean, default=False)