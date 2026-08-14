from sqlalchemy.orm import Session

from app.models.message import Message
from app.models.team import Team
from app.models.team_member import TeamMember
from app.models.user import User


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
        rows = (
            db.query(Message, User.name.label("sender_name"))
            .join(User, User.id == Message.sender_id)
            .filter(
                Message.team_id == team_id,
            )
            .order_by(
                Message.created_at.asc(),
            )
            .all()
        )

        return [
            {
                "id": message.id,
                "team_id": message.team_id,
                "sender_id": message.sender_id,
                "sender_name": sender_name,
                "content": message.content,
                "created_at": message.created_at,
            }
            for message, sender_name in rows
        ]

    @staticmethod
    def get_user_chat_rooms(
        db: Session,
        user_id: int,
    ):
        teams = (
            db.query(Team)
            .join(
                TeamMember,
                Team.id == TeamMember.team_id,
            )
            .filter(
                TeamMember.user_id == user_id,
            )
            .all()
        )

        chat_rooms = []

        for team in teams:
            last_message = (
                db.query(Message)
                .filter(
                    Message.team_id == team.id,
                )
                .order_by(
                    Message.created_at.desc(),
                )
                .first()
            )

            chat_rooms.append(
                {
                    "team_id": team.id,
                    "team_name": team.title,
                    "last_message": (
                        last_message.content
                        if last_message
                        else None
                    ),
                    "last_message_time": (
                        last_message.created_at
                        if last_message
                        else None
                    ),
                }
            )

        return chat_rooms