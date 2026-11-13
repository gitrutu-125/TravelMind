
from datetime import date
import logging

import httpx

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.config import settings


# Backend error logging
logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/trips",
    tags=["Trip Planning"]
)


# Request model: receives trip details from Flutter
class TripRequest(BaseModel):
    starting_location: str = Field(min_length=2)
    destination: str = Field(min_length=2)
    travel_date: date
    number_of_days: int = Field(ge=1, le=15)
    travellers: int = Field(ge=1, le=10)
    budget: float = Field(gt=0)
    travel_style: str
    interests: list[str]


# Verify whether a location belongs to India
async def verify_indian_location(location: str, field_name: str):

    if not settings.GOOGLE_MAPS_API_KEY:
        logger.error("GOOGLE_MAPS_API_KEY is missing from backend settings.")

        raise HTTPException(
            status_code=503,
            detail="Google Maps API key is not configured."
        )

    url = "https://maps.googleapis.com/maps/api/geocode/json"

    params = {
        "address": location,
        "region": "in",
        "key": settings.GOOGLE_MAPS_API_KEY,
    }

    try:
        async with httpx.AsyncClient(timeout=20.0) as client:
            response = await client.get(url, params=params)

            response.raise_for_status()

            data = response.json()

    except httpx.HTTPStatusError as e:
        logger.exception(
            "Google Geocoding HTTP error. HTTP status: %s",
            e.response.status_code
        )

        raise HTTPException(
            status_code=503,
            detail="Google Geocoding API returned an HTTP error."
        )

    except httpx.RequestError:
        logger.exception("Unable to connect to Google Geocoding API.")

        raise HTTPException(
            status_code=503,
            detail="Unable to connect to Google location verification service."
        )

    except ValueError:
        logger.exception("Google Geocoding returned an invalid response.")

        raise HTTPException(
            status_code=503,
            detail="Invalid response from Google location verification service."
        )

    google_status = data.get("status")

    # Log Google's actual response without exposing the API key
    logger.info("Google Geocoding status: %s", google_status)

    if google_status != "OK":
        google_error = data.get("error_message", "No additional error message")

        logger.error(
            "Google Geocoding API failed. Status: %s | Error: %s",
            google_status,
            google_error
        )

    if google_status == "ZERO_RESULTS":
        raise HTTPException(
            status_code=400,
            detail=f"Invalid {field_name}. Please enter a valid location in India."
        )

    if google_status != "OK":
        raise HTTPException(
            status_code=503,
            detail=(
                f"Google location verification failed. "
                f"Google status: {google_status}. "
                "Check your backend terminal for details."
            )
        )

    # Check all returned results for an Indian country component
    country_codes = []

    for result in data.get("results", []):
        for component in result.get("address_components", []):
            if "country" in component.get("types", []):
                country_codes.append(
                    component.get("short_name", "").upper()
                )

    if "IN" in country_codes:
        logger.info("%s verified as an Indian location.", field_name)
        return True

    if country_codes:
        raise HTTPException(
            status_code=400,
            detail=(
                f"{field_name.capitalize()} must be within India. "
                "TravelMind currently supports Indian locations only."
            )
        )

    raise HTTPException(
        status_code=400,
        detail=(
            f"Could not identify the country for {field_name}. "
            "Please enter a more specific location, such as Pune, Maharashtra."
        )
    )


@router.post("/generate")
async def generate_trip(trip: TripRequest):

    # Verify starting location
    await verify_indian_location(
        trip.starting_location,
        "starting location"
    )

    # Verify destination
    await verify_indian_location(
        trip.destination,
        "destination"
    )

    # Both locations are verified as Indian locations.
    # Actual AI itinerary generation will be added next.

    return {
        "status": "success",
        "message": "Indian locations verified! Trip details received successfully!",
        "trip": {
            "starting_location": trip.starting_location,
            "destination": trip.destination,
            "travel_date": trip.travel_date.isoformat(),
            "number_of_days": trip.number_of_days,
            "travellers": trip.travellers,
            "budget": trip.budget,
            "travel_style": trip.travel_style,
            "interests": trip.interests
        }
    }

from datetime import date
import logging

import httpx

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.config import settings
from app.services.itinerary_service import generate_itinerary


# Backend error logging
logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/trips",
    tags=["Trip Planning"]
)


