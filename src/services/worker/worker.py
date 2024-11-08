# worker/worker.py

from celery import Celery
from flask import Flask
import os

def make_celery(app):
    celery = Celery(app.import_name, backend=app.config['CELERY_RESULT_BACKEND'], broker=app.config['CELERY_BROKER_URL'])
    celery.conf.update(app.config)
    return celery

app = Flask(__name__)
app.config['CELERY_BROKER_URL'] = os.getenv('CELERY_BROKER_URL', 'redis://localhost:6379/0')
app.config['CELERY_RESULT_BACKEND'] = os.getenv('CELERY_RESULT_BACKEND', 'redis://localhost:6379/0')

celery = make_celery(app)

@celery.task
def process_transaction(tx_hash):
    # Logic to process the transaction
    print(f"Processing transaction: {tx_hash}")
    # Here you can add logic to check the transaction status, update the database, etc.
