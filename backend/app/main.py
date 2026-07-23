from fastapi import FastAPI

app = FastAPI(
    title="CampusConnect API",
    version="1.0.0",
    description="Backend API for CampusConnect",
)


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