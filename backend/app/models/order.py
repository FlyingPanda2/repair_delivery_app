from sqlalchemy import Column, Integer, String, Text, Enum as SQLEnum, ForeignKey, DateTime, Boolean
from sqlalchemy.sql import func
from .base import Base

ORDER_STATUSES = [
    "created", "accepted", "sent_to_service", "diagnosing",
    "price_proposed", "confirmed", "rejected", "in_work",
    "ready", "ready_for_pickup", "delivered"
]

class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    client_phone = Column(String, ForeignKey("users.phone"))
    service_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    pvz_id = Column(Integer, ForeignKey("pvz.id"))
    category = Column(String)  # "tech", "clothes", "shoes"
    subcategory = Column(String)
    description = Column(Text)
    max_price = Column(Integer, nullable=True)
    status = Column(SQLEnum(*ORDER_STATUSES, name="order_status"), default="created")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())