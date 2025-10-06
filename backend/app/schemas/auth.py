from pydantic import BaseModel, Field

class PhoneRequest(BaseModel):
    phone: str = Field(..., pattern=r"^\+7\d{10}$")

class CodeRequest(BaseModel):
    phone: str = Field(..., pattern=r"^\+7\d{10}$")
    code: str = Field(..., min_length=4, max_length=4)

class Token(BaseModel):
    access_token: str
    token_type: str