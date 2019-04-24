# MATLAB Interface *for AWS SNS* API documentation


## AWS SNS Interface Objects and Methods:
* @Client



------

## @Client

### @Client/Client.m
```notalanguage
  CLIENT Object to represent an AWS SNS client
  The client is used to carry out operations with the SNS service
 
  Example:
     % Create client
     sns = aws.sns.Client;
     % Initialize the client
     sns.initialize();
     % Use the client to carry out actions on SNS
     createTopicResult = sns.createTopic('myTopicName');
     % Shutdown the client when no longer needed
     sns.shutdown();

    Reference page in Doc Center
       doc aws.sns.Client




```
### @Client/confirmSubscription.m
```notalanguage
  CONFIRMSUBSCRIPTION Confirms a subscription
  The topic ARN is entered along with the token received in the confirmation
  request message sent by SNS after the subscribe.
  This action is not required for endpoints such as SMS and SQS, but is
  required for email and http/https endpoints.
  To receive the token for the email endpoint the email-json protocol must
  be used. A ConfirmSubscriptionResult object is returned.
 
  Example:
     sns = aws.sns.Client;
     sns.confirmSubscription('arn:aws:sns:us-west-1:74<Redacted>102:SNSMyTopic','54<Redacted>51f')



```
### @Client/createTopic.m
```notalanguage
  CREATETOPIC Creates an AWS SNS topic
  Creates a topic to which notifications can be published. Users can create
  at most 100,000 topics. For more information on SNS limits and
  restrictions see: https://aws.amazon.com/sns/faqs/
  A CreateTopicResult object is returned. The CreateTopicResult.getTopicArn()
  method can be used to return the ARN when sucessful.
 
  Example:
     sns = aws.sns.Client;
     createTopicResult = sns.createTopic('myTopicName')



```
### @Client/deleteTopic.m
```notalanguage
  DELETETOPIC Deletes an AWS SNS topic
  Deletes a topic and all its subscriptions. Deleting a topic might prevent
  some messages previously sent to the topic from being delivered to
  subscribers. Deleting a topic that does not exist does not result in an error.
  A DeleteTopicResult object is returned. The DeleteTopicResult.toString()
  method returns '{}' when successful.
 
  Example:
     sns = aws.sns.Client;
     deleteTopicResult = sns.deleteTopic(topicArn)



```
### @Client/getSubscriptionAttributes.m
```notalanguage
  GETSUBSCRIPTIONATTRIBUTES Get the attributes of a subscription
  A GetSubscriptionAttributesResult object is returned.
 
  Example:
     sns = aws.sns.Client;
     sns.initialize();
     subscribeResult = sns.subscribe(topicArn,'sqs',queueArn);
     subscriptionArn = subscribeResult.getSubscriptionArn();
     getSubscriptionAttributeResult = GetSubscriptionAttributesResult(subscriptionArn);
     attributesMap = getSubscriptionAttributeResult.getAttributes();



```
### @Client/getTopicAttributes.m
```notalanguage
  GETTOPICATTRIBUTES Get the attributes of a topic
  A GetTopicAttributesResult object is returned. Topic attributes may vary
  based on the authorization of the user.
 
  Example:
     sns = aws.sns.Client;
     sns.initialize();
     createTopicResult = sns.createTopic('myTopicName');
     topicArn = createTopicResult.getTopicArn();
     getTopicAttributeResult = GetTopicAttributesResult(topicArn);
     attributesMap = getTopicAttributeResult.getAttributes();



```
### @Client/initialize.m
```notalanguage
  INITIALIZE Configure the MATLAB session to connect to SNS
  Once a client has been configured, initialize is used to validate the
  client configuration and initiate the connection to SNS
 
  Example:
        sns = aws.sns.Client();
        sns.intialize();



```
### @Client/listSubscriptions.m
```notalanguage
  LISTSUBSCRIPTIONS Returns a list of the requester's subscriptions
  Each call returns a limited list of subscriptions, up to 100, it can be far
  less than 100. A ListSubscriptionsResult object is returned.
  If there are more subscriptions a NextToken is returned by the
  ListSubscriptionsResult.getNextToken() method. This token can then be used by
  subsequent calls to listSubscriptions to get further results.
 
  The table returned by listSubscriptionsResult.getSubscriptions() will contain
  entries such as the following under 5 headings:
     subscriptionArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName:7a<Redacted>8f5
     owner: 74<Redacted>02
     protocol: email-json
     endpoint: johnsmith@example.com
     topicArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName



```
### @Client/listTopics.m
```notalanguage
  LISTTOPICS Returns a list of topics.
  Each call returns a limited list of topics, up to 100, it can be far
  less than 100. A ListTopicsResult object is returned.
  If there are more Topics a NextToken is returned by the
  ListTopicsResult.getNextToken() method. This token can then be used by
  subsequent calls to listTopics to get further results.
 
  The table returned by listTopicsResult.getTopics() will contain
  entries such as the following under 2 headings:
     topicArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName
     topicNAme: MyTopicName
 
  Example:
     % Get a list of topics
     listTopicsResult = sns.listTopics();
     resultsTable = listTopicsResult.getTopics;
     % Get topic in Table form
     topicNames = resultsTable.topicName;
     % Check if there are more topics to retrieve
     nextToken = listTopicsResult.getNextToken();
     tf = isempty(nextToken);



```
### @Client/publish.m
```notalanguage
  PUBLISH Publishes a message to an SNS topic
  If a message is sent to a topic, SNS delivers the message to each
  endpoint that is subscribed to the topic. The format of the message
  depends on the notification protocol for each subscribed endpoint.
  When a messageId is returned, the message has been saved and Amazon SNS
  will attempt to deliver it shortly. When publishing a message, the user
  must enter the ARN of the topic along with the message they want to send.
  The message ID is returned as a character vector.
 
  Example:
     messageId = sns.publish('arn:aws:sns:eu-west-1:74<Redacted>102:SNSMyTopic','HelloWorld')



```
### @Client/setTopicAttributes.m
```notalanguage
  SETTOPICATTRIBUTES Set an attribute value for a topic
  Valid values include: Policy, DisplayName and DeliveryPolicy
  This changes the specified value a SetTopicAttributesResult object is returned.
 
  Example:
     % Changing display name of a topic
     displayName = 'MyNewDisplayName';
     setTopicAttributesResult = sns.setTopicAttributes(topicArn,'DisplayName',displayName);
     % Should return '{}' on success
     tf = strcmp(setTopicAttributesResult.toString(), '{}');
     % Get the topic attributes to verify the change
     getTopicAttributesResult = sns.getTopicAttributes(topicArn);
     attributes = getTopicAttributesResult.getAttributes();
     tf = strcmp(attributes('DisplayName'), displayName));



```
### @Client/shutdown.m
```notalanguage
  SHUTDOWN Method to shutdown a client and release resources
  This method should be called to cleanup a client which is no longer
  required.
 
  Example:
     sns = aws.sns.Client;
     % Perform operations using the client then shutdown
     sns.shutdown;



```
### @Client/subscribe.m
```notalanguage
  SUBSCRIBE Subscribes an endpoint to a topic
  Initiates subscription of an endpoint by sending the endpoint a confirmation
  message. To actually create a subscription, the endpoint owner must call
  the ConfirmSubscription action with the token from the confirmation
  message. Confirmation tokens are valid for three days. SQS subscriptions do
  not require confirmation. A subscribeResult object is returned.
 
  Supported delivery protocols include:
    http:        JSON encoded message via HTTP POST
    https:       JSON encoded message via HTTPS POST
    email:       message via SMTP
    email-json:  JSON-encoded message via SMTP
    sms:         message via SMS
    sqs:         JSON encoded message to an Amazon SQS queue
    application: JSON encoded message to an Endpoint ARN for a mobile app and device.
    lambda:      JSON encoded message to an AWS Lambda function
 
  The user will be notified that they are pending confirmation once they
  subscribe to the specified topic.
 
  Note, that if using email protocol, the user has the option of 'email' or
  'email-json'. If the user wishes to receive a token to use the
  confirmSubscription() method they must use 'email-json'.
 
  Example:
     % An SQS subscription that may return 'pending confirmation'
     % normally SQS will confirm immediately however protocols such as
     % email will not
     subscribeResult = sns.subscribe(topicArn,'sqs',queueArn);
     subscriptionArn = subscribeResult.getSubscriptionArn();
     pendingTF = strcmp(subscriptionArn, 'pending confirmation');
     splitSubscriptionArn = strsplit(subscriptionArn, ':');
     subscriptionArnTopicName = splitSubscriptionArn{end-1};
     arnTF = strcmp(topicName, subscriptionArnTopicName);
 
     % Email subscription
     subscribeResult = sns.subscribe('arn:aws:sns:us-west-1:74<Redacted>02:SNSMyTopicName','email-json','johnsmith@example.com');
     subscriptionArn = subscribeResult.getSubscriptionArn();
     pendingTF = strcmp(subscriptionArn, 'pending confirmation');



```
### @Client/unsubscribe.m
```notalanguage
  UNSUBSCRIBE Deletes a subscription to a topic
  Deletes a subscription. If the subscription requires authentication for
  deletion, only the owner of the subscription or the topic's owner can
  unsubscribe, and an AWS signature is required. If the unsubscribe call
  does not require authentication and the requester is not the subscription
  owner, a final cancellation message is delivered to the endpoint, so that
  the endpoint owner can easily resubscribe to the topic if the unsubscribe
  request was unintended. An UnsubscribeResult object is returned.
 
  Example:
     unsubscribeResult = sns.unsubscribe(subscriptionArn);
     tf = strcmp(unsubscribeResult.toString(), '{}'));



```

