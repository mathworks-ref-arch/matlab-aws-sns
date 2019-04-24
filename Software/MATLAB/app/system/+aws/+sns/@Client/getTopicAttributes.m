function getTopicAttributesResult = getTopicAttributes(obj, topicARN)
% GETTOPICATTRIBUTES Get the attributes of a topic
% A GetTopicAttributesResult object is returned. Topic attributes may vary
% based on the authorization of the user.
%
% Example:
%    sns = aws.sns.Client;
%    sns.initialize();
%    createTopicResult = sns.createTopic('myTopicName');
%    topicArn = createTopicResult.getTopicArn();
%    getTopicAttributeResult = GetTopicAttributesResult(topicArn);
%    attributesMap = getTopicAttributeResult.getAttributes();

% Copyright 2018 The MathWorks, Inc.

if ~ischar(topicARN)
    % Create logger reference
    logObj = Logger.getLogger();
    write(logObj,'error','Expected topicARN of type character vector');
end

% Call the API to get topic attributes
getTopicAttributesResultJ = obj.Handle.getTopicAttributes(topicARN);
getTopicAttributesResult = aws.sns.model.GetTopicAttributesResult(getTopicAttributesResultJ);

end % function
