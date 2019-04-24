function setTopicAttributesResult = setTopicAttributes(obj, topicARN, attributeName, attributeValue)
% SETTOPICATTRIBUTES Set an attribute value for a topic
% Valid values include: Policy, DisplayName and DeliveryPolicy
% This changes the specified value a SetTopicAttributesResult object is returned.
%
% Example:
%    % Changing display name of a topic
%    displayName = 'MyNewDisplayName';
%    setTopicAttributesResult = sns.setTopicAttributes(topicArn,'DisplayName',displayName);
%    % Should return '{}' on success
%    tf = strcmp(setTopicAttributesResult.toString(), '{}');
%    % Get the topic attributes to verify the change
%    getTopicAttributesResult = sns.getTopicAttributes(topicArn);
%    attributes = getTopicAttributesResult.getAttributes();
%    tf = strcmp(attributes('DisplayName'), displayName));

% Copyright 2018 The MathWorks, Inc.

% Create logger reference
logObj = Logger.getLogger();

% Return error if inputs are not character vectors
if ~ischar(topicARN)
    write(logObj,'error','Expected topicARN of type character vector');
end
if ~ischar(attributeName)
    write(logObj,'error','Expected attributeName of type character vector');
end
if ~ischar(attributeValue)
    write(logObj,'error','Expected attributeValue of type character vector');
end

% Call the API to set topic attributes
setTopicAttributesRequestJ = obj.Handle.setTopicAttributes(topicARN, attributeName, attributeValue);
setTopicAttributesResult = aws.sns.model.SetTopicAttributesResult(setTopicAttributesRequestJ);

end
