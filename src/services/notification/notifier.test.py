# notification/notifier.test.py

import pytest
from flask import Flask
from flask_mail import Mail
from notification.notifier import send_email_notification

@pytest.fixture
def app():
    app = Flask(__name__)
    app.config['MAIL_SERVER'] = 'smtp.example.com'
    app.config['MAIL_PORT'] = 587
    app.config['MAIL_USERNAME'] = 'your_email@example.com'
    app.config['MAIL_PASSWORD'] = 'your_password'
    app.config['MAIL_USE_TLS'] = True
    app.config['MAIL_USE_SSL'] = False
    with app.app_context():
        yield app

def test_send_email_notification(app):
    with app.test_request_context():
        mail = Mail(app)
        result = send_email_notification('test@example.com', 'Test Subject', 'Test Message')
        assert result is None  # Check if the task was queued successfully
