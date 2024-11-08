# schemas.py

from marshmallow import Schema, fields

class UserSchema(Schema):
    address = fields.String(required=True)

class StakeSchema(Schema):
    amount = fields.Float(required=True)
    private_key = fields.String(required=True)

class ProposalSchema(Schema):
    recipient = fields.String(required=True)
    amount = fields.Float(required=True)
    description = fields.String(required=True)
    private_key = fields.String(required=True)

class ClaimRewardSchema(Schema):
    private_key = fields.String(required=True)
