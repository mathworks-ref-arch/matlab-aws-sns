function nextToken = getNextToken(obj)
% GETNEXTTOKEN A token is returned if there are additional topics to retrieve
% The token is returned as a character vector.

nextToken = char(obj.Handle.getNextToken());

end
