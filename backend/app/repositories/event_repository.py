from sqlalchemy.orm import Session

from app.models.event import Event
from app.models.event_attendee import EventAttendee
from app.models.user import User


class EventRepository:

    @staticmethod
    def create_event(
        db: Session,
        event: Event,
    ):
        db.add(event)
        db.commit()
        db.refresh(event)
        return event

    @staticmethod
    def get_all_events(
        db: Session,
    ):
        return (
            db.query(Event)
            .order_by(Event.date_time.asc())
            .all()
        )

    @staticmethod
    def get_event_by_id(
        db: Session,
        event_id: int,
    ):
        return (
            db.query(Event)
            .filter(Event.id == event_id)
            .first()
        )

    @staticmethod
    def is_registered(
        db: Session,
        event_id: int,
        user_id: int,
    ):
        return (
            db.query(EventAttendee)
            .filter(
                EventAttendee.event_id == event_id,
                EventAttendee.user_id == user_id,
            )
            .first()
        )

    @staticmethod
    def add_attendee(
        db: Session,
        attendee: EventAttendee,
    ):
        db.add(attendee)

    @staticmethod
    def remove_attendee(
        db: Session,
        attendee: EventAttendee,
    ):
        db.delete(attendee)

    @staticmethod
    def update_event(
        db: Session,
        event: Event,
    ):
        db.commit()
        db.refresh(event)
        return event

    @staticmethod
    def delete_event(
        db: Session,
        event: Event,
    ):
        db.delete(event)

    @staticmethod
    def get_event_attendees(
        db: Session,
        event_id: int,
    ):
        return (
            db.query(User)
            .join(
                EventAttendee,
                User.id == EventAttendee.user_id,
            )
            .filter(
                EventAttendee.event_id == event_id,
            )
            .all()
        )

    @staticmethod
    def commit(
        db: Session,
    ):
        db.commit()