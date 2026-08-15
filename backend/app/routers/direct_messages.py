from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.user import User
from app.schemas.direct_message import DirectMessageCreate, DirectMessageResponse
from app.services.direct_message_service import DirectMessageService

router = APIRouter(
    prefix="/direct-messages",
    tags=["Direct Messages"],
)


@router.get(
    "/{user_id}",
    response_model=list[DirectMessageResponse],
)
def get_direct_messages(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return DirectMessageService.get_conversation(
        db,
        user_id,
        current_user,
    )


@router.post(
    "/{user_id}",
    response_model=DirectMessageResponse,
)
def send_direct_message(
    user_id: int,
    message: DirectMessageCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if not message.content.strip():
        raise HTTPException(
            status_code=400,
            detail="Message content cannot be empty.",
        )

    return DirectMessageService.send_message(
        db,
        user_id,
        message.content,
        current_user,
    )
