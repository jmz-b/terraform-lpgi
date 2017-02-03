import json
import urllib2

def handler(event, context):
    server = 'https://router.project-osrm.org'
    route = event['queryStringParameters']['route'].replace(" ", ";")
    args = (server, route)
    url = '%s/route/v1/driving/%s?steps=true&alternatives=false' % args
    response = urllib2.urlopen(url)
    html = response.read()
    return {'statusCode': 200, 'headers': {}, 'body': html}
    
