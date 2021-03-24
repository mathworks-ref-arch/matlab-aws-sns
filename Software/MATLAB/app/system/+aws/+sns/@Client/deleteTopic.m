function deleteTopicResult = deleteTopic(obj, topicArn)
% DELETETOPIC Deletes an Amazon SNS topic
% Deletes a topic and all its subscriptions. Deleting a topic might prevent
% some messages previously sent to the topic from being delivered to
% subscribers. Deleting a topic that does not exist does not result in an error.
% A DeleteTopicResult object is returned. The DeleteTopicResult.toString()
% method returns '{}' when successful.
%
% Example:
%    sns = aws.sns.Client;
%    deleteTopicResult = sns.deleteTopic(topicArn)

% Copyright 2018-2021 The MathWorks, Inc.

% Return error if input is not character vector
if ~ischar(topicArn)
    % Create logger reference
    logObj = Logger.getLogger();
    write(logObj,'error','Expected topicArn of type character vector');
end

% Call the API to delete a queue
deleteTopicResultJ = obj.Handle.deleteTopic(topicArn);
deleteTopicResult = aws.sns.model.DeleteTopicResult(deleteTopicResultJ);

end %function
