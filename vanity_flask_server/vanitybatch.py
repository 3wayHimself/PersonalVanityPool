from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/report')
def report():
    print('GOT IT')
    return 'thanks'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
