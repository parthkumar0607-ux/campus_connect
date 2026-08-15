from sqlalchemy.orm import Session

from app.models.direct_message import DirectMessage
from app.models.user import User


class DirectMessageRepository:
    @staticmethod
    def create_direct_message(
        db: Session,
        message: DirectMessage,
    ):
        db.add(message)
        db.commit()
        db.refresh(message)
        return message

    @staticmethod
    def get_conversation(
        db: Session,
        user_id: int,
        other_user_id: int,
    ):
        rows = (
            db.query(DirectMessage, User.name.label("sender_name"))
            .join(User, User.id == DirectMessage.sender_id)
            .filter(
                (
                    (DirectMessage.sender_id == user_id)
                    & (DirectMessage.receiver_id == other_user_id)
                )
                | (
                    (DirectMessage.sender_id == other_user_id)
                    & (DirectMessage.receiver_id == user_id)
                )
            )
            .order_by(DirectMessage.created_at.asc())
            .all()
        )

        return [
            {
                "id": message.id,
                "sender_id": message.sender_id,
                "receiver_id": message.receiver_id,
                "sender_name": sender_name,
                "content": message.content,
                "created_at": message.created_at,
            }
            for message, sender_name in rows
        ]
