# main.py

import logging
import asyncio
from config import Config
from utils import initialize_database, start_server, setup_routes
from aiohttp import web

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def init_app():
    """Initialize the application."""
    # Load configuration
    config = Config()

    # Initialize database connection
    db_connection = await initialize_database(config.DB_URI)

    # Create the web application
    app = web.Application()

    # Set up routes
    setup_routes(app, db_connection)

    return app

async def main():
    """Main entry point for the application."""
    try:
        app = await init_app()
        # Start the application server
        runner = web.AppRunner(app)
        await runner.setup()
        site = web.TCPSite(runner, host=Config.SERVER_HOST, port=Config.SERVER_PORT)
        await site.start()
        logger.info(f"DAFE application started successfully at http://{Config.SERVER_HOST}:{Config.SERVER_PORT}")

        # Keep the application running
        while True:
            await asyncio.sleep(3600)  # Sleep for an hour

    except Exception as e:
        logger.error(f"Failed to start the DAFE application: {e}")
        raise

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Shutting down the DAFE application.")
