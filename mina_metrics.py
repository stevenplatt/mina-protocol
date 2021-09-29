# prerequisites can be installed with "pip install flask prometheus_client requests"

# this script assumes that the Mina node is using network ports defined in mina_deploy.sh
# the ip address of the mina node must be passed as an argument when running the sript

# this script is run using the format "python mina_metrics.py [URL_TARGET]" 
# example: "python mina_metrics.py http://127.0.0.1:8303/metrics"

from flask import Flask
from flask import render_template
from prometheus_client.parser import text_string_to_metric_families
import requests
import argparse
import os
import sys

app = Flask(__name__)

@app.route("/")
def metrics():

    # Create the parser
    my_parser = argparse.ArgumentParser(description='Collect and display Mina node metrics')

    # Add the arguments
    my_parser.add_argument('URL', metavar='url', type=str, help='mina node metrics url')
    
    # Execute the parse_args() method
    args = my_parser.parse_args()
    target = args.URL
    
    metrics = requests.get(target).content
    dashboard = {}

    for family in text_string_to_metric_families(metrics):
        for sample in family.samples:
            # histogram items are pruned in this example, but can be processed with additional text formatting
            if len("{1}".format(*sample)) > 2:
                pass
            else:
                dashboard["{0}".format(*sample).replace('Coda_', '')] = "{2}".format(*sample)
    return render_template('metrics.html', dashboard=dashboard)

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=8304)