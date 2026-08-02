from fastapi import HTTPException
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from app.models.event import Event
from app.models.event_attendee import EventAttendee
from app.models.user import User
from app.repositories.event_repository import EventRepository


class EventService:

    @staticmethod
    def create_event(
        db: Session,
        event_data,
        current_user: User,
    ):
        event = Event(
            title=event_data.title,
            description=event_data.description,
            venue=event_data.venue,
            date_time=event_data.date_time,
            max_attendees=event_data.max_attendees,
            current_attendees=1,
            created_by=current_user.id,
        )

        attendee = EventAttendee(
            user_id=current_user.id,
        )

        try:
            db.add(event)
            db.flush()
            attendee.event_id = event.id
            db.add(attendee)
            db.commit()
            db.refresh(event)
        except SQLAlchemyError:
            db.rollback()
            raise

        return event

    @staticmethod
    def get_events(
        db: Session,
    ):
        return EventRepository.get_all_events(
            db,
        )

    @staticmethod
    def register_event(
        db: Session,
        event_id: int,
        current_user: User,
    ):
        event = EventRepository.get_event_by_id(
            db,
            event_id,
        )

        if not event:
            raise HTTPException(
                status_code=404,
                detail="Event not found",
            )

        existing = EventRepository.is_registered(
            db,
            event_id,
            current_user.id,
        )

        if existing:
            raise HTTPException(
                status_code=400,
                detail="Already registered.",
            )

        if (
            event.current_attendees
            >= event.max_attendees
        ):
            raise HTTPException(
                status_code=400,
                detail="Event is full.",
            )

        attendee = EventAttendee(
            user_id=current_user.id,
            event_id=event.id,
        )

        EventRepository.add_attendee(
            db,
            attendee,
        )

        event.current_attendees += 1

        EventRepository.commit(db)

        return {
            "message": "Registered successfully",
        }

    @staticmethod
    def leave_event(
        db: Session,
        event_id: int,
        current_user: User,
    ):
        event = EventRepository.get_event_by_id(
            db,
            event_id,
        )

        if not event:
            raise HTTPException(
                status_code=404,
                detail="Event not found",
            )

        if event.created_by == current_user.id:
            raise HTTPException(
                status_code=400,
                detail="Event creator cannot leave.",
            )

        attendee = EventRepository.is_registered(
            db,
            event_id,
            current_user.id,
        )

        if not attendee:
            raise HTTPException(
                status_code=400,
                detail="You are not registered.",
            )

        EventRepository.remove_attendee(
            db,
            attendee,
        )

        event.current_attendees -= 1

        EventRepository.commit(db)

        return {
            "message": "Registration cancelled",
        }

    @staticmethod
    def get_event_attendees(
        db: Session,
        event_id: int,
    ):
        event = EventRepository.get_event_by_id(
            db,
            event_id,
        )

        if not event:
            raise HTTPException(
                status_code=404,
                detail="Event not found",
            )

        return EventRepository.get_event_attendees(
            db,
            event_id,
        )

    @staticmethod
    def get_event_status(
        db: Session,
        event_id: int,
        current_user: User,
    ):
        event = EventRepository.get_event_by_id(
            db,
            event_id,
        )

        if not event:
            raise HTTPException(
                status_code=404,
                detail="Event not found",
            )

        attendee = EventRepository.is_registered(
            db,
            event_id,
            current_user.id,
        )

        return {
            "registered": attendee is not None,
            "is_creator": event.created_by == current_user.id,
        }

    @staticmethod
    def edit_event(
        db: Session,
        event_id: int,
        event_data,
        current_user: User,
    ):
        event = EventRepository.get_event_by_id(
            db,
            event_id,
        )

        if not event:
            raise HTTPException(
                status_code=404,
                detail="Event not found",
            )

        if event.created_by != current_user.id:
            raise HTTPException(
                status_code=403,
                detail="Only the creator can edit this event.",
            )

        if (
            event.current_attendees
            > event_data.max_attendees
        ):
            raise HTTPException(
                status_code=400,
                detail="Max attendees cannot be less than current attendees.",
            )

        event.title = event_data.title
        event.description = (
            event_data.description
        )
        event.venue = event_data.venue
        event.date_time = (
            event_data.date_time
        )
        event.max_attendees = (
            event_data.max_attendees
        )

        return EventRepository.update_event(
            db,
            event,
        )

    @staticmethod
    def delete_event(
        db: Session,
        event_id: int,
        current_user: User,
    ):
        event = EventRepository.get_event_by_id(
            db,
            event_id,
        )

        if not event:
            raise HTTPException(
                status_code=404,
                detail="Event not found",
            )

        if event.created_by != current_user.id:
            raise HTTPException(
                status_code=403,
                detail="Only the creator can delete this event.",
            )

        EventRepository.delete_event(
            db,
            event,
        )

        EventRepository.commit(db)

        return {
            "message": "Event deleted successfully",
        }
