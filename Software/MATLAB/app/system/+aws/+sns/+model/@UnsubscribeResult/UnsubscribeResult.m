classdef UnsubscribeResult < aws.Object
% UNSUBSCRIBERESULT Object to represent the result of an unsubscribe call

% Copyright 2018 The MathWorks, Inc.

methods
    function obj = UnsubscribeResult(varargin)
        if nargin == 1
            if ~isa(varargin{1}, 'com.amazonaws.services.sns.model.UnsubscribeResult')
                logObj = Logger.getLogger();
                write(logObj,'error','argument not of type com.amazonaws.services.sns.model.UnsubscribeResult');
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
