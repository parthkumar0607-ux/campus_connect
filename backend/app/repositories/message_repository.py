from sqlalchemy.orm import Session

from app.models.message import Message


class MessageRepository:

    @staticmethod
    def create_message(
        db: Session,
        message: Message,
    ):
        db.add(message)
        db.commit()
        db.refresh(message)
        return message

    @staticmethod
    def get_team_messages(
        db: Session,
        team_id: int,
    ):
        return (
            db.query(Message)
            .filter(
                Message.team_id == team_id,
            )
            .order_by(Message.created_at.asc())
            .all()
        )