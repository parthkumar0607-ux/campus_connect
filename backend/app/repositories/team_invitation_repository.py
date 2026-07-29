from sqlalchemy.orm import Session

from app.models.team_invitation import TeamInvitation


class TeamInvitationRepository:

    @staticmethod
    def create(db: Session, invitation: TeamInvitation):
        db.add(invitation)
        db.commit()
        db.refresh(invitation)
        return invitation

    @staticmethod
    def get_by_id(db: Session, invitation_id: int):
        return (
            db.query(TeamInvitation)
            .filter(
                TeamInvitation.id == invitation_id,
            )
            .first()
        )

    @staticmethod
    def get_user_invitations(
        db: Session,
        user_id: int,
    ):
        return (
            db.query(TeamInvitation)
            .filter(
                TeamInvitation.receiver_id == user_id,
            )
            .all()
        )

    @staticmethod
    def pending_invitation(
        db: Session,
        team_id: int,
        receiver_id: int,
    ):
        return (
            db.query(TeamInvitation)
            .filter(
                TeamInvitation.team_id == team_id,
                TeamInvitation.receiver_id == receiver_id,
                TeamInvitation.status == "pending",
            )
            .first()
        )

    @staticmethod
    def save(db: Session):
        db.commit()


@staticmethod
def get_pending_by_id(
    db: Session,
    invitation_id: int,
):
    return (
        db.query(TeamInvitation)
        .filter(
            TeamInvitation.id == invitation_id,
            TeamInvitation.status == "pending",
        )
        .first()
    )

        