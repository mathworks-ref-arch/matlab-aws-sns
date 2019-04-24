function result = toString(obj)
% TOSTRING Returns a string representation of this object
% This is useful for testing and debugging. Sensitive data will be redacted
% from this string using a placeholder value.
% The result is returned as a character vector.
% '{}' is expected on success.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.toString());

end
