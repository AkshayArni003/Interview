import sys
import requests


def _help_():
    meta_data = {
        'all': 'Provides all the details of your instance',
        'accountId': 'Provides Account Id of your instance',
        'architecture': 'Provides architecture of your instance',
        'availabilityZone': 'Provides Availability Zone of your instance',
        'billingProducts': "Provides Billing Products of your instance",
        'devpayProductCodes': "Provides payable products of your instance",
        'marketplaceProductCodes': "Provides Marketplace details of your instance",
        'imageId': "Provides AMI number/Id of your instance",
        'instanceId': 'Provides instance Id of your instance',
        'instanceType': 'Provides instance type', 'kernelId': "Provides kernelId of your instance",
        'pendingTime': 'Provides pending time of your instance',
        'privateIp': 'Provides Private IP of your instance',
        'ramdiskId': "Provides RAM disk Id of your instance", 'region': 'Provides region of your instance',
        'version': 'Provides version of your instance'
    }
    print("Use any option provided below as a flag to run the script")
    for key, value in meta_data.items():
        print("Option: {} ({})".format(key, value))


def get_meta_data(key="all"):
    url = "http://169.254.169.254/latest/dynamic/instance-identity/document"
    response = requests.get(url)
    if response.status_code == 200:
        response = response.json()
        if key == "all":
            return response
        else:
            if key in response:
                return response[key]
            else:
                return "Please check the key provided \nUse help for more options\n " \
                       "if no key is provided all is considered by default"
    else:
        return "Please try again after sometime"


flag = sys.argv[-1]


if flag == "help":
    _help_()
else:
    if flag != "challenge2.py":
        print(get_meta_data(flag))
    else:
        print(get_meta_data())
