classdef SubscribeResult < aws.Object
% SUBSCRIBERESULT Object to represent the result of a subscribe call

% Copyright 2018 The MathWorks, Inc.

methods
    function obj = SubscribeResult(varargin)
        if nargin == 1
            if ~isa(varargin{1}, 'com.amazonaws.services.sns.model.SubscribeResult')
                logObj = Logger.getLogger();
                write(logObj,'error','argument not of type com.amazonaws.services.sns.model.SubscribeResult');
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