------
## AWS SNS Interface +model Objects and Methods:
* @ConfirmSubscriptionResult
* @CreateTopicResult
* @DeleteTopicResult
* @GetSubscriptionAttributesResult
* @GetTopicAttributesResult
* @ListSubscriptionsResult
* @ListTopicsResult
* @SetTopicAttributesResult
* @SubscribeResult
* @UnsubscribeResult



------

## @ConfirmSubscriptionResult

### @ConfirmSubscriptionResult/ConfirmSubscriptionResult.m
```notalanguage
  CONFIRMSUBSCRIPTIONRESULT Object to represent the result of a confirmSubscription call

    Reference page in Doc Center
       doc aws.sns.model.ConfirmSubscriptionResult




```

------


## @CreateTopicResult

### @CreateTopicResult/CreateTopicResult.m
```notalanguage
  CREATETOPICRESULT Object to represent the result of a createTopic call

    Reference page in Doc Center
       doc aws.sns.model.CreateTopicResult




```
### @CreateTopicResult/getTopicArn.m
```notalanguage
  GETTOPICARN returns the Amazon Resource Name (ARN) assigned to the topic
  The ARN is returned as a character vector



```

------


## @DeleteTopicResult

### @DeleteTopicResult/DeleteTopicResult.m
```notalanguage
  DELETETOPICRESULT Object to represent the result of a deleteTopic call

    Reference page in Doc Center
       doc aws.sns.model.DeleteTopicResult




```
### @DeleteTopicResult/toString.m
```notalanguage
  TOSTRING Returns a string representation of this object
  This is useful for testing and debugging. Sensitive data will be redacted
  from this string using a placeholder value.
  The result is returned as a character vector.
  '{}' is expected on success.



```

