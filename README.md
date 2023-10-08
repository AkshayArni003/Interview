# Interview-Solutions

Challenge 1: Build a 3-tier architecture.

Solution: 3-Tier-Architecture/

Description: 3-Tier-Architecture folder contains providers.tf, userInterface.tf, serverLess.tf, backendDatabase.tf.

1. userInterface.tf: Creates a ec2 instance and required other services like VPC, Subnet, Internet Gateway, LoadBalancer
for handling all the user coming into the application. Application is hosted on EC2 instance.

2. serverLess.tf: Creates S3 bucket for storing all the business logic scripts. Creates lamdba function which handles all the CRUD operations for the application that is hosted on EC2 instance. Creates API Gateway for allowing trigger of lambda function created as HTTPS trigger. The same API is consumed by the application.

3. backendDatabase.tf: Creates AWS RDS instance for postgreSQL and allows it to be accesed by the lambda api's. It has multiple instances for handling more number of read and writes that happens on the database.


Challenge 2: Get the meta data for the instance.

Solution: coding/challenge2.py

Description: Contains 2 functions help and get_meta_data.
1. help function provides details on all the different options that can be provided to get details of instance.
2. get_meta_data queries the details for the particular option provided from the instance and returns back.

Run command: python3 coding/challenge2.py <key>

Where key represents the paramter for which meta data is required.

Example: python3 coding/challenge2.py help

The above command returns all the options which can be used to get meta data from the instance.

Example: python3 coding/challenge2.py all

The above command returns all the meta data of a instance in a json format

Example: python3 coding/challenge2.py accountId

The above command provides the "Account Id" of the praticular instance in String format.


Challenge 3: Get value for given keys from a nested object.

Solution: coding/challenge3.py

Description: Contains 3 different functions
1. main function which runs for different set of test cases.
2. create_test_cases function creates n number of test cases where n can be anything that is specified by the user.
3. get_nested_object_value function returns the final value from the nested object provided against the keys.

Run command: python3 coding/challenge3.py <n>

Where n represents the number of test cases that is required or the code should be run for. 

Example: python3 coding/challenge3.py 10

This particular command runs the code for 10 different test cases and output is displayed on the terminal.['
