from datetime import datetime

from pydantic import BaseModel


class TeamCreate(BaseModel):
    title: str
    description: str
    tech_stack: str
    max_members: int


class TeamUpdate(BaseModel):
    title: str
    description: str
    tech_stack: str
    max_members: int


class TeamResponse(BaseModel):
    id: int
    title: str
    description: str
    tech_stack: str
    max_members: int
    current_members: int
    created_by: int
    created_at: datetime

    class Config:
        from_attributes = True


class TeamMemberResponse(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True


class TeamStatusResponse(BaseModel):
    joined: bool
    is_creator: bool


# ==========================
# Team Invitations
# ==========================

class TeamInvitationCreate(BaseModel):
    team_id: int
    receiver_id: int


class TeamInvitationResponse(BaseModel):
    id: int
    team_id: int
    sender_id: int
    receiver_id: int
    status: str
    created_at: datetime

    class Config:
        from_attributes = True


class TeamInvitationStatus(BaseModel):
    message: str