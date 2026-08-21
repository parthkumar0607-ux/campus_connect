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

    @staticmethod
    def get_user_conversations(
        db: Session,
        user_id: int,
    ):
        # Find all distinct conversation partner ids
        sent_to = (
            db.query(DirectMessage.receiver_id)
            .filter(DirectMessage.sender_id == user_id)
            .distinct()
            .all()
        )

        received_from = (
            db.query(DirectMessage.sender_id)
            .filter(DirectMessage.receiver_id == user_id)
            .distinct()
            .all()
        )

        partner_ids = set([r[0] for r in sent_to] + [r[0] for r in received_from])

        conversations = []

        for other_id in partner_ids:
            # get last message between user_id and other_id
            last = (
                db.query(DirectMessage)
                .filter(
                    (
                        (DirectMessage.sender_id == user_id)
                        & (DirectMessage.receiver_id == other_id)
                    )
                    | (
                        (DirectMessage.sender_id == other_id)
                        & (DirectMessage.receiver_id == user_id)
                    )
                )
                .order_by(DirectMessage.created_at.desc())
                .first()
            )

            if last:
                # fetch partner name
                partner = db.query(User).filter(User.id == other_id).first()
                conversations.append(
                    {
                        "type": "dm",
                        "id": other_id,
                        "name": partner.name if partner else f"User {other_id}",
                        "last_message": last.content,
                        "last_message_time": last.created_at,
                    }
                )

        # sort by last_message_time desc
        conversations.sort(key=lambda x: x["last_message_time"], reverse=True)
        return conversations
