from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.user import User
from app.schemas.team import (
    TeamCreate,
    TeamMemberResponse,
    TeamResponse,
    TeamStatusResponse,
    TeamUpdate,
)
from app.services.team_service import TeamService

router = APIRouter(
    prefix="/teams",
    tags=["Teams"],
)


@router.post(
    "",
    response_model=TeamResponse,
)
def create_team(
    team: TeamCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamService.create_team(
        db,
        team,
        current_user,
    )


@router.get(
    "",
    response_model=list[TeamResponse],
)
def get_teams(
    db: Session = Depends(get_db),
):
    return TeamService.get_teams(db)


@router.post("/{team_id}/join")
def join_team(
    team_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamService.join_team(
        db,
        team_id,
        current_user,
    )

@router.delete("/{team_id}/leave")
def leave_team(
    team_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamService.leave_team(
        db,
        team_id,
        current_user,
    )


@router.get(
    "/{team_id}/members",
    response_model=list[TeamMemberResponse],
)
def get_team_members(
    team_id: int,
    db: Session = Depends(get_db),
):
    return TeamService.get_team_members(
        db,
        team_id,
    )

@router.get(
    "/{team_id}/status",
    response_model=TeamStatusResponse,
)
def get_team_status(
    team_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamService.get_team_status(
        db,
        team_id,
        current_user,
    )

@router.put(
    "/{team_id}",
    response_model=TeamResponse,
)
def edit_team(
    team_id: int,
    team: TeamUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamService.edit_team(
        db,
        team_id,
        team,
        current_user,
    )

@router.delete("/{team_id}")
def delete_team(
    team_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamService.delete_team(
        db,
        team_id,
        current_user,
    )
