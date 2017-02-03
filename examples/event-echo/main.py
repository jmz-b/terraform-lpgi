import json

def handler(event, context):
    return {'statusCode': 200, 'headers': {}, 'body': json.dumps(event)}
