from flask import Flask, request
import json
app = Flask(__name__)

SEARCH_PATTERN = "1" + "AJWEST1" #must start with 1

@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/report')
def report():
    """Clients call /report?client=theID&status=connectivitycheck
        We should return the search string so the client can begin
        computing addresses for us.
    """
    client_id = request.args.get('client')
    status = request.args.get('status')
    print('called by client: ' + client_id)
    print('status is: ' + status)

    if status == 'found':
        print('PRIVATE KEY FOUND!')
        pattern = request.args.get('pattern')
        address = request.args.get('address')
        privkey = request.args.get('privkey')
        print(pattern)
        print(address)
        print(privkey)

    print('returning search pattern: ' + SEARCH_PATTERN)
    return json.dumps({"search_pattern":SEARCH_PATTERN})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
