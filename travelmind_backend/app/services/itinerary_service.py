
from datetime import date, timedelta


# Activity suggestions for each interest.
# These are general suggestions, not verified attractions at the destination.
INTEREST_ACTIVITIES = {
    "nature": {
        "morning": "Explore a nearby natural attraction or scenic viewpoint.",
        "afternoon": "Spend time in a garden, nature area, or peaceful outdoor location.",
        "evening": "Enjoy a relaxed nature walk and capture photographs."
    },
    "adventure": {
        "morning": "Explore an outdoor adventure activity suitable for your location.",
        "afternoon": "Plan an adventure experience with a local activity provider.",
        "evening": "Relax after your activities and explore the local area."
    },
    "beaches": {
        "morning": "Visit a nearby beach and enjoy the coastal surroundings.",
        "afternoon": "Explore beachside activities and local coastal attractions.",
        "evening": "Enjoy the sunset at a suitable public beach."
    },
    "culture": {
        "morning": "Explore a local heritage site or cultural attraction.",
        "afternoon": "Discover local history, architecture, and traditions.",
        "evening": "Experience a cultural performance or local neighbourhood."
    },
    "food": {
        "morning": "Try a popular local breakfast and regional specialities.",
        "afternoon": "Explore local food markets and traditional dishes.",
        "evening": "Enjoy dinner at a local restaurant."
    },
    "shopping": {
        "morning": "Explore local markets and shopping streets.",
        "afternoon": "Visit local shops for regional products and souvenirs.",
        "evening": "Enjoy an evening market or shopping area."
    }
}


STYLE_SUGGESTIONS = {
    "adventure": "Keep an active schedule and allow time for outdoor experiences.",
    "relaxation": "Keep the schedule light and leave enough time to rest.",
    "relaxed": "Keep the schedule light and leave enough time to rest.",
    "budget": "Prefer affordable activities, public transport, and budget-friendly meals.",
    "luxury": "Consider comfortable transport, premium experiences, and quality dining.",
    "family": "Prefer family-friendly activities and allow breaks between visits.",
    "cultural": "Give more time to heritage sites, local traditions, and cultural experiences."
}


def generate_itinerary(
    starting_location: str,
    destination: str,
    travel_date: date,
    number_of_days: int,
    travellers: int,
    budget: float,
    travel_style: str,
    interests: list[str]
) -> dict:

    # Normalize interests and travel style.
    selected_interests = [
        interest.strip().lower()
        for interest in interests
        if interest.strip()
    ]

    selected_interests = [
        interest for interest in selected_interests
        if interest in INTEREST_ACTIVITIES
    ]

    if not selected_interests:
        selected_interests = ["nature", "culture", "food"]

    normalized_style = travel_style.strip().lower()

    style_suggestion = STYLE_SUGGESTIONS.get(
        normalized_style,
        "Balance sightseeing, activities, meals, and rest."
    )

    daily_plan = []

    for day_number in range(1, number_of_days + 1):

        # Rotate through the selected interests.
        interest = selected_interests[
            (day_number - 1) % len(selected_interests)
        ]

        activities = INTEREST_ACTIVITIES[interest]

        current_date = travel_date + timedelta(days=day_number - 1)

        daily_plan.append({
            "day": day_number,
            "date": current_date.isoformat(),
            "theme": interest.capitalize(),
            "morning": activities["morning"],
            "afternoon": activities["afternoon"],
            "evening": activities["evening"],
            "travel_tip": style_suggestion
        })

    # Budget allocation: the entered budget is treated as the
    # total budget for the entire group, not per traveller.
    budget_percentages = {
        "accommodation": 0.35,
        "food": 0.25,
        "transport": 0.25,
        "activities_and_other": 0.15
    }

    budget_allocation = {
        category: round(budget * percentage, 2)
        for category, percentage in budget_percentages.items()
    }

    # Correct any rounding difference so the allocation adds up
    # exactly to the entered budget.
    allocated_total = sum(budget_allocation.values())
    budget_allocation["activities_and_other"] = round(
        budget_allocation["activities_and_other"]
        + budget - allocated_total,
        2
    )

    return {
        "title": f"{number_of_days}-Day Trip to {destination}",
        "starting_location": starting_location,
        "destination": destination,
        "travel_date": travel_date.isoformat(),
        "return_date": (
            travel_date + timedelta(days=number_of_days - 1)
        ).isoformat(),
        "number_of_days": number_of_days,
        "travellers": travellers,
        "travel_style": travel_style,
        "interests": interests,
        "daily_plan": daily_plan,
        "budget_plan": {
            "currency": "INR",
            "budget_scope": "Total budget for all travellers",
            "total_budget": round(budget, 2),
            "allocation": budget_allocation
        },
        "important_note": (
            "This is a rule-based sample itinerary. Activity suggestions "
            "are not verified destination attractions. Check local "
            "availability, safety, opening hours, and prices before travel. "
            "Budget allocations are planning estimates, not confirmed costs."
        )
    }
