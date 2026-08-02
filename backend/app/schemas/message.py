from datetime import datetime

from pydantic import BaseModel, Field


class MessageCreate(BaseModel):
    content: str = Field(min_length=1, max_length=5000)


class MessageResponse(BaseModel):
    id: int
    team_id: int
    sender_id: int
    content: str
    created_at: datetime

    class Config:
        from_attributes = True
