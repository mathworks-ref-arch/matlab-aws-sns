function topicsTable = getTopics(obj)
% GETTOPICS Returns a table of topics
% The table has two columns one containing topic ARNs and the other containing
% the topic names.

% Copyright 2018 The MathWorks, Inc.

% get a Java list of topics, type com.amazonaws.internal.SdkInternalList<T>
topicsListJ = obj.Handle.getTopics();
listSize = topicsListJ.size();
% allocate a MATLAB table to hold the results
sz = [listSize, 2];
varTypes = {'string','string'};
varNames = {'topicArn','topicName'};
topicsTable = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% get the Table as an array for clarity
arrayJ = topicsListJ.toArray();

% add an entry to the table for each Topic in the array
for n = 1:listSize()
    arn = string(arrayJ(n).getTopicArn());
    % split the ARN and get the name from the final field
    splitArn = strsplit(arn, ':');
    topicsTable(n,:) = {arn, splitArn(end)};
end

end
