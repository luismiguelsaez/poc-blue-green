import flask
from requests import get

app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/status', methods=['GET'])
def getStatus():
  return "", 200

@app.route('/location', methods=['GET'])
def getLocation():
    result_loc = get('http://ifconfig.co/country')
    result_ip = get('http://ifconfig.co/ip')
    return {"Country":result_loc.text.rstrip(),"Address":result_ip.text.rstrip()}, 200
