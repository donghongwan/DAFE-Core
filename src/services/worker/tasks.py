# worker/tasks.py

from worker import celery
from flask import current_app
from flask_mail import Mail, Message

mail = Mail()

@celery.task
def send_notification(user_address, message):
    with current_app.app_context():
        msg = Message('Notification', sender='noreply@example.com', recipients=[user_address])
        msg.body = message
        mail.send(msg)
        print(f"Notification sent to {user_address}")

@celery.task
def update_user_balance(user_address, new_balance):
    from database.db import db, User
    user = User.query.filter_by(address=user_address).first()
    if user:
        user.balance = new_balance
        db.session.commit()
        print(f"Updated balance for {user_address} to {new_balance}")
