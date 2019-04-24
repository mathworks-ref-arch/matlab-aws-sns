function subscriptionsTable = getSubscriptions(obj)
% GETSUBSCRIPTIONS Returns a table of subscriptions
% Entries such as the following under 5 headings:
%    subscriptionArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName:7a<Redacted>8f5
%    owner: 74<Redacted>02
%    protocol: email-json
%    endpoint: johnsmith@example.com
%    topicArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName

% Copyright 2018 The MathWorks, Inc.

% get a Java list of subscriptions, type com.amazonaws.internal.SdkInternalList<T>
subscriptionListJ = obj.Handle.getSubscriptions();
listSize = subscriptionListJ.size();
% allocate a MATLAB table to hold the results
sz = [listSize, 5];
varTypes = {'string','string','string','string','string'};
varNames = {'subscriptionArn','owner','protocol','endpoint','topicArn'};
subscriptionsTable = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% get the Table as an array for clarity
arrayJ = subscriptionListJ.toArray();

% add an entry to the table for each Topic in the array
for n = 1:listSize()
    subscriptionArn = string(arrayJ(n).getSubscriptionArn());
    owner = string(arrayJ(n).getOwner());
    protocol = string(arrayJ(n).getProtocol());
    endpoint = string(arrayJ(n).getEndpoint());
    topicArn = string(arrayJ(n).getTopicArn());
    subscriptionsTable(n,:) = {subscriptionArn, owner, protocol, endpoint, topicArn};
end

end