# Request model: receives trip details from Flutter
class TripRequest(BaseModel):
    starting_location: str = Field(min_length=2)
    destination: str = Field(min_length=2)
    travel_date: date
    number_of_days: int = Field(ge=1, le=15)
    travellers: int = Field(ge=1, le=10)
    budget: float = Field(gt=0)
    travel_style: str
    interests: list[str]


# Verify whether a location belongs to India
async def verify_indian_location(location: str, field_name: str):

    if not settings.GOOGLE_MAPS_API_KEY:
        logger.error("GOOGLE_MAPS_API_KEY is missing from backend settings.")

        raise HTTPException(
            status_code=503,
            detail="Google Maps API key is not configured."
        )

    url = "https://maps.googleapis.com/maps/api/geocode/json"

    params = {
        "address": location,
        "region": "in",
        "key": settings.GOOGLE_MAPS_API_KEY,
    }

    try:
        async with httpx.AsyncClient(timeout=20.0) as client:
            response = await client.get(url, params=params)
            response.raise_for_status()
            data = response.json()

    except httpx.HTTPStatusError as e:
        logger.exception(
            "Google Geocoding HTTP error. HTTP status: %s",
            e.response.status_code
        )

        raise HTTPException(
            status_code=503,
            detail="Google Geocoding API returned an HTTP error."
        )

    except httpx.RequestError:
        logger.exception("Unable to connect to Google Geocoding API.")

        raise HTTPException(
            status_code=503,
            detail="Unable to connect to Google location verification service."
        )

    except ValueError:
        logger.exception("Google Geocoding returned an invalid response.")

        raise HTTPException(
            status_code=503,
            detail="Invalid response from Google location verification service."
        )

    google_status = data.get("status")

    # Log Google's actual response without exposing the API key
    logger.info("Google Geocoding status: %s", google_status)

    if google_status != "OK":
        google_error = data.get(
            "error_message",
            "No additional error message"
        )

        logger.error(
            "Google Geocoding API failed. Status: %s | Error: %s",
            google_status,
            google_error
        )

    if google_status == "ZERO_RESULTS":
        raise HTTPException(
            status_code=400,
            detail=f"Invalid {field_name}. Please enter a valid location in India."
        )

    if google_status != "OK":
        raise HTTPException(
            status_code=503,
            detail=(
                f"Google location verification failed. "
                f"Google status: {google_status}. "
                "Check your backend terminal for details."
            )
        )

    # Check all returned results for an Indian country component
    country_codes = []

    for result in data.get("results", []):
        for component in result.get("address_components", []):
            if "country" in component.get("types", []):
                country_codes.append(
                    component.get("short_name", "").upper()
                )

    if "IN" in country_codes:
        logger.info("%s verified as an Indian location.", field_name)
        return True

    if country_codes:
        raise HTTPException(
            status_code=400,
            detail=(
                f"{field_name.capitalize()} must be within India. "
                "TravelMind currently supports Indian locations only."
            )
        )

    raise HTTPException(
        status_code=400,
        detail=(
            f"Could not identify the country for {field_name}. "
            "Please enter a more specific location, such as Pune, Maharashtra."
        )
    )


@router.post("/generate")
async def generate_trip(trip: TripRequest):

    # Step 1: Verify starting location
    await verify_indian_location(
        trip.starting_location,
        "starting location"
    )

    # Step 2: Verify destination
    await verify_indian_location(
        trip.destination,
        "destination"
    )

    # Step 3: Generate the itinerary
    itinerary = generate_itinerary(
        starting_location=trip.starting_location,
        destination=trip.destination,
        travel_date=trip.travel_date,
        number_of_days=trip.number_of_days,
        travellers=trip.travellers,
        budget=trip.budget,
        travel_style=trip.travel_style,
        interests=trip.interests
    )

    logger.info(
        "Itinerary generated for destination: %s",
        trip.destination
    )

    # Step 4: Return trip details and generated itinerary
    return {
        "status": "success",
        "message": "Your trip itinerary has been generated successfully!",
        "generation_mode": "rule_based_demo",
        "trip": {
            "starting_location": trip.starting_location,
            "destination": trip.destination,
            "travel_date": trip.travel_date.isoformat(),
            "number_of_days": trip.number_of_days,
            "travellers": trip.travellers,
            "budget": trip.budget,
            "travel_style": trip.travel_style,
            "interests": trip.interests
        },
        "itinerary": itinerary
    }
