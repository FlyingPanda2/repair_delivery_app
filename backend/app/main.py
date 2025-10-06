from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .api import auth

app = FastAPI(title="Repair Delivery API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)