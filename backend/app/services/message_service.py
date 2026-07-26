from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.message import Message
from app.models.user import User
from app.repositories.message_repository import MessageRepository
from app.repositories.team_repository import TeamRepository


class MessageService:

    @staticmethod
    def send_message(
        db: Session,
        team_id: int,
        message_data,
        current_user: User,
    ):
        team = TeamRepository.get_team_by_id(
            db,
            team_id,
        )

        if not team:
            raise HTTPException(
                status_code=404,
                detail="Team not found",
            )

        member = TeamRepository.is_member(
            db,
            team_id,
            current_user.id,
        )

        if not member:
            raise HTTPException(
                status_code=403,
                detail="You are not a member of this team.",
            )

        message = Message(
            team_id=team_id,
            sender_id=current_user.id,
            content=message_data.content,
        )

        return MessageRepository.create_message(
            db,
            message,
        )

    @staticmethod
    def get_messages(
        db: Session,
        team_id: int,
        current_user: User,
    ):
        team = TeamRepository.get_team_by_id(
            db,
            team_id,
        )

        if not team:
            raise HTTPException(
                status_code=404,
                detail="Team not found",
            )

        member = TeamRepository.is_member(
            db,
            team_id,
            current_user.id,
        )

        if not member:
            raise HTTPException(
                status_code=403,
                detail="You are not a member of this team.",
            )

        return MessageRepository.get_team_messages(
            db,
            team_id,
        )