# Basic Usage

## Creating a client
The first step is to create a client to connect to SNS. The client should then be initialized in order to authenticate it. See [Authentication](Authentication.m) for details on providing authentication credentials.

```
sns = aws.sns.Client();
% Read credentials from a JSON file rather than the AWS provider chain
sns.useCredentialsProviderChain = false;
sns.initialize();
```

## Creating a topic
A topic is a communication channel to send messages and subscribe to notifications. Use the client to create a topic. It provides an access point for publishers and subscribers to communicate with each other.

Create an SNS topic by calling the *createTopic()* method:
```
createTopicResult = sns.createTopic('com-example-myTopic');
topicArn = createTopicResult.getTopicArn();
```
Where *com-example-myTopic* is the requested name of the topic. The topicArn is important and is used for other operations e.g. deleting the topic.


## Listing existing topics
To see existing topics one can list the topics using the *listTopics()* method. *listTopics()* returns a *ListTopicsResult* object which can return a MATLAB table of topic ARNs and names using the *getTopics()* method.

```
listTopicsResult = sns.listTopics();
resultsTable = listTopicsResult.getTopics();
topicNames = resultsTable.topicName;
topicArns = resultsTable.topicArn;
```
A topic ARN has the form: *arn:aws:sns:us-west-1:74<Redacted>102:MyTopicName*. The topic name is the final field in the ARN.


## Deleting a topic
*deleteTopic()* deletes the topic specified by the topic ARN, regardless of the topics contents. Deleting a topic might prevent some messages previously sent to the topic
from being delivered to subscribers. Deleting a topic that does not exist does not result in an error.

```
deleteTopicResult = sns.deleteTopic(topicArn);
```

## Subscribing to a topic
Once a topic has been created, the next step is to subscribe an endpoint to that topic. An endpoint can be a mobile app, web server, email address or an AWS SQS queue that can receive notification messages from AWS SNS. Once subscribed, the endpoint will receive all messages published to that topic. To request a subscription, 3 inputs are required. The topic ARN, the protocol and the endpoint. If carried out successfully the user should be notified that confirmation is pending. Example showing topic ARN, protocol and endpoint:

```
subscribeResult = sns.subscribe('arn:aws:sns:us-west-1:1232345:SNSMyTopicName', 'email-json', 'john.smith@example.com');
subscriptionArn = subscribeResult.getSubscriptionArn()

subscriptionArn =

   'pending confirmation'
 ```
Note that in many cases confirmation to a subscription is required to validate that the endpoint intents to receive notifications. Authorization permitting AWS SQS will not require confirmation and the ARN will be returned immediately.

## Publishing to a topic
Publishing sends a message to an SNS topic which forwards the message to endpoints e.g. sending a text/SMS message. If sending a message to a topic, SNS delivers the message to each endpoint that is subscribed to the topic. The format of the message depends on the notification protocol for each subscribed endpoint. When a messageId is returned, the message has been saved and SNS will attempt to deliver it shortly. When publishing a message, the user must enter the ARN of the topic along with the message they want to send.

```
messageId = sns.publish('arn:aws:sns:eu-west-1:74<Redacted>02:MySNSTopic','HelloWorld');
```

## References
Full details of the supported API can be found in the [API Documentation](SNSApiDoc.md). The following documents are also helpful:
* [AWS API Reference](https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/index.html?com/amazonaws/services/sns/AmazonSNSClient.html)
* [AWS Getting Started with Amazon SNS](https://docs.aws.amazon.com/sns/latest/dg/sns-getting-started.html)


[//]: #  (Copyright 2018 The MathWorks, Inc.)
