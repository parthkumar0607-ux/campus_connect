from datetime import datetime
from sqlalchemy.orm import Session

from app.models.user import User
from app.models.team import Team
from app.models.event import Event


class StatsService:
    @staticmethod
    def get_counts(db: Session):
        users_count = db.query(User).count()
        teams_count = db.query(Team).count()
        events_count = db.query(Event).count()

        # next upcoming event
        now = datetime.utcnow()
        upcoming = (
            db.query(Event)
            .filter(Event.date_time >= now)
            .order_by(Event.date_time.asc())
            .first()
        )

        upcoming_event = None
        if upcoming:
            upcoming_event = {
                "id": upcoming.id,
                "title": upcoming.title,
                "description": upcoming.description,
                "venue": upcoming.venue,
                "date_time": upcoming.date_time.isoformat(),
            }

        return {
            "users_count": users_count,
            "teams_count": teams_count,
            "events_count": events_count,
            "upcoming_event": upcoming_event,
        }
