import json
import logging


logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


def handler(event, context):
    logger.debug(json.dumps(event))
    return {'statusCode': 200, 'headers': {}, 'body': 'OK'}
