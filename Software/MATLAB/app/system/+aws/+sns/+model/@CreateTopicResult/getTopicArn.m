function topicARN = getTopicArn(obj)
% GETTOPICARN returns the Amazon Resource Name (ARN) assigned to the topic
% The ARN is returned as a character vector

topicARN = char(obj.Handle.getTopicArn());

end
