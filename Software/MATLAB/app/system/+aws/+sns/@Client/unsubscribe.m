function unsubscribeResult = unsubscribe(obj, subscriptionARN)
% UNSUBSCRIBE Deletes a subscription to a topic
% Deletes a subscription. If the subscription requires authentication for
% deletion, only the owner of the subscription or the topic's owner can
% unsubscribe, and an AWS signature is required. If the unsubscribe call
% does not require authentication and the requester is not the subscription
% owner, a final cancellation message is delivered to the endpoint, so that
% the endpoint owner can easily resubscribe to the topic if the unsubscribe
% request was unintended. An UnsubscribeResult object is returned.
%
% Example:
%    unsubscribeResult = sns.unsubscribe(subscriptionArn);
%    tf = strcmp(unsubscribeResult.toString(), '{}'));

% Copyright 2018 The MathWorks, Inc.

% Return error if subscription ARN is not character vector
if ~ischar(subscriptionARN)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected subscriptionARN of type character vector');
end

UnsubscribeRequestJ = obj.Handle.unsubscribe(subscriptionARN);
unsubscribeResult = aws.sns.model.UnsubscribeResult(UnsubscribeRequestJ);

end
