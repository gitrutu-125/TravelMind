
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

# Google authentication
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests

# Database and models
from app.database import get_db
from app.models.user import User

# Authentication schemas
from app.schemas.auth_schema import (
    RegisterRequest,
    LoginRequest,
    AuthResponse,
    UserResponse,
    GoogleLoginRequest
)

# Security functions
from app.core.security import (
    hash_password,
    verify_password,
    create_access_token
)

# Current user dependency
from app.core.dependencies import get_current_user

# Application settings
from app.config import settings


router = APIRouter(
    prefix="/api/auth",
    tags=["Authentication"]
)


# ============================================================
# 1. EMAIL REGISTRATION
# ============================================================

@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED
)
def register_user(
    request: RegisterRequest,
    db: Session = Depends(get_db)
):

    # Check whether email already exists.
    existing_user = db.query(User).filter(
        User.email == request.email
    ).first()

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email is already registered"
        )

    # Create a new user.
    new_user = User(
        name=request.name.strip(),
        email=request.email,
        hashed_password=hash_password(request.password),
        auth_provider="email"
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


# ============================================================
# 2. EMAIL LOGIN
# ============================================================

@router.post("/login", response_model=AuthResponse)
def login_user(
    request: LoginRequest,
    db: Session = Depends(get_db)
):

    user = db.query(User).filter(
        User.email == request.email
    ).first()

    if (
        not user
        or not user.hashed_password
        or not verify_password(
            request.password,
            user.hashed_password
        )
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Your account is inactive"
        )

    token = create_access_token(user.id)

    return {
        "access_token": token,
        "token_type": "bearer",
        "user": user
    }


# ============================================================
# 3. GOOGLE LOGIN
# ============================================================

@router.post("/google", response_model=AuthResponse)
def google_login(
    request: GoogleLoginRequest,
    db: Session = Depends(get_db)
):

    # Verify Google ID token.
    try:
        google_user = id_token.verify_oauth2_token(
            request.id_token,
            google_requests.Request(),
            settings.GOOGLE_CLIENT_ID
        )

    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Google ID token"
        )

    # Extract Google account information.
    google_sub = google_user.get("sub")
    email = google_user.get("email")
    email_verified = google_user.get("email_verified", False)
    name = google_user.get("name") or "TravelMind User"

    # Check verified Google account.
    if not google_sub or not email or not email_verified:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Google account email is not verified"
        )

    # First, look for an existing Google account.
    user = db.query(User).filter(
        User.google_sub == google_sub
    ).first()

    if not user:

        # Check whether the email already belongs to an account.
        user = db.query(User).filter(
            User.email == email
        ).first()

        if user:

            # Link verified Google identity to existing account.
            if user.google_sub and user.google_sub != google_sub:
                raise HTTPException(
                    status_code=status.HTTP_409_CONFLICT,
                    detail="This email is linked to another Google account"
                )

            user.google_sub = google_sub

        else:

            # Create a new Google user.
            user = User(
                name=name,
                email=email,
                google_sub=google_sub,
                hashed_password=None,
                auth_provider="google"
            )

            db.add(user)

        db.commit()
        db.refresh(user)

    # Check account status.
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Your account is inactive"
        )

    # Generate TravelMind JWT token.
    token = create_access_token(user.id)

    return {
        "access_token": token,
        "token_type": "bearer",
        "user": user
    }


# ============================================================
# 4. GET CURRENT USER PROFILE
# ============================================================

@router.get("/me", response_model=UserResponse)
def get_my_profile(
    current_user: User = Depends(get_current_user)
):

    return current_user
