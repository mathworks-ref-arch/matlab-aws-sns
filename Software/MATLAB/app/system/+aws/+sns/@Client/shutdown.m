function shutdown(obj)
% SHUTDOWN Method to shutdown a client and release resources
% This method should be called to cleanup a client which is no longer
% required.
%
% Example:
%    sns = aws.sns.Client;
%    % Perform operations using the client then shutdown
%    sns.shutdown;

% Copyright 2018 The MathWorks, Inc.

obj.Handle.shutdown();

end
