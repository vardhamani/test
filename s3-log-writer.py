import json
import logging
import boto3
import uuid
import os
from datetime import datetime, timezone

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)
ACCOUNT = os.getenv('ACCOUNT')
ENVIRONMENT = os.getenv('ENVIRONMENT')

s3 = boto3.client("s3")
BUCKET = "mlx-cloud-plat-automation-s3-logs"

REQUIRED_FIELDS = ["botId", "ownerEmails", "resources"]

# # ---------------------------Helper Funtions------------------------------------ # #

# parse the event body
def parse(event) -> dict:
    if isinstance(event.get("body"), str):
        return json.loads(event["body"])
    return event.get("body", event)

# validation error execption
class ValidationError(Exception):
    pass

# validate the event body
def validate(payload: dict):
    # validate required feilds
    for field in REQUIRED_FIELDS:
        if not payload.get(field):
            e = f"Missing required field: {field}"
            logging.error(e)
            raise ValidationError(e)
        
    # ownerEmails must be a non-empty list
    owner_emails = payload["ownerEmails"]
    if not isinstance(owner_emails, list) or len(owner_emails) == 0:
        e = "ownerEmails must be a non-empty list of email strings"
        logging.error(e)
        raise ValidationError(e)
    
    # validate email
    invalid = [e for e in owner_emails if "@" not in e]
    if invalid:
        e = f"Invalid email(s) in ownerEmails: {invalid}"
        logging.error(e)
        raise ValidationError(e)
        
    # Resources must be non-empty list
    if not isinstance(payload["resources"], list) or len(payload["resources"]) == 0:
        e = "resources must be a non-empty list"
        logging.error(e)
        raise ValidationError(e)

    # # Each resource must have resourceId
    # for i, r in enumerate(payload["resources"]):
    #     if not r.get("resourceId"):
    #         e = f"Resource at index {i} missing resourceId"
    #         logging.error(e)
    #         raise ValidationError(e)

# write to S3
def write(payload: dict) -> list[str]:
    """
    Write one S3 file per owner email.
    """
    bot_id    = payload["botId"]
    notif_id  = str(uuid.uuid4())
    queued_at = datetime.now(timezone.utc).isoformat()
    written   = []

    for email in payload["ownerEmails"]:
        owner_id = email.replace("@", "at").replace(".", "_")
        key      = f"notifications/{bot_id}/pending/{owner_id}_{notif_id}.json"

        record = {
            **payload,
            "ownerEmail":       email,          # single email for this file
            "notificationId":   notif_id,
            "status":           "PENDING",
            "queuedAt":         queued_at
        }

        s3.put_object(
            Bucket=BUCKET,
            Key=key,
            Body=json.dumps(record, indent=2, default=str),
            ContentType="application/json"
        )
        logging.info(f"Written: {key}")
        written.append(key)

    return written

# # ---------------------------Lambda Handler------------------------------------ # #

def lambda_handler(event, context):
    logging.info(f"event is {event}")
    logging.info(f"context is {context}")

    response = {}
    status_code = 500
    msg = ''
    result = ''

    # ------- Code ------- #
    try:
        payload = parse(event)
        logging.info('VALIDATING')
        validate(payload)
        logging.info('WRITING TO S3')
        key = write(payload)
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Queued", "key": key})
        }
    except ValidationError as e:
        logging.error(f"Error: {e}")
        return {"statusCode": 400, "body": json.dumps({"error": str(e)})}
    except Exception as e:
        logging.error(f"Error: {e}")
        return {"statusCode": 500, "body": json.dumps({"error": "Gateway error"})}

    # ------- Response ------- #

if _name_ == "_main_":
    lambda_handler()
