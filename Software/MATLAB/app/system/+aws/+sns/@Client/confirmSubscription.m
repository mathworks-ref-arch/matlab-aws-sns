function confirmSubscriptionResult = confirmSubscription(obj, topicArn, token)
% CONFIRMSUBSCRIPTION Confirms a subscription
% The topic ARN is entered along with the token received in the confirmation
% request message sent by SNS after the subscribe.
% This action is not required for endpoints such as SMS and SQS, but is
% required for email and http/https endpoints.
% To receive the token for the email endpoint the email-json protocol must
% be used. A ConfirmSubscriptionResult object is returned.
%
% Example:
%    sns = aws.sns.Client;
%    sns.confirmSubscription('arn:aws:sns:us-west-1:74<Redacted>102:SNSMyTopic','54<Redacted>51f')

% Copyright 2018 The MathWorks, Inc.

% Create logger reference
logObj = Logger.getLogger();

% Return error if inputs are not character vectors
if ~ischar(topicArn)
    write(logObj,'error','Expected topic name of type character vector');
end
if ~ischar(token)
    write(logObj,'error','Expected token of type character vector');
end

% Call the API to confirm subscription
write(logObj,'verbose',['Confirming subscription: ',topicArn]);
confirmSubscriptionResultJ = obj.Handle.confirmSubscription(topicArn,token);
confirmSubscriptionResult = aws.sns.model.ConfirmSubscriptionResult(confirmSubscriptionResultJ);

end
