function attributes = getAttributes(obj)
% GETATTRIBUTES Returns a topic's attributes
% Attributes are returned as a containers.Map.

% Copyright 2019 The MathWorks, Inc.

attributesHashmapJ = obj.Handle.getAttributes();

% return and entrySet to get an iterator
entrySetJ = attributesHashmapJ.entrySet();
% get the iterator
iteratorJ = entrySetJ.iterator();

% declare empty cell arrays for values and keys
attributeKeys = {};
attributeValues = {};

while iteratorJ.hasNext()
    % pick metadata from the entry set one at a time
    entryJ = iteratorJ.next();
    % get the key and the value
    attributeKey = entryJ.getKey();
    attributeValue = entryJ.getValue();
    % build the cell arrays of keys and values
    attributeKeys{end+1} = attributeKey; %#ok<AGROW>
    attributeValues{end+1} = attributeValue; %#ok<AGROW>
end

% if the cell arrays are still empty then create an empty containers.Map and
% return that else build it from the arrays of values and keys
if isempty(attributeKeys)
    attributes = containers.Map('KeyType','char','ValueType','char');
else
    attributes = containers.Map(attributeKeys, attributeValues);
end

end