------


## @GetSubscriptionAttributesResult

### @GetSubscriptionAttributesResult/GetSubscriptionAttributesResult.m
```notalanguage
  GETSUBSCRIPTIONATTRIBUTESRESULT Represent the result of a getSubscriptionAttributes call

    Reference page in Doc Center
       doc aws.sns.model.GetSubscriptionAttributesResult




```
### @GetSubscriptionAttributesResult/getAttributes.m
```notalanguage
  GETATTRIBUTES Returns a subscription's attributes
  Attributes are returned as a containers.Map.



```

------


## @GetTopicAttributesResult

### @GetTopicAttributesResult/GetTopicAttributesResult.m
```notalanguage
  GETTOPICATTRIBUTESRESULT Object to represent the result of a getTopicAttributes call

    Reference page in Doc Center
       doc aws.sns.model.GetTopicAttributesResult




```
### @GetTopicAttributesResult/getAttributes.m
```notalanguage
  GETATTRIBUTES Returns a topic's attributes
  Attributes are returned as a containers.Map.



```

------


## @ListSubscriptionsResult

### @ListSubscriptionsResult/ListSubscriptionsResult.m
```notalanguage
  LISTSUBSCRIPTIONSRESULT Object to represent the result of a listSubscriptions call

    Reference page in Doc Center
       doc aws.sns.model.ListSubscriptionsResult




```
### @ListSubscriptionsResult/getNextToken.m
```notalanguage
  GETNEXTTOKEN A token is returned if there are additional subscriptions to retrieve
  The token is returned as a character vector.



```
### @ListSubscriptionsResult/getSubscriptions.m
```notalanguage
  GETSUBSCRIPTIONS Returns a table of subscriptions
  Entries such as the following under 5 headings:
     subscriptionArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName:7a<Redacted>8f5
     owner: 74<Redacted>02
     protocol: email-json
     endpoint: johnsmith@example.com
     topicArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName



```

