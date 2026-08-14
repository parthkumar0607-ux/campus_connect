from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.team_invitation import TeamInvitation
from app.models.team_member import TeamMember
from app.models.user import User
from app.repositories.team_invitation_repository import TeamInvitationRepository
from app.repositories.team_repository import TeamRepository
from app.repositories.user_repository import UserRepository


class TeamInvitationService:
    @staticmethod
    def send(db: Session, team_id: int, receiver_id: int, current_user: User):
        team = TeamRepository.get_team_by_id(db, team_id)
        if not team:
            raise HTTPException(status_code=404, detail="Team not found")
        if team.created_by != current_user.id:
            raise HTTPException(status_code=403, detail="Only the team creator can send invitations")
        if receiver_id == current_user.id:
            raise HTTPException(status_code=400, detail="You cannot invite yourself")
        if not UserRepository.get_by_id(db, receiver_id):
            raise HTTPException(status_code=404, detail="Student not found")
        if TeamRepository.is_member(db, team_id, receiver_id):
            raise HTTPException(status_code=400, detail="Student is already a team member")
        if TeamInvitationRepository.pending_invitation(db, team_id, receiver_id):
            raise HTTPException(status_code=400, detail="An invitation is already pending")

        invitation = TeamInvitation(
            team_id=team_id,
            sender_id=current_user.id,
            receiver_id=receiver_id,
        )
        return TeamInvitationRepository.create(db, invitation)

    @staticmethod
    def list_for_user(db: Session, current_user: User):
        return TeamInvitationRepository.get_user_invitations(db, current_user.id)

    @staticmethod
    def respond(db: Session, invitation_id: int, accept: bool, current_user: User):
        invitation = TeamInvitationRepository.get_pending_by_id(db, invitation_id)
        if not invitation:
            raise HTTPException(status_code=404, detail="Pending invitation not found")
        if invitation.receiver_id != current_user.id:
            raise HTTPException(status_code=403, detail="This invitation is not for you")

        team = TeamRepository.get_team_by_id(db, invitation.team_id)
        if not team:
            raise HTTPException(status_code=404, detail="Team no longer exists")

        if accept:
            if TeamRepository.is_member(db, team.id, current_user.id):
                invitation.status = "accepted"
            elif team.current_members >= team.max_members:
                raise HTTPException(status_code=400, detail="Team is full")
            else:
                db.add(TeamMember(user_id=current_user.id, team_id=team.id))
                team.current_members += 1
                invitation.status = "accepted"
        else:
            invitation.status = "declined"

        db.commit()
        db.refresh(invitation)
        return invitation
