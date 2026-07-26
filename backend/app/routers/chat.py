from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.user import User
from app.schemas.message import (
    MessageCreate,
    MessageResponse,
)
from app.services.message_service import MessageService

router = APIRouter(
    prefix="/chat",
    tags=["Chat"],
)


@router.post(
    "/{team_id}",
    response_model=MessageResponse,
)
def send_message(
    team_id: int,
    message: MessageCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return MessageService.send_message(
        db,
        team_id,
        message,
        current_user,
    )


@router.get(
    "/{team_id}",
    response_model=list[MessageResponse],
)
def get_messages(
    team_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return MessageService.get_messages(
        db,
        team_id,
        current_user,
    )