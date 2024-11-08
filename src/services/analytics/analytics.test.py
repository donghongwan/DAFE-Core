# analytics/analytics.test.py

import pytest
from analytics.analytics import track_user_activity, generate_user_report
from database.db import db, User

@pytest.fixture
def setup_database():
    # Setup code to create a test database and add a user
    db.create_all()
    user = User(address='0xTestAddress', balance=100.0)
    db.session.add(user)
    db.session.commit()
    yield
    db.session.remove()
    db.drop_all()

def test_track_user_activity(setup_database):
    track_user_activity('0xTestAddress', 'stake', {'amount': 50})
    # Check if the activity was tracked (you mayneed to implement a way to verify that the activity was recorded in the database)

def test_generate_user_report(setup_database):
    report = generate_user_report('0xTestAddress')
    assert report is not None
    assert report['address'] == '0xTestAddress'
    assert report['balance'] == 100.0
