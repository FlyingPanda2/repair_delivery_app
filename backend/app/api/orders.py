from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..models.order import Order

router = APIRouter(prefix="/orders", tags=["orders"])

@router.get("/")
def list_orders(db: Session = Depends(get_db)):
    return db.query(Order).all()