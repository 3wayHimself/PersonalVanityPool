from flask import Flask, request
import json
app = Flask(__name__)

SEARCH_PATTERN = "1" + "AJWEST1" #must start with 1

@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/report')
def report():
    client_id = request.args.get('client')
    status = request.args.get('status')
    print('called by client: ' + client_id)
    print('status is: ' + status)
    print('returning search pattern: ')
    return SEARCH_PATTERN

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
