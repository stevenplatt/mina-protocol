# flask is required or this sciprt to run
# on linux flask can be installed with "pip install flask"

# this script assumes that the Mina node is using network ports defined in mina_deploy.sh
# the ip address of the mina node must be passed as an argument when running the sript \
# 

from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
  return 'Hello World!'
if __name__ == '__main__':
  app.run(host='0.0.0.0')