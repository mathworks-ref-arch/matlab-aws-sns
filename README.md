# MATLAB Interface *for AWS SNS*

MATLAB® interface for the Amazon Web Services SNS™ service.

## Requirements
### MathWorks products
* Requires MATLAB release R2017a or later.
* AWS Common utilities found at https://github.com/mathworks-ref-arch/matlab-aws-common
* (Recommended) MATLAB Interface *for AWS SQS™* found at https://github.com/mathworks-ref-arch/matlab-aws-sqs

### 3rd party products
* Amazon Web Services account   

To build a required JAR file:   
* [Maven](https://maven.apache.org/)
* JDK 7
* [AWS SDK for Java](https://aws.amazon.com/sdk-for-java/) (version 1.11.367 or later)

## Getting Started
Please refer to the [Documentation](Documentation/README.md) to get started.
The [Installation Instructions](Documentation/Installation.md) and [Getting Started](Documentation/GettingStarted.md) documents provide detailed instructions on setting up and using the interface. The easiest way to
fetch this repository and all required dependencies is to clone the top-level repository using:

```bash
git clone --recursive https://github.com/mathworks-ref-arch/mathworks-aws-support.git
```

### Build the AWS SDK for Java components
The MATLAB code uses the AWS SDK for Java and can be built using:
```bash
cd Software/Java
mvn clean package
```

Once built, use the ```/Software/MATLAB/startup.m``` function to initialize the interface which will use the
AWS Credentials Provider Chain to authenticate. Please see the [relevant documentation](Documentation/Authentication.md)
on how to specify the credentials.

### Publishing to an SNS Topic subscribed to an SQS queue
```matlab
% Create the client
sns = aws.sns.Client();
sns.useCredentialsProviderChain = false;
sns.initialize();

% Create a topic
createTopicResult = sns.createTopic('mySNSTopicName');
topicArn = createTopicResult.getTopicArn();

% List topics
listTopicsResult = sns.listTopics();
topicsTable = listTopicsResult.getTopics();

% Subscribe the topic to an existing SQS queue
subscribeResult = sns.subscribe(topicArn,'sqs',queueArn);
subscriptionArn = subscribeResult.getSubscriptionArn();

% Configure a custom SQS policy to allow publishing, in this case by all accounts
% Requires the installation of the MATLAB Interface for AWS SQS, the
% creation of a queue and an SQS client
keySet = {'Policy'};
policyStr = ['{"Version":"2012-10-17",',...
              '"Id":"',queueName,'/settingSQSDefaultPolicy",',...
              '"Statement":[{',...
              '"Sid":"Allow-send-message-access",',...
              '"Effect":"Allow",',...
              '"Principal":"*",',...
              '"Action":"SQS:SendMessage",',...
              '"Resource":"',queueArn,'"',...
             '}]}'];                     
valueSet = {policyStr};
attributes = containers.Map(keySet,valueSet);
setQueueAttributesResult = sqs.setQueueAttributes(queueUrl, attributes);
% Allow time for attributes to be applied
pause(30);

% Publish a message to the SNS topic
messageId = sns.publish(topicArn, 'My SNS message');

% Allow some time for the message to propagate and
% receive new SQS messages
pause(30);
receiveMessageResult = sqs.receiveMessage(queueUrl);
messages = receiveMessageResult.getMessages();

% Note the body of the SNS message will be in JSON format and so will need to be
% decoded to return the sent message
% body = jsondecode(messages{n}.getBody());
% body.Message
% ans =
%  'My SNS message'

% Delete the topic and shutdown the client
deleteTopicResult = sns.deleteTopic(topicArn);
sns.shutdown();
```

## Supported Products:
1. [MATLAB](https://www.mathworks.com/products/matlab.html) (R2017a or later)
2. [MATLAB Compiler™](https://www.mathworks.com/products/compiler.html) and [MATLAB Compiler SDK™](https://www.mathworks.com/products/matlab-compiler-sdk.html) (R2017a or later)
3. [MATLAB Production Server™](https://www.mathworks.com/products/matlab-production-server.html) (R2017a or later)
4. [MATLAB Parallel Server™](https://www.mathworks.com/products/distriben.html) (R2017a or later)

## License
The license for the MATLAB Interface *for AWS SNS* is available in the [LICENSE.TXT](LICENSE.TXT) file in this GitHub repository. This package uses certain third-party content which is licensed under separate license agreements. See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com` or please log an issue.   

[//]: #  (Copyright 2018 The MathWorks, Inc.)
