function subscriptionArn = getSubscriptionArn(obj)
% GETSUBSCRIPTIONARN Get status of a subscribe call
% The ARN of the subscription if it is confirmed, or the string
% "pending confirmation" if the subscription requires confirmation.

subscriptionArn = char(obj.Handle.getSubscriptionArn());

end
