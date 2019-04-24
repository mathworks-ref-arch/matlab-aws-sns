function createTopicResult = createTopic(obj, topicName)
% CREATETOPIC Creates an AWS SNS topic
% Creates a topic to which notifications can be published. Users can create
% at most 100,000 topics. For more information on SNS limits and
% restrictions see: https://aws.amazon.com/sns/faqs/
% A CreateTopicResult object is returned. The CreateTopicResult.getTopicArn()
% method can be used to return the ARN when sucessful.
%
% Example:
%    sns = aws.sns.Client;
%    createTopicResult = sns.createTopic('myTopicName')

% Copyright 2018 The MathWorks, Inc.

% Return error if input is not character vector
if ~ischar(topicName)
    % Create logger reference
    logObj = Logger.getLogger();
    write(logObj,'error','Expected topicName of type character vector');
end

% Call the API to create a topic
createTopicRequestJ = obj.Handle.createTopic(topicName);
createTopicResult = aws.sns.model.CreateTopicResult(createTopicRequestJ);

end % function