------


## @ListTopicsResult

### @ListTopicsResult/ListTopicsResult.m
```notalanguage
  LISTTOPICSRESULT Object to represent the result of a listTopics call

    Reference page in Doc Center
       doc aws.sns.model.ListTopicsResult




```
### @ListTopicsResult/getNextToken.m
```notalanguage
  GETNEXTTOKEN A token is returned if there are additional topics to retrieve
  The token is returned as a character vector.



```
### @ListTopicsResult/getTopics.m
```notalanguage
  GETTOPICS Returns a table of topics
  The table has two columns one containing topic ARNs and the other containing
  the topic names.



```

------


## @SetTopicAttributesResult

### @SetTopicAttributesResult/SetTopicAttributesResult.m
```notalanguage
  SETTOPICATTRIBUTESRESULT Object to represent the result of a setTopicAttributes call

    Reference page in Doc Center
       doc aws.sns.model.SetTopicAttributesResult




```
### @SetTopicAttributesResult/toString.m
```notalanguage
  TOSTRING Returns a string representation of this object
  This is useful for testing and debugging. Sensitive data will be redacted
  from this string using a placeholder value.
  The result is returned as a character vector.
  '{}' is expected on success.



```

------


## @SubscribeResult

### @SubscribeResult/SubscribeResult.m
```notalanguage
  SUBSCRIBERESULT Object to represent the result of a subscribe call

    Reference page in Doc Center
       doc aws.sns.model.SubscribeResult




```
### @SubscribeResult/getSubscriptionArn.m
```notalanguage
  GETSUBSCRIPTIONARN Get status of a subscribe call
  The ARN of the subscription if it is confirmed, or the string
  "pending confirmation" if the subscription requires confirmation.



```

------


## @UnsubscribeResult

### @UnsubscribeResult/UnsubscribeResult.m
```notalanguage
  UNSUBSCRIBERESULT Object to represent the result of an unsubscribe call

    Reference page in Doc Center
       doc aws.sns.model.UnsubscribeResult




```
### @UnsubscribeResult/toString.m
```notalanguage
  TOSTRING Returns a string representation of this object
  This is useful for testing and debugging. Sensitive data will be redacted
  from this string using a placeholder value.
  The result is returned as a character vector.
  '{}' is expected on success.



```

------
## AWS Common Objects and Methods:
* @ClientConfiguration
* @Object



------

## @ClientConfiguration

### @ClientConfiguration/ClientConfiguration.m
```notalanguage
  CLIENTCONFIGURATION creates a client network configuration object
  This class can be used to control client behavior such as:
   * Connect to the Internet through proxy
   * Change HTTP transport settings, such as connection timeout and request retries
   * Specify TCP socket buffer size hints
  (Only limited proxy related methods are currently available)
 
  Example:
    s3 = aws.s3.Client();
    s3.clientConfiguration.setProxyHost('proxyHost','myproxy.example.com');
    s3.clientConfiguration.setProxyPort(8080);
    s3.initialize();
 

    Reference page in Doc Center
       doc aws.ClientConfiguration




```
### @ClientConfiguration/setProxyHost.m
```notalanguage
  SETPROXYHOST Sets the optional proxy host the client will connect through.
  This is based on the setting in the MATLAB preferences panel. If the host
  is not set there on Windows then the Windows system preferences will be
  used. The proxy settings may vary based on the URL, thus a sample URL
  should be provided if a specific URL is not known https://s3.amazonaws.com
  is a useful default as it is likely to match the relevant proxy selection
  rules.
 
  Examples:
 
    To have the proxy host automatically set based on the MATLAB preferences
    panel using the default URL of 'https://s3.amazonaws.com:'
        clientConfig.setProxyHost();
 
    To have the proxy host automatically set based on the given URL:
        clientConfig.setProxyHost('autoURL','https://examplebucket.amazonaws.com');
 
    To force the value of the proxy host TO a given value, e.g. myproxy.example.com:
        clientConfig.setProxyHost('proxyHost','myproxy.example.com');
    Note this does not overwrite the value set in the preferences panel.
 
  The s3 client initialization call will invoke setProxyHost();
  to set preference based on the MATLAB preference if the proxyHost value is not
  an empty value.
 



```
### @ClientConfiguration/setProxyPassword.m
```notalanguage
  SETPROXYPASSWORD Sets the optional proxy password.
  This is based on the setting in the MATLAB preferences panel. If the
  preferences password is not set then on Windows the OS system preferences
  will be used.
 
  Examples:
 
    To set the password to a given value:
        clientConfig.setProxyPassword('2312sdsdes?$!%');
    Note this does not overwrite the value set in the preferences panel.
 
    To set the password automatically based on provided preferences:
        clientConfig.setProxyPassword();
 
  The s3 client initialization call will invoke setProxyPassword();
  to set preference based on the MATLAB preference if the proxyPassword value is
  not an empty value.
 
  Note, it is bad practice to store credentials in code, ideally this value
  should be read from a permission controlled file or other secure source
  as required.
 



```
### @ClientConfiguration/setProxyPort.m
```notalanguage
  SETPROXYPORT Sets the optional proxy port the client will connect through.
  This is normally based on the setting in the MATLAB preferences panel. If the
  port is not set there on Windows then the Windows system preferences will be
  used. The proxy settings may vary based on the URL, thus a sample URL
  should be provided if a specific URL is not known https://s3.amazonaws.com
  is a useful default as it is likely to match the relevant proxy selection
  rules.
 
  Examples:
 
    To have the port automatically set based on the default URL of
    https://s3.amazonaws.com:
        clientConfig.setProxyPort();
 
    To have the port automatically set based on the given URL:
        clientConfig.setProxyPort('https://examplebucket.amazonaws.com');
 
    To force the value of the port to a given value, e.g. 8080:
        clientConfig.setProxyPort(8080);
    Note this does not alter the value held set in the preferences panel.
 
  The s3 client initialization call will invoke setProxyPort();
  to set preference based on the MATLAB preference if the proxyPort value is not
  an empty value.
 



```
### @ClientConfiguration/setProxyUsername.m
```notalanguage
  SETPROXYUSERNAME Sets the optional proxy username.
  This is based on the setting in the MATLAB preferences panel. If the
  username is not set there on Windows then the Windows system preferences
  will be used.
 
  Examples:
 
     To set the username to a given value:
         clientConfig.setProxyUsername('JoeProxyUser');
     Note this does not overwrite the value set in the preferences panel.
 
     To set the password automatically based on provided preferences:
         clientConfig.setProxyUsername();
 
  The s3 client initialization call will invoke setProxyUsername();
  to set preference based on the MATLAB preference if the proxyUsername value is
  not an empty value.
 
  Note it is bad practice to store credentials in code, ideally this value
  should be read from a permission controlled file or other secure source
  as required.
 



```

------


## @Object

### @Object/Object.m
```notalanguage
  OBJECT Root object for all the AWS SDK objects

    Reference page in Doc Center
       doc aws.Object




```

------

