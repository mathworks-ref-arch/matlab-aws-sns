classdef ListSubscriptionsResult < aws.Object
% LISTSUBSCRIPTIONSRESULT Object to represent the result of a listSubscriptions call

% Copyright 2018 The MathWorks, Inc.

methods
    function obj = ListSubscriptionsResult(varargin)
        if nargin == 0
            % do nothing, don't set handle
        elseif nargin == 1
            if ~isa(varargin{1}, 'com.amazonaws.services.sns.model.ListSubscriptionsResult')
                write(logObj,'error','argument not of type com.amazonaws.services.sns.model.ListSubscriptionsResult');
            end
            obj.Handle = varargin{1};
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end

end