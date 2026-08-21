from datetime import datetime

from pydantic import BaseModel


class ChatRoomResponse(BaseModel):
    kind: str  # 'team' or 'dm'
    id: int
    name: str
    last_message: str | None
    last_message_time: datetime | None