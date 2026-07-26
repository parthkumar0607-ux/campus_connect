from typing import Optional

from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str
    college: Optional[str] = None
    course: Optional[str] = None
    year: Optional[str] = None


class UserUpdate(BaseModel):
    name: str
    college: str
    course: str
    year: str
    bio: str
    skills: str


class UserResponse(BaseModel):
    id: int
    name: str
    email: EmailStr
    college: Optional[str] = None
    course: Optional[str] = None
    year: Optional[str] = None
    bio: Optional[str] = None
    skills: Optional[str] = None
    profile_image: Optional[str] = None

    class Config:
        from_attributes = True