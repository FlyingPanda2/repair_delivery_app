# backend/app/models/__init__.py
from .base import Base
from .user import User
from .order import Order
from .pvz import PVZ  # ← ДОБАВЬТЕ ЭТУ СТРОКУ

__all__ = ["Base", "User", "Order", "PVZ"]