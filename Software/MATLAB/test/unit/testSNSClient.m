classdef testSNSClient < matlab.unittest.TestCase
    % TESTSNSCLIENT Test for the  MATLAB Interface for Amazon SNS
    %
    % The test suite exercises the basic operations on the SNS Client.

    % Copyright 2018-2021 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        %Create logger reference
        logObj = Logger.getLogger();
    end


    methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();
            testCase.logObj.DisplayLevel = 'verbose';

        end
    end


    methods (Test)
        function testConstructor(testCase)
            write(testCase.logObj,'debug','Testing testConstructor');
            % Create the object
            sns = aws.sns.Client();
            testCase.verifyClass(sns,'aws.sns.Client');
        end


        function testInitialization(testCase)
            write(testCase.logObj,'debug','Testing testInitialization');
            % Create the client and initialize
            sns = aws.sns.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sns.useCredentialsProviderChain = false;
            else
                sns.useCredentialsProviderChain = true;
            end
            sns.initialize();

            testCase.verifyNotEmpty(sns.Handle);
            sns.shutdown();
        end

        function testInitializationOtherCredentials(testCase)
            write(testCase.logObj,'debug','Testing testInitializationOtherCredentials');
            if ~strcmpi(getenv('GITLAB_CI'), 'true')
                warning('Skipping test when not in CI system');                
            else
                % Create the client and initialize using a temp copy of the
                % credentials file in the same directory
                currentCreds = which('credentials.json');
                [pathstr,~,~] = fileparts(currentCreds);

                newCreds = fullfile(pathstr, 'testInitializationOtherCredentials.json');
                copyfile(currentCreds,newCreds);

                sns = aws.sns.Client();
                sns.useCredentialsProviderChain = false;
                sns.credentialsFilePath = newCreds;
                sns.initialize();

                testCase.verifyNotEmpty(sns.Handle);
                delete(newCreds);
                sns.shutdown();
            end
        end

        % Create a topic and ensuring that
        % topic is created by checking that it appears in listTopics output
        function testCreateTopic(testCase)
            write(testCase.logObj,'debug','Testing testCreateTopic');
            % Create the client
            sns = aws.sns.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sns.useCredentialsProviderChain = false;
            else
                sns.useCredentialsProviderChain = true;
            end
            sns.initialize();

            % Verify that empty topic name fails.
            testCase.verifyError(@()sns.createTopic(''),'MATLAB:Java:GenericException');

            % Verify that the illegal topic name fails
            testCase.verifyError(@()sns.createTopic('$ ksks'),'MATLAB:Java:GenericException');

            % Create a Topic
            uniqName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest',datestr(now)],'ReplacementStyle','delete'));
            % Assign output to the new topic
            createTopicResult = sns.createTopic(uniqName);
            topicArn = createTopicResult.getTopicArn();
            splitTopicArn = strsplit(topicArn, ':');
            topicArnName = splitTopicArn{end};
            testCase.verifyEqual(topicArnName, uniqName);

            listTopicsResult = sns.listTopics();
            resultsTable = listTopicsResult.getTopics();
            topicNames = resultsTable.topicName;
            testCase.verifyEqual(sum(strcmp(topicNames, uniqName)), 1);

            % expecting less than 100 topics in the test environment
            testCase.verifyLessThan(height(resultsTable), 100);
            nextToken = listTopicsResult.getNextToken();
            testCase.verifyEqual(nextToken, '');

            % cleanup
            deleteTopicResult = sns.deleteTopic(topicArn);
            testCase.verifyEqual(deleteTopicResult.toString(), '{}');
            sns.shutdown();
        end


        % This function tests deleteTopic, by checking a topic no longer
        % exists in listTopics after deleteTopic command.
        function testDeleteTopic(testCase)
            write(testCase.logObj,'debug','Testing delete topic');
            % Create the client
            sns = aws.sns.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sns.useCredentialsProviderChain = false;
            else
                sns.useCredentialsProviderChain = true;
            end
            sns.initialize();

            % Create a queue
            uniqName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest',datestr(now)],'ReplacementStyle','delete'));
            createTopicResult = sns.createTopic(uniqName);

            % Verify that empty topic name throws error
            testCase.verifyError(@()sns.deleteTopic(''),'MATLAB:Java:GenericException')

            % verify it was created
            topicArn = createTopicResult.getTopicArn();
            splitTopicArn = strsplit(topicArn, ':');
            topicArnName = splitTopicArn{end};
            testCase.verifyEqual(topicArnName, uniqName);

            listTopicsResult = sns.listTopics();
            resultsTable = listTopicsResult.getTopics;
            topicNames = resultsTable.topicName;
            testCase.verifyEqual(sum(strcmp(topicNames, uniqName)), 1);

            % expecting less than 100 topics in the test environment
            % i.e. the result is not further on in the list
            testCase.verifyLessThan(height(resultsTable), 100);
            nextToken = listTopicsResult.getNextToken();
            testCase.verifyEqual(nextToken, '');

            % remove the topic
            deleteTopicResult = sns.deleteTopic(topicArn);
            testCase.verifyEqual(deleteTopicResult.toString(), '{}');

            % verify it was removed
            listTopicsResult = sns.listTopics();
            resultsTable = listTopicsResult.getTopics;
            testCase.verifyLessThan(height(resultsTable), 100);
            topicNames = resultsTable.topicName;
            testCase.verifyEqual(sum(strcmp(topicNames, uniqName)), 0);

            sns.shutdown();
        end

        function testTopicAttributes(testCase)
            write(testCase.logObj,'debug','Testing topic attributes');
            % Create the client
            sns = aws.sns.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sns.useCredentialsProviderChain = false;
            else
                sns.useCredentialsProviderChain = true;
            end
            sns.initialize();

            % Create a topic
            uniqName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest',datestr(now)],'ReplacementStyle','delete'));
            createTopicResult = sns.createTopic(uniqName);
            topicArn = createTopicResult.getTopicArn();
            splitTopicArn = strsplit(topicArn, ':');
            topicArnName = splitTopicArn{end};
            testCase.verifyEqual(topicArnName, uniqName);

            % Get the attributes
            getTopicAttributesResult = sns.getTopicAttributes(topicArn);
            attributes = getTopicAttributesResult.getAttributes();
            testCase.verifyTrue(strcmp(attributes('DisplayName'), ''));
            testCase.verifyTrue(strcmp(attributes('TopicArn'), topicArn));

            % Set attributes & check the result
            displayName = 'MyNewDisplayName';
            setTopicAttributesResult = sns.setTopicAttributes(topicArn,'DisplayName',displayName);
            testCase.verifyTrue(strcmp(setTopicAttributesResult.toString(), '{}'));
            getTopicAttributesResult = sns.getTopicAttributes(topicArn);
            attributes = getTopicAttributesResult.getAttributes();
            testCase.verifyTrue(strcmp(attributes('DisplayName'), displayName));

            % cleanup
            deleteTopicResult = sns.deleteTopic(topicArn);
            testCase.verifyEqual(deleteTopicResult.toString(), '{}');
            sns.shutdown();
        end

        % test listing topics when topic count goes over 100 and thus the nextToken
        % must be used to page through results
        function testlistTopics(testCase)
            write(testCase.logObj,'debug','Testing list topics');
            % Create the client
            sns = aws.sns.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sns.useCredentialsProviderChain = false;
            else
                sns.useCredentialsProviderChain = true;
            end
            sns.initialize();

            % Create a > 100 topics
            write(testCase.logObj,'debug','  creating topics');
            testTopicList = {};
            for n = 1:105
                uniqName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest',datestr(now),num2str(n)],'ReplacementStyle','delete'));
                createTopicResult = sns.createTopic(uniqName);
                topicArn = createTopicResult.getTopicArn();
                splitTopicArn = strsplit(topicArn, ':');
                topicArnName = splitTopicArn{end};
                testCase.verifyEqual(topicArnName, uniqName);
                testTopicList{end+1} = topicArn; %#ok<AGROW>
            end

            write(testCase.logObj,'debug','  listing topics');
            % verify that a table of 100 topics is returned
            listTopicsResult = sns.listTopics();
            resultsTable = listTopicsResult.getTopics;
            testCase.verifyEqual(height(resultsTable), 100);

            % verify that a nextToken is produced
            nextToken = listTopicsResult.getNextToken();
            testCase.verifyNotEqual(nextToken, '');

            % get the remaining topics and verify there are less than 100
            listTopicsResult = sns.listTopics(nextToken);
            resultsTable = listTopicsResult.getTopics;
            testCase.verifyLessThan(height(resultsTable), 100);

            % verify there is no nextToken this time
            nextToken = listTopicsResult.getNextToken();
            testCase.verifyEqual(nextToken, '');

            % cleanup
            write(testCase.logObj,'debug','  deleting topics');
            for n = 1:numel(testTopicList)
                deleteTopicResult = sns.deleteTopic(testTopicList{n});
                testCase.verifyEqual(deleteTopicResult.toString(), '{}');
            end

            sns.shutdown();
        end


        function testSubscribeUnSubscribe(testCase)
            write(testCase.logObj,'debug','Testing subscribe & unsubscribe');
            % Create the clients
            sns = aws.sns.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sns.useCredentialsProviderChain = false;
            else
                sns.useCredentialsProviderChain = true;
            end
            sns.initialize();

            % requires SQS package
            sqs = aws.sqs.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sqs.useCredentialsProviderChain = false;
            else
                sqs.useCredentialsProviderChain = true;
            end
            sqs.initialize();
            testCase.verifyNotEmpty(sqs.Handle);

            % Create a topic and sqs queue with unique name
            write(testCase.logObj,'debug','  creating SNS topic and SQS queue');
            topicName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest.topic',datestr(now)],'ReplacementStyle','delete'));
            createTopicResult = sns.createTopic(topicName);
            topicArn = createTopicResult.getTopicArn();
            splitTopicArn = strsplit(topicArn, ':');
            topicArnName = splitTopicArn{end};
            testCase.verifyEqual(topicArnName, topicName);

            % SQS actions, create queue and return the queueArn
            queueName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest.queue',datestr(now)],'ReplacementStyle','delete'));
            % Create queue ARN and subscribe SQS queue to topic
            createQueueResult = sqs.createQueue(queueName);
            queueUrl = createQueueResult.getQueueUrl();
            testCase.verifyNotEmpty(queueUrl);
            getQueueAttributesResult = sqs.getQueueAttributes(queueUrl, {'All'});
            attributes = getQueueAttributesResult.getAttributes();
            testCase.verifyNotEmpty(attributes);
            queueArn = attributes('QueueArn');

            write(testCase.logObj,'debug','  subscribing');
            subscribeResult = sns.subscribe(topicArn,'sqs',queueArn);
            subscriptionArn = subscribeResult.getSubscriptionArn();
            % the subscriptionArn should contain pending confirmation or be
            % an ARN containing the topic name
            if strcmp(subscriptionArn, 'pending confirmation')
                % in pending state so okay
                testFlag = true;
            elseif strcmp(subscriptionArn(1:12), 'arn:aws:sns:')
                splitSubscriptionArn = strsplit(subscriptionArn, ':');
                subscriptionArnTopicName = splitSubscriptionArn{end-1};
                if strcmp(topicName, subscriptionArnTopicName)
                    testFlag = true;
                else
                    testFlag = false;
                end
            else
                testFlag = false;
            end
            testCase.verifyTrue(testFlag);

            % Get subscription attributes and test some expected values
            getSubscriptionAttributeResult = sns.getSubscriptionAttributes(subscriptionArn);
            attributes = getSubscriptionAttributeResult.getAttributes();
            testCase.verifyTrue(strcmp(attributes('SubscriptionArn'), subscriptionArn));
            testCase.verifyTrue(strcmp(attributes('TopicArn'), topicArn));

            % TODO add confirmation testing (N/A for SQS)
            % confirmSubscriptionResult = sns.confirmSubscription();

            % list the subscriptions
            write(testCase.logObj,'debug','  listing subscriptions');
            % verify that a table of 100 topics is returned
            listSubscriptionsResult = sns.listSubscriptions();
            resultsTable = listSubscriptionsResult.getSubscriptions();
            nextToken = listSubscriptionsResult.getNextToken();
            while ~isempty(nextToken)
                listSubscriptionsResultTmp = sns.listSubscriptions(nextToken);
                resultsTableTmp = listSubscriptionsResultTmp.getSubscriptions();
                % vertically concatenate the tables
                resultsTable = [resultsTable; resultsTableTmp]; %#ok<AGROW>
                nextToken = listSubscriptionsResultTmp.getNextToken();
            end
            % expect less than 100 entries in the test environment
            testCase.verifyLessThan(height(resultsTable), 100);
            % verify there is no nextToken is now ''
            testCase.verifyEqual(nextToken, '');

            % get the subscriptionArn field and verify there is 1 match only
            subscriptionArns = resultsTable.subscriptionArn;
            testCase.verifyEqual(sum(strcmp(subscriptionArns, subscriptionArn)), 1);

            % cleanup subscription
            write(testCase.logObj,'debug','  unsubscribing');
            unsubscribeResult = sns.unsubscribe(subscriptionArn);
            testCase.verifyEqual(unsubscribeResult.toString(), '{}');

            % list the subscriptions again
            listSubscriptionsResult = sns.listSubscriptions();
            resultsTable = listSubscriptionsResult.getSubscriptions();
            nextToken = listSubscriptionsResult.getNextToken();
            while ~isempty(nextToken)
                listSubscriptionsResultTmp = sns.listSubscriptions(nextToken);
                resultsTableTmp = listSubscriptionsResultTmp.getSubscriptions();
                % vertically concatenate the tables
                resultsTable = [resultsTable; resultsTableTmp]; %#ok<AGROW>
                nextToken = listSubscriptionsResultTmp.getNextToken();
            end
            % expect less than 100 entries in the test environment
            testCase.verifyLessThan(height(resultsTable), 100);
            % verify there is no nextToken is now ''
            testCase.verifyEqual(nextToken, '');

            % get the subscriptionArn field and verify there is no match
            subscriptionArns = resultsTable.subscriptionArn;
            testCase.verifyEqual(sum(strcmp(subscriptionArns, subscriptionArn)), 0);

            write(testCase.logObj,'debug','  cleaning up');
            % cleanup queue
            deleteQueueResult = sqs.deleteQueue(queueUrl);
            testCase.verifyTrue(strcmp(deleteQueueResult.toString(), '{}'));
            % cleanup topic
            deleteTopicResult = sns.deleteTopic(topicArn);
            testCase.verifyEqual(deleteTopicResult.toString(), '{}');
            % cleanup clients
            sns.shutdown();
            sqs.shutdown();
        end

        function testPublish(testCase)
            write(testCase.logObj,'debug','Testing publish to topic');
            % Create the client
            sns = aws.sns.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sns.useCredentialsProviderChain = false;
            else
                sns.useCredentialsProviderChain = true;
            end
            sns.initialize();

            % requires SQS package
            sqs = aws.sqs.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                sqs.useCredentialsProviderChain = false;
            else
                sqs.useCredentialsProviderChain = true;
            end
            sqs.initialize();
            testCase.verifyNotEmpty(sqs.Handle);

            % Create a topic and sqs queue with unique name
            write(testCase.logObj,'debug','  creating SNS topic and SQS queue');
            topicName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest.topic',datestr(now)],'ReplacementStyle','delete'));
            createTopicResult = sns.createTopic(topicName);
            topicArn = createTopicResult.getTopicArn();
            splitTopicArn = strsplit(topicArn, ':');
            topicArnName = splitTopicArn{end};
            testCase.verifyEqual(topicArnName, topicName);

            % SQS actions to create a queue and get its ARN
            queueName = lower(matlab.lang.makeValidName(['com.example.awssns.unittest.queue',datestr(now)],'ReplacementStyle','delete'));
            % Create queue ARN and subscribe SQS queue to topic
            createQueueResult = sqs.createQueue(queueName);
            queueUrl = createQueueResult.getQueueUrl();
            testCase.verifyNotEmpty(queueUrl);
            getQueueAttributesResult = sqs.getQueueAttributes(queueUrl, {'All'});
            attributes = getQueueAttributesResult.getAttributes();
            testCase.verifyNotEmpty(attributes);
            queueArn = attributes('QueueArn');
            testCase.verifyNotEmpty(queueArn);

            % Subscribe SQS queue to topic
            write(testCase.logObj,'debug','  subscribing');
            subscribeResult = sns.subscribe(topicArn,'sqs',queueArn);
            subscriptionArn = subscribeResult.getSubscriptionArn();
            % the subscriptionArn should contain pending confirmation or be
            % an ARN containing the topic name
            if strcmp(subscriptionArn, 'pending confirmation')
                % in pending state so okay
                testFlag = true;
            elseif strcmp(subscriptionArn(1:12), 'arn:aws:sns:')
                splitSubscriptionArn = strsplit(subscriptionArn, ':');
                subscriptionArnTopicName = splitSubscriptionArn{end-1};
                if strcmp(topicName, subscriptionArnTopicName)
                    testFlag = true;
                else
                    testFlag = false;
                end
            else
                testFlag = false;
            end
            testCase.verifyTrue(testFlag);

            % % Example of how one might subscribe an email address & mobile phone
            % inputfile = 'input.json';  % default value
            % if exist(inputfile,'file') == 2
            %     input = jsondecode(fileread(which(inputfile)));
            %     phoneNumber = input.phone_number;
            %     emailAddress = input.email_address;
            % end
            % sns.subscribe(topicArn, 'email', emailAddress)
            % sns.subscribe(topicArn, 'sms', phoneNumber)


            % Sample form of a policy
            % Grant One Permission to One AWS Account
            % The following example policy grants AWS account number
            % 111122223333 the SendMessage permission for the queue named
            % 444455556666/queue1 in the US East (Ohio) region.
            % See: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-customer-managed-policy-examples.html
            % for more details
            %
            % {
            %    "Version": "2012-10-17",
            %    "Id": "Queue1_Policy_UUID",
            %    "Statement": [{
            %       "Sid":"Queue1_SendMessage",
            %       "Effect": "Allow",
            %       "Principal": {
            %          "AWS": [
            %             "111122223333"
            %          ]
            %       },
            %       "Action": "sqs:SendMessage",
            %       "Resource": "arn:aws:sqs:us-east-2:444455556666:queue1"
            %    }]
            % }
            %

            write(testCase.logObj,'debug','  setting attributes');
            keySet = {'Policy'};
            % Set a custom policy to allow publish by all accounts
            policyStr = ['{"Version":"2012-10-17",',...
                          '"Id":"',queueName,'/settingSQSDefaultPolicy",',...
                          '"Statement":[{',...
                          '"Sid":"Allow-send-message-access",',...
                          '"Effect":"Allow",',...
                          '"Principal":"*",',...
                          '"Action":"SQS:SendMessage",',...
                          '"Resource":"',queueArn,'"',...
                         '}]}'];
            valueSet = { policyStr };
            attributes = containers.Map(keySet,valueSet);
            setQueueAttributesResult = sqs.setQueueAttributes(queueUrl, attributes);
            testCase.verifyTrue(strcmp(setQueueAttributesResult.toString(), '{}'));
            % allow time for attributes to apply
            pause(30);

            write(testCase.logObj,'debug','  publishing message');
            myMessage = ['HelloWorld ', datestr(now)];
            messageId = sns.publish(topicArn, myMessage);
            % verify that a messageId length string is returned
            testCase.verifyTrue(ischar(messageId));
            testCase.verifyNumElements(messageId, 36);

            % allow time for message to propagate
            % check the sent message is received
            pause(30);
            write(testCase.logObj,'debug','  checking message');
            receiveMessageResult = sqs.receiveMessage(queueUrl);
            messages = receiveMessageResult.getMessages();
            testCase.verifyEqual(numel(messages), 1);
            % This is an SNS message so the body will be a JSON payload
            % from which we want to check some fields
            bodyJSON = messages{1}.getBody();
            body = jsondecode(bodyJSON);
            testCase.verifyTrue(strcmp(body.Message, myMessage));
            testCase.verifyTrue(strcmp(body.Type, 'Notification'));
            % check the SNS message Id
            testCase.verifyTrue(strcmp(body.MessageId, messageId));
            % one is an SQS id the other SNS these should npt match
            testCase.verifyFalse(strcmp(messages{1}.getMessageId(), messageId));

            write(testCase.logObj,'debug','  cleaning up');
            % cleanup subscription
            unsubscribeResult = sns.unsubscribe(subscriptionArn);
            testCase.verifyEqual(unsubscribeResult.toString(), '{}');
            % cleanup queue
            deleteQueueResult = sqs.deleteQueue(queueUrl);
            testCase.verifyTrue(strcmp(deleteQueueResult.toString(), '{}'));
            % cleanup topic
            deleteTopicResult = sns.deleteTopic(topicArn);
            testCase.verifyEqual(deleteTopicResult.toString(), '{}');
            % cleanup clients
            sns.shutdown();
            sqs.shutdown();
        end

    end
end