## AWS Common Related Functions:
### functions/Logger.m
```notalanguage
  Logger - Object definition for Logger
  ---------------------------------------------------------------------
  Abstract: A logger object to encapsulate logging and debugging
            messages for a MATLAB application.
 
  Syntax:
            logObj = Logger.getLogger();
 
  Logger Properties:
 
      LogFileLevel - The level of log messages that will be saved to the
      log file
 
      DisplayLevel - The level of log messages that will be displayed
      in the command window
 
      LogFile - The file name or path to the log file. If empty,
      nothing will be logged to file.
 
      Messages - Structure array containing log messages
 
  Logger Methods:
 
      clearMessages(obj) - Clears the log messages currently stored in
      the Logger object
 
      clearLogFile(obj) - Clears the log messages currently stored in
      the log file
 
      write(obj,Level,MessageText) - Writes a message to the log
 
  Examples:
      logObj = Logger.getLogger();
      write(logObj,'warning','My warning message')
 



```
### functions/aws.m
```notalanguage
  AWS, a wrapper to the AWS CLI utility
 
  The function assumes AWS CLI is installed and configured with authentication
  details. This wrapper allows use of the AWS CLI within the
  MATLAB environment.
 
  Examples:
     aws('s3api list-buckets')
 
  Alternatively:
     aws s3api list-buckets
 
  If no output is specified, the command will echo this to the MATLAB
  command window. If the output variable is provided it will convert the
  output to a MATLAB object.
 
    [status, output] = aws('s3api','list-buckets');
 
      output =
 
        struct with fields:
 
            Owner: [1x1 struct]
          Buckets: [15x1 struct]
 
  By default a struct is produced from the JSON format output.
  If the --output [text|table] flag is set a char vector is produced.
 



```
### functions/homedir.m
```notalanguage
  HOMEDIR Function to return the home directory
  This function will return the users home directory.



```
### functions/isEC2.m
```notalanguage
  ISEC2 returns true if running on AWS EC2 otherwise returns false



```
### functions/loadKeyPair.m
```notalanguage
  LOADKEYPAIR2CERT Reads public and private key files and returns a key pair
  The key pair returned is of type java.security.KeyPair
  Algorithms supported by the underlying java.security.KeyFactory library
  are: DiffieHellman, DSA & RSA.
  However S3 only supports RSA at this point.
  If only the public key is a available e.g. the private key belongs to
  somebody else then we can still create a keypair to encrypt data only
  they can decrypt. To do this we replace the private key file argument
  with 'null'.
 
  Example:
   myKeyPair = loadKeyPair('c:\Temp\mypublickey.key', 'c:\Temp\myprivatekey.key')
 
   encryptOnlyPair = loadKeyPair('c:\Temp\mypublickey.key')
 
 



```
### functions/saveKeyPair.m
```notalanguage
  SAVEKEYPAIR Writes a key pair to two files for the public and private keys
  The key pair should be of type java.security.KeyPair
 
  Example:
    saveKeyPair(myKeyPair, 'c:\Temp\mypublickey.key', 'c:\Temp\myprivatekey.key')
 



```
### functions/unlimitedCryptography.m
```notalanguage
  UNLIMITEDCRYPTOGRAPHY Returns true if unlimited cryptography is installed
  Otherwise false is returned.
  Tests using the AES algorithm for greater than 128 bits if true then this
  indicates that the policy files have been changed to enabled unlimited
  strength cryptography.



```
### functions/writeSTSCredentialsFile.m
```notalanguage
  WRITESTSCREDENTIALSFILE write an STS based credentials file
 
  Write an STS based credential file
 
    tokenCode is the 2 factor authentication code of choice e.g. from Google
    authenticator. Note the command must be issued quickly as this value will
    expire in a number of seconds
 
    serialNumber is the AWS 'arn value' e.g. arn:aws:iam::741<REDACTED>02:mfa/joe.blog
    this can be obtained from the AWS IAM portal interface
 
    region is the AWS region of choice e.g. us-west-1
 
  The following AWS command line interface (CLI) command will return STS
  credentials in json format as follows, Note the required multi-factor (mfa)
  auth version of the arn:
 
  aws sts get-session-token --token-code 631446 --serial-number arn:aws:iam::741<REDACTED>02:mfa/joe.blog
 
  {
      "Credentials": {
          "SecretAccessKey": "J9Y<REDACTED>BaJXEv",
          "SessionToken": "FQoDYX<REDACTED>KL7kw88F",
          "Expiration": "2017-10-26T08:21:18Z",
          "AccessKeyId": "AS<REDACTED>UYA"
      }
  }
 
  This needs to be rewritten differently to match the expected format
  below:
 
  {
      "aws_access_key_id": "AS<REDACTED>UYA",
      "secret_access_key" : "J9Y<REDACTED>BaJXEv",
      "region" : "us-west-1",
      "session_token" : "FQoDYX<REDACTED>KL7kw88F"
  }



```



------------    

[//]: # (Copyright 2019 The MathWorks, Inc.)
