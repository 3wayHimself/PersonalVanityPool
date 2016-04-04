from flask import Flask, request
import json
app = Flask(__name__)

# Place your search pattern here, it must START with a 1 otherwise you'll be searching forever
SEARCH_PATTERN = "1AJW"  #eg "1CANADA" (all vanity addresses start with a 1)
# Place your public key (hex) here. This is needed for securely computing on untrusted computers
PUBLIC_KEY = "YOURPUBLICKEYHERE"
USE_SPLIT_KEY = True #If you are setting this to False, you are crazy. Read the README on split-key address generation.

@app.route('/')
def hello_world():
    return "your connection is working. call /pattern then /private_key, and /report when you've found it."


@app.route('/pattern')
def pattern():
    """Clients call /report?client=theID&status=connectivitycheck
        We should return the search string so the client can begin
        computing addresses for us.
    """
    client_id = request.args.get('client', '')
    status = request.args.get('status', '')
    print('called by client: ' + client_id)

    # Just double check to make sure the pattern starts with a 1
    if SEARCH_PATTERN.startswith("1"):
        print('returning search pattern: ' + SEARCH_PATTERN)
        return SEARCH_PATTERN
    else:
        print('ABORTING SEARCH: search pattern ' + SEARCH_PATTERN + ' does not begin with 1')
        return "ABORT"

@app.route('/public_key')
def public_key():
    """If you are sending the app to friends, you're going to want to generate a public key
    so your data is encrypted. Otherwise you're basically sending plaintext keys over insecure networks,
    plus the client computers all potentially have a copy of the keys."""
    search_pattern = request.args.get('search_pattern', '')
    if search_pattern:
        #you could use this section to set a different public key for different pools, but we only support
        #searching for one address at a time for now.
        print(search_pattern)

    if USE_SPLIT_KEY:
        print('returning public key: ' + PUBLIC_KEY)
        return PUBLIC_KEY
    else:
        print('not using public key, this must be a very secure client')
        print('returning OFF to indicate no use of this feature to the client')
        return "OFF"

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
