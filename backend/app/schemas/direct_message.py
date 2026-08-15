from datetime import datetime

from pydantic import BaseModel, Field


class DirectMessageCreate(BaseModel):
    content: str = Field(min_length=1, max_length=5000)


class DirectMessageResponse(BaseModel):
    id: int
    sender_id: int
    receiver_id: int
    sender_name: str
    content: str
    created_at: datetime

    class Config:
        from_attributes = True
