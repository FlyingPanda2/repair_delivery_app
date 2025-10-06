from sqlalchemy import Column, Integer, String, Text, Boolean
from .base import Base

class PVZ(Base):
    __tablename__ = "pvz"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    address = Column(String, nullable=False)
    coordinates = Column(String)  # "lat,lon"
    work_hours = Column(String)
    operator_name = Column(String)
    operator_phone = Column(String)
    accepts_tech = Column(Boolean, default=False)
    accepts_clothes = Column(Boolean, default=False)
    accepts_shoes = Column(Boolean, default=False)
    pvz_code = Column(String, unique=True, index=True)  # e.g., "PVZ-15"