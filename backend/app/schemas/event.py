from datetime import datetime

from pydantic import BaseModel, Field


class EventCreate(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1, max_length=2000)
    venue: str = Field(min_length=1, max_length=300)
    date_time: datetime
    max_attendees: int = Field(ge=1, le=10000)


class EventUpdate(EventCreate):
    pass


class EventResponse(BaseModel):
    id: int
    title: str
    description: str
    venue: str
    date_time: datetime
    max_attendees: int
    current_attendees: int
    created_by: int
    created_at: datetime

    class Config:
        from_attributes = True


class EventAttendeeResponse(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True


class EventStatusResponse(BaseModel):
    registered: bool
    is_creator: bool
