from sqlalchemy import Column, Integer, String, Text, Integer as Int, ForeignKey, DateTime
from sqlalchemy.sql import func
from .base import Base

class Review(Base):
    __tablename__ = "reviews"

    id = Column(Integer, primary_key=True, index=True)
    client_phone = Column(String, ForeignKey("users.phone"))
    service_id = Column(Integer, ForeignKey("users.id"))
    order_id = Column(Integer, ForeignKey("orders.id"))
    rating = Column(Int, nullable=False)  # 1-5
    comment = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())