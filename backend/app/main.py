from app.routers.auth import router as auth_router
from app.routers.teams import router as teams_router
from app.routers.events import router as events_router
from fastapi import FastAPI
from app.models.user import User
from app.models.team import Team
from app.database.database import Base, engine
from fastapi.middleware.cors import CORSMiddleware


from app.routers.users import router as users_router
from app.models.team_member import TeamMember
from app.models.event import Event
from app.models.event_attendee import EventAttendee

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="CampusConnect API",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:59176",
        "http://localhost:3000",
        "http://localhost:5000",
        "http://127.0.0.1:59176",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:5000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(users_router)
app.include_router(teams_router)
app.include_router(events_router)


@app.get("/")
def root():
    return {
        "message": "CampusConnect Backend Running 🚀"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }