function listTopicsResult = listTopics(obj,varargin)
% LISTTOPICS Returns a list of topics.
% Each call returns a limited list of topics, up to 100, it can be far
% less than 100. A ListTopicsResult object is returned.
% If there are more Topics a NextToken is returned by the
% ListTopicsResult.getNextToken() method. This token can then be used by
% subsequent calls to listTopics to get further results.
%
% The table returned by listTopicsResult.getTopics() will contain
% entries such as the following under 2 headings:
%    topicArn: arn:aws:sns:eu-west-1:74<Redacted>02:MyTopicName
%    topicNAme: MyTopicName
%
% Example:
%    % Get a list of topics
%    listTopicsResult = sns.listTopics();
%    resultsTable = listTopicsResult.getTopics;
%    % Get topic in Table form
%    topicNames = resultsTable.topicName;
%    % Check if there are more topics to retrieve
%    nextToken = listTopicsResult.getNextToken();
%    tf = isempty(nextToken);

% Copyright 2018 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'listTopics';

% Provide the option of using queue prefix
addOptional(p,'nextToken','',@ischar);

% Parse and validate input
parse(p,varargin{:});

nextToken = p.Results.nextToken;

% Call the API to list the topics
listTopicsResultJ = obj.Handle.listTopics(string(nextToken));
listTopicsResult = aws.sns.model.ListTopicsResult(listTopicsResultJ);

end % function
