import os
import logging


logger = logging.getLogger()


def Response(status, headers={}, body=''):
    """
    create a valid apigateway lambda proxy integration response object
    """

    return {'statusCode': status, 'headers': headers, 'body': body}


def subscribe_handler(event):
    """
    if the event contains a valid fbm subscription query, return a 200 response
    with the hub.challenge query parameter as the body
    """

    qp = event['queryStringParameters'] or {}

    # internal server error if environment is badly configured
    if not os.environ.get('fbm_verify_token', None):
        err = 'missing environment variable: fbm_verify_token'
        logger.error(err)
        return Response(500, body=err)

    # bad request if missing required query paramters
    if not ({'hub.mode', 'hub.challenge', 'hub.verify_token'} <= set(qp)):
        return Response(400, body='missing query string parameter(s)')

    if qp['hub.mode'] == 'subscribe' and \
            qp['hub.verify_token'] == os.environ['fbm_verify_token']:
        return Response(200, body=qp['hub.challenge'])
    # forbidden if bad verify token
    else:
        info = 'invalid verify token'
        logger.info(info)
        return Response(403, body=info)


def method_router(event):
    """
    map the `event` `httpMethod` attribute to a handler function
    """

    method_routes = {
        'GET': subscribe_handler,
        'POST': lambda: Response(200), # do nothing
    }

    def undefined_handler(event):
        Response(405, body='bad method')

    method = event.get('httpMethod', None)
    method_handler = method_routes.get(method, undefined_handler)
    return method_handler(event)


def handler(event, context):
    """
    entry point. handle requests to the root path, return a `404` for
    everything else
    """

    logger.setLevel(logging.DEBUG)

    # call methods router for root path
    if event['path'] == '/':
        return method_router(event)
    # not found for all other paths
    else:
        return Response(404, body='nothing to see here')
