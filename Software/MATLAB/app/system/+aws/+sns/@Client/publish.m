function messageId = publish(obj, topicARN, message)
% PUBLISH Publishes a message to an SNS topic
% If a message is sent to a topic, SNS delivers the message to each
% endpoint that is subscribed to the topic. The format of the message
% depends on the notification protocol for each subscribed endpoint.
% When a messageId is returned, the message has been saved and Amazon SNS
% will attempt to deliver it shortly. When publishing a message, the user
% must enter the ARN of the topic along with the message they want to send.
% The message ID is returned as a character vector.
%
% Example:
%    messageId = sns.publish('arn:aws:sns:eu-west-1:74<Redacted>102:SNSMyTopic','HelloWorld')

% Copyright 2018 The MathWorks, Inc.

% Return error if inputs are not character vectors
if ~ischar(topicARN)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected topicARN of type character vector');
end

if ~ischar(message)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected message of type character vector');
end

% Call the API to publish message
publishResultJ = obj.Handle.publish(topicARN, message);
messageId = char(publishResultJ.getMessageId());

end
