from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.team import Team
from app.models.team_member import TeamMember
from app.models.user import User
from app.repositories.team_repository import TeamRepository


class TeamService:

    @staticmethod
    def create_team(
        db: Session,
        team_data,
        current_user: User,
    ):
        team = Team(
            title=team_data.title,
            description=team_data.description,
            tech_stack=team_data.tech_stack,
            max_members=team_data.max_members,
            current_members=1,
            created_by=current_user.id,
        )

        TeamRepository.create_team(db, team)

        member = TeamMember(
            user_id=current_user.id,
            team_id=team.id,
        )

        TeamRepository.add_member(db, member)
        TeamRepository.commit(db)

        return team

    @staticmethod
    def get_teams(db: Session):
        return TeamRepository.get_all_teams(db)

    @staticmethod
    def join_team(
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

        existing = TeamRepository.is_member(
            db,
            team_id,
            current_user.id,
        )

        if existing:
            raise HTTPException(
                status_code=400,
                detail="You are already a member of this team",
            )

        if team.current_members >= team.max_members:
            raise HTTPException(
                status_code=400,
                detail="Team is full",
            )

        member = TeamMember(
            user_id=current_user.id,
            team_id=team.id,
        )

        TeamRepository.add_member(db, member)

        team.current_members += 1

        TeamRepository.commit(db)

        return {
            "message": "Joined team successfully"
        }

    @staticmethod
    def get_team_members(
        db: Session,
        team_id: int,
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

        return TeamRepository.get_team_members(
            db,
            team_id,
        )

    @staticmethod
    def leave_team(
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

        if team.created_by == current_user.id:
            raise HTTPException(
                status_code=400,
                detail="Team creator cannot leave. Delete the team instead.",
            )

        member = TeamRepository.is_member(
            db,
            team_id,
            current_user.id,
        )

        if not member:
            raise HTTPException(
                status_code=400,
                detail="You are not a member of this team.",
            )

        TeamRepository.remove_member(
            db,
            member,
        )

        team.current_members -= 1

        TeamRepository.commit(db)

        return {
            "message": "Left team successfully",
        }