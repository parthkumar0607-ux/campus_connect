from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.user import User
from app.schemas.event import (
    EventAttendeeResponse,
    EventCreate,
    EventResponse,
    EventStatusResponse,
    EventUpdate,
)
from app.services.event_service import EventService

router = APIRouter(
    prefix="/events",
    tags=["Events"],
)


@router.post(
    "",
    response_model=EventResponse,
)
def create_event(
    event: EventCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return EventService.create_event(
        db,
        event,
        current_user,
    )


@router.get(
    "",
    response_model=list[EventResponse],
)
def get_events(
    db: Session = Depends(get_db),
):
    return EventService.get_events(db)


@router.put(
    "/{event_id}",
    response_model=EventResponse,
)
def edit_event(
    event_id: int,
    event: EventUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return EventService.edit_event(
        db,
        event_id,
        event,
        current_user,
    )


@router.delete(
    "/{event_id}",
)
def delete_event(
    event_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return EventService.delete_event(
        db,
        event_id,
        current_user,
    )


@router.post(
    "/{event_id}/register",
)
def register_event(
    event_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return EventService.register_event(
        db,
        event_id,
        current_user,
    )


@router.delete(
    "/{event_id}/leave",
)
def leave_event(
    event_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return EventService.leave_event(
        db,
        event_id,
        current_user,
    )


@router.get(
    "/{event_id}/attendees",
    response_model=list[EventAttendeeResponse],
)
def get_event_attendees(
    event_id: int,
    db: Session = Depends(get_db),
):
    return EventService.get_event_attendees(
        db,
        event_id,
    )


@router.get(
    "/{event_id}/status",
    response_model=EventStatusResponse,
)
def get_event_status(
    event_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return EventService.get_event_status(
        db,
        event_id,
        current_user,
    )