from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.direct_message import DirectMessage
from app.models.user import User
from app.repositories.direct_message_repository import DirectMessageRepository
from app.repositories.user_repository import UserRepository


class DirectMessageService:
    @staticmethod
    def send_message(
        db: Session,
        receiver_id: int,
        content: str,
        current_user: User,
    ):
        if receiver_id == current_user.id:
            raise HTTPException(
                status_code=400,
                detail="You cannot message yourself.",
            )

        receiver = UserRepository.get_by_id(db, receiver_id)
        if not receiver:
            raise HTTPException(
                status_code=404,
                detail="User not found.",
            )

        message = DirectMessage(
            sender_id=current_user.id,
            receiver_id=receiver_id,
            content=content.strip(),
        )

        created = DirectMessageRepository.create_direct_message(db, message)

        return {
            "id": created.id,
            "sender_id": created.sender_id,
            "receiver_id": created.receiver_id,
            "sender_name": current_user.name,
            "content": created.content,
            "created_at": created.created_at,
        }

    @staticmethod
    def get_conversation(
        db: Session,
        user_id: int,
        current_user: User,
    ):
        if user_id == current_user.id:
            raise HTTPException(
                status_code=400,
                detail="Invalid conversation.",
            )

        if not UserRepository.get_by_id(db, user_id):
            raise HTTPException(
                status_code=404,
                detail="User not found.",
            )

        return DirectMessageRepository.get_conversation(
            db,
            current_user.id,
            user_id,
        )
