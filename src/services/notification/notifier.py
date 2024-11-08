# notification/notifier.py

from flask import current_app
from flask_mail import Mail, Message
from celery import shared_task

mail = Mail()

@shared_task
def send_email_notification(user_email, subject, message):
    with current_app.app_context():
        msg = Message(subject, sender='noreply@example.com', recipients=[user_email])
        msg.body = message
        mail.send(msg)
        print(f"Email sent to {user_email} with subject: {subject}")

def notify_user(user_email, notification_type, data):
    if notification_type == 'transaction':
        subject = "Transaction Update"
        message = f"Your transaction has been processed: {data['transaction_hash']}"
    elif notification_type == 'stake':
        subject = "Stake Confirmation"
        message = f"You have successfully staked {data['amount']} tokens."
    else:
        subject = "Notification"
        message = "You have a new notification."

    send_email_notification.delay(user_email, subject, message)
