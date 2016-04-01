from flask import Flask, request
import json
app = Flask(__name__)

SEARCH_PATTERN = "1AJW" #must start with 1
PUBLIC_KEY = "049106abce7220c8b064db7485977022bfcccf7998ba9a94f984c17b3517e660462fa6c4928b4462393ec4fd6a9d5e6483fc6ec8654810120ccae4e140fb172330" #for creating split private keys for securely computing on untrusted computers/sending over network

@app.route('/')
def hello_world():
    return "your connection is working. call /report then /private_key and /report when you've found it."


@app.route('/pattern')
def pattern():
    """Clients call /report?client=theID&status=connectivitycheck
        We should return the search string so the client can begin
        computing addresses for us.
    """
    client_id = request.args.get('client', '')
    status = request.args.get('status', '')
    print('called by client: ' + client_id)


    print('returning search pattern: ' + SEARCH_PATTERN)
    return SEARCH_PATTERN

@app.route('/public_key')
def public_key():
    """If you are sending the app to friends, you're going to want to generate a public key
    so your data is encrypted. Otherwise you're basically sending plaintext keys over insecure networks,
    plus the client computers all potentially have a copy of the keys. TODO: Explain split key pairs."""
    client_id = request.args.get('client', '')
    status = request.args.get('status', '')
    search_pattern = request.args.get('search_pattern', '')
    if search_pattern:
        print(search_pattern)
    print('returning public key: ' + PUBLIC_KEY)
    return PUBLIC_KEY

@app.route('/report')
def report():
    """Here is where the client will call the server when the target vanity address has been found.
    Combine the private key with the private key you used to generate the PUBLIC_KEY"""

    print('PRIVATE KEY FOUND!')
    type = request.args.get('type', '')
    key = request.args.get('key', '')
    print(type)
    print(key)
    return "YOU FOUND THE ADDRESS! THANK YOU SO MUCH!"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
