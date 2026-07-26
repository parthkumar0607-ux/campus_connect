from datetime import datetime

from pydantic import BaseModel


class EventCreate(BaseModel):
    title: str
    description: str
    venue: str
    date_time: datetime
    max_attendees: int


class EventUpdate(BaseModel):
    title: str
    description: str
    venue: str
    date_time: datetime
    max_attendees: int


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