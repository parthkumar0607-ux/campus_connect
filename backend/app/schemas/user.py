from typing import Optional

from pydantic import BaseModel, EmailStr, Field


class UserCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)
    college: Optional[str] = Field(default=None, max_length=150)
    course: Optional[str] = Field(default=None, max_length=100)
    year: Optional[str] = Field(default=None, max_length=20)


class UserUpdate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    college: str = Field(max_length=150)
    course: str = Field(max_length=100)
    year: str = Field(max_length=20)
    bio: str = Field(max_length=500)
    skills: str = Field(max_length=500)


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
