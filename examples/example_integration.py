# example_integration.py

import requests
import os
import logging
import time
import json

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Load environment variables
API_KEY = os.getenv('WEATHER_API_KEY')  # API key for the weather service
BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

# Cache to store responses
cache = {}

def get_weather(city):
    """Fetch weather data for a given city."""
    if city in cache:
        logging.info(f"Fetching cached data for {city}")
        return cache[city]

    logging.info(f"Fetching weather data for {city}")
    params = {
        'q': city,
        'appid': API_KEY,
        'units': 'metric'
    }

    try:
        response = requests.get(BASE_URL, params=params)
        response.raise_for_status()  # Raise an error for bad responses
        data = response.json()
        cache[city] = data  # Cache the response
        return data
    except requests.exceptions.HTTPError as http_err:
        logging.error(f"HTTP error occurred: {http_err}")
    except Exception as err:
        logging.error(f"An error occurred: {err}")

def display_weather(data):
    """Display weather information."""
    if data is None:
        logging.error("No data to display.")
        return

    city = data['name']
    temperature = data['main']['temp']
    weather_description = data['weather'][0]['description']
    logging.info(f"Weather in {city}: {temperature}°C, {weather_description}")

if __name__ == "__main__":
    while True:
        city = input("Enter city name (or 'exit' to quit): ")
        if city.lower() == 'exit':
            break
        weather_data = get_weather(city)
        display_weather(weather_data)
        time.sleep(1)  # Rate limit to avoid hitting the API too quickly
