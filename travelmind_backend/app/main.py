
from fastapi import FastAPI

from app.database import Base, engine
from app.routers import auth, trips

# Import models so SQLAlchemy knows about them.
from app.models.user import User


app = FastAPI(
    title="TravelMind API",
    description="Backend API for TravelMind",
    version="1.0.0"
)


Base.metadata.create_all(bind=engine)

# Existing authentication router
app.include_router(auth.router)

# New trip planning router
app.include_router(trips.router)


@app.get("/")
def home():
    return {
        "status": "success",
        "message": "Welcome to TravelMind Backend!"
    }


@app.get("/health")
def health_check():
    return {
        "status": "success",
        "message": "TravelMind backend is running"
    }
