from datetime import datetime

from pydantic import BaseModel


class ChatRoomResponse(BaseModel):
    team_id: int
    team_name: str
    last_message: str | None
    last_message_time: datetime | None