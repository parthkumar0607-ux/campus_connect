from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.user import User
from app.schemas.team import TeamInvitationCreate, TeamInvitationResponse, TeamInvitationStatus
from app.services.team_invitation_service import TeamInvitationService

router = APIRouter(prefix="/team-invitations", tags=["Team invitations"])


@router.post("", response_model=TeamInvitationResponse)
def send_invitation(
    invitation: TeamInvitationCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamInvitationService.send(db, invitation.team_id, invitation.receiver_id, current_user)


@router.get("", response_model=list[TeamInvitationResponse])
def get_my_invitations(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamInvitationService.list_for_user(db, current_user)


@router.post("/{invitation_id}/accept", response_model=TeamInvitationResponse)
def accept_invitation(
    invitation_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamInvitationService.respond(db, invitation_id, True, current_user)


@router.post("/{invitation_id}/decline", response_model=TeamInvitationResponse)
def decline_invitation(
    invitation_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return TeamInvitationService.respond(db, invitation_id, False, current_user)
