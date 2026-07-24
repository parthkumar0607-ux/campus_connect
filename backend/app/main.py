from app.routers.teams import router as teams_router
from fastapi import FastAPI
from app.models.team import Team
from app.database.database import Base, engine
from app.models.user import User
from app.routers.auth import router as auth_router
from app.routers.users import router as users_router

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="CampusConnect API",
    version="1.0.0",
)

app.include_router(auth_router)
app.include_router(users_router)
app.include_router(teams_router)


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