classdef GetTopicAttributesResult < aws.Object
% GETTOPICATTRIBUTESRESULT Object to represent the result of a getTopicAttributes call

% Copyright 2018 The MathWorks, Inc.

methods
    function obj = GetTopicAttributesResult(varargin)
        if nargin == 1
            if ~isa(varargin{1}, 'com.amazonaws.services.sns.model.GetTopicAttributesResult')
                logObj = Logger.getLogger();
                write(logObj,'error','argument not of type com.amazonaws.services.sns.model.GetTopicAttributesResult');
            else
                obj.Handle = varargin{1};
            end
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid number of arguments');
        end
    end
end

end
