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

    @staticmethod
    def get_chat_rooms(
        db: Session,
        current_user: User,
    ):
        team_rooms = MessageRepository.get_user_chat_rooms(db, current_user.id)

        # Fetch direct message conversations
        try:
            from app.repositories.direct_message_repository import DirectMessageRepository

            dm_rooms = DirectMessageRepository.get_user_conversations(db, current_user.id)
        except Exception:
            dm_rooms = []

        # Normalize both lists into a single combined list with a common shape
        combined = []

        for dm in dm_rooms:
            combined.append(
                {
                    "kind": "dm",
                    "id": dm["id"],
                    "name": dm["name"],
                    "last_message": dm.get("last_message"),
                    "last_message_time": dm.get("last_message_time"),
                }
            )

        for t in team_rooms:
            combined.append(
                {
                    "kind": "team",
                    "id": t["team_id"],
                    "name": t["team_name"],
                    "last_message": t.get("last_message"),
                    "last_message_time": t.get("last_message_time"),
                }
            )

        # sort combined by last_message_time desc, nulls last
        combined.sort(key=lambda x: x["last_message_time"] or 0, reverse=True)

        return combined