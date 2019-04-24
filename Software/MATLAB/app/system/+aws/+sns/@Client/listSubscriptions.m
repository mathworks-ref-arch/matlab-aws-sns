function listSubscriptionsResult = listSubscriptions(obj, varargin)
% LISTSUBSCRIPTIONS Returns a list of the requester's subscriptions
% Each call returns a limited list of subscriptions, up to 100, it can be far
% less than 100. A ListSubscriptionsResult object is returned.
% If there are more subscriptions a NextToken is returned by the
% ListSubscriptionsResult.getNextToken() method. This token can then be used by
% subsequent calls to listSubscriptions to get further results.
%
% The table returned by listSubscriptionsResult.getSubscriptions() will contain
% entries such as the following under 5 headings:
%    subscriptionArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName:7a<Redacted>8f5
%    owner: 74<Redacted>02
%    protocol: email-json
%    endpoint: johnsmith@example.com
%    topicArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName

% Copyright 2018 The MathWorks, Inc.

import com.amazonaws.services.sns.model.ListSubscriptionsRequest

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'listSubscriptions';

% Provide the option of using queue prefix
addOptional(p,'nextToken','',@ischar);

% Parse and validate input
parse(p,varargin{:});

nextToken = p.Results.nextToken;

listSubscriptionsResultJ = obj.Handle.listSubscriptions(string(nextToken));
listSubscriptionsResult = aws.sns.model.ListSubscriptionsResult(listSubscriptionsResultJ);

end % function
