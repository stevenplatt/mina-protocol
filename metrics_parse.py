# this file calls the mina metrics interface and parses the outputs
from prometheus_client.parser import text_string_to_metric_families
import requests

metrics = requests.get("http://localhost:8303/metrics").content

print(
'''
========================================================
            
           
                    MINA METRICS     
            
            
========================================================
'''
    )

for family in text_string_to_metric_families(metrics):
  for sample in family.samples:
    # histogram items are pruned in this example, but can be processed with additional text formatting
    if len("{1}".format(*sample)) > 2:
      pass
    else:
      print ("")
      print("{0}: {2}".format(*sample))
      