function subscribeResult = subscribe(obj, topicARN, protocol, endpoint)
% SUBSCRIBE Subscribes an endpoint to a topic
% Initiates subscription of an endpoint by sending the endpoint a confirmation
% message. To actually create a subscription, the endpoint owner must call
% the ConfirmSubscription action with the token from the confirmation
% message. Confirmation tokens are valid for three days. SQS subscriptions do
% not require confirmation. A subscribeResult object is returned.
%
% Supported delivery protocols include:
%   http:        JSON encoded message via HTTP POST
%   https:       JSON encoded message via HTTPS POST
%   email:       message via SMTP
%   email-json:  JSON-encoded message via SMTP
%   sms:         message via SMS
%   sqs:         JSON encoded message to an Amazon SQS queue
%   application: JSON encoded message to an Endpoint ARN for a mobile app and device.
%   lambda:      JSON encoded message to an AWS Lambda function
%
% The user will be notified that they are pending confirmation once they
% subscribe to the specified topic.
%
% Note, that if using email protocol, the user has the option of 'email' or
% 'email-json'. If the user wishes to receive a token to use the
% confirmSubscription() method they must use 'email-json'.
%
% Example:
%    % An SQS subscription that may return 'pending confirmation'
%    % normally SQS will confirm immediately however protocols such as
%    % email will not
%    subscribeResult = sns.subscribe(topicArn,'sqs',queueArn);
%    subscriptionArn = subscribeResult.getSubscriptionArn();
%    pendingTF = strcmp(subscriptionArn, 'pending confirmation');
%    splitSubscriptionArn = strsplit(subscriptionArn, ':');
%    subscriptionArnTopicName = splitSubscriptionArn{end-1};
%    arnTF = strcmp(topicName, subscriptionArnTopicName);
%
%    % Email subscription
%    subscribeResult = sns.subscribe('arn:aws:sns:us-west-1:74<Redacted>02:SNSMyTopicName','email-json','johnsmith@example.com');
%    subscriptionArn = subscribeResult.getSubscriptionArn();
%    pendingTF = strcmp(subscriptionArn, 'pending confirmation');

% Copyright 2018 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(topicARN)
    write(logObj,'error','Expected topicARN of type character vector');
end

if ~ischar(protocol)
    write(logObj,'error','Expected protocol of type character vector');
end

if ~ischar(endpoint)
    write(logObj,'error','Expected endpoint of type character vector');
end

% subscribe to the topic
subscribeResultJ = obj.Handle.subscribe(topicARN, protocol, endpoint);
subscribeResult = aws.sns.model.SubscribeResult(subscribeResultJ);

end
