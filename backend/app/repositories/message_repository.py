from sqlalchemy.orm import Session

from app.models.message import Message
from app.models.team import Team
from app.models.team_member import TeamMember


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
            .order_by(
                Message.created_at.asc(),
            )
            .all()
        )

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