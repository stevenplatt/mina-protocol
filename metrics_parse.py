# this file calls the mina metrics interface and parses the outputs
from prometheus_client.parser import text_string_to_metric_families
import requests

metrics = requests.get("http://localhost:8303/metrics").content

for family in text_string_to_metric_families(metrics):
  for sample in family.samples:
    print("Name: {0} Labels: {1} Value: {2}".format(*sample))