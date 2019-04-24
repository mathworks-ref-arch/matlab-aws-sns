function getSubscriptionAttributesResult = getSubscriptionAttributes(obj, subscriptionArn)
% GETSUBSCRIPTIONATTRIBUTES Get the attributes of a subscription
% A GetSubscriptionAttributesResult object is returned.
%
% Example:
%    sns = aws.sns.Client;
%    sns.initialize();
%    subscribeResult = sns.subscribe(topicArn,'sqs',queueArn);
%    subscriptionArn = subscribeResult.getSubscriptionArn();
%    getSubscriptionAttributeResult = GetSubscriptionAttributesResult(subscriptionArn);
%    attributesMap = getSubscriptionAttributeResult.getAttributes();

% Copyright 2018 The MathWorks, Inc.

if ~ischar(subscriptionArn)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected subscriptionARN of type character vector');
end

% return a GetSubscriptionAttributes()
getSubscriptionAttributesResultJ = obj.Handle.getSubscriptionAttributes(subscriptionArn);
getSubscriptionAttributesResult = aws.sns.model.GetSubscriptionAttributesResult(getSubscriptionAttributesResultJ);

end
