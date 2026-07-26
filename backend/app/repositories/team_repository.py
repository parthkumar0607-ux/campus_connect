from sqlalchemy.orm import Session

from app.models.team import Team
from app.models.team_member import TeamMember
from app.models.user import User


class TeamRepository:

    @staticmethod
    def create_team(db: Session, team: Team):
        db.add(team)
        db.commit()
        db.refresh(team)
        return team

    @staticmethod
    def get_all_teams(db: Session):
        return (
            db.query(Team)
            .order_by(Team.created_at.desc())
            .all()
        )

    @staticmethod
    def get_team_by_id(
        db: Session,
        team_id: int,
    ):
        return (
            db.query(Team)
            .filter(Team.id == team_id)
            .first()
        )

    @staticmethod
    def is_member(
        db: Session,
        team_id: int,
        user_id: int,
    ):
        return (
            db.query(TeamMember)
            .filter(
                TeamMember.team_id == team_id,
                TeamMember.user_id == user_id,
            )
            .first()
        )

    @staticmethod
    def add_member(
        db: Session,
        member: TeamMember,
    ):
        db.add(member)

    @staticmethod
    def remove_member(
        db: Session,
        member: TeamMember,
    ):
        db.delete(member)

    @staticmethod
    def update_team(
        db: Session,
        team: Team,
    ):
        db.commit()
        db.refresh(team)
        return team

    @staticmethod
    def get_team_members(
        db: Session,
        team_id: int,
    ):
        return (
            db.query(User)
            .join(
                TeamMember,
                User.id == TeamMember.user_id,
            )
            .filter(
                TeamMember.team_id == team_id,
            )
            .all()
        )

    @staticmethod
    def commit(db: Session):
        db.commit()