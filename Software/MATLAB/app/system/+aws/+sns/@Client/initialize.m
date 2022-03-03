function initStat = initialize(obj, varargin)
% INITIALIZE Configure the MATLAB session to connect to SNS
% Once a client has been configured, initialize is used to validate the
% client configuration and initiate the connection to SNS
%
% Example:
%    sns = aws.sns.Client();
%    sns.initialize();

% Copyright 2019-2021 The MathWorks, Inc.

%% Imports
% Exceptions
import com.amazonaws.AmazonClientException
import com.amazonaws.AmazonServiceException

% Credentials
import com.amazonaws.auth.AWSCredentials
import com.amazonaws.auth.BasicAWSCredentials
import com.amazonaws.auth.AWSStaticCredentialsProvider
import com.amazonaws.auth.BasicSessionCredentials
import com.amazonaws.auth.STSSessionCredentialsProvider
import com.amazonaws.auth.InstanceProfileCredentialsProvider
import com.amazonaws.auth.profile.ProfileCredentialsProvider
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain

% Builders
% Import Amazon SNS client builder
import com.amazonaws.services.sns.AmazonSNS
import com.amazonaws.services.sns.AmazonSNSClient
import com.amazonaws.services.sns.AmazonSNSClientBuilder
% Regions
import com.amazonaws.regions.Region
import com.amazonaws.regions.Regions
import com.amazonaws.regions.RegionUtils
import com.amazonaws.regions.DefaultAwsRegionProviderChain

%% Create a logger object & misc setting
logObj = Logger.getLogger();
write(logObj,'debug','Initializing SNS client');

% assume we're returning a fail
initStat = false;

% ensure that proxy settings are configured if required
initClientConfiguration(obj);

%% if NOT using the provider chain then setup a credentials file
if obj.useCredentialsProviderChain == false
    % if using the default name with no path establish the full path using which
    % else use the full path as should have been provided and set
    if strcmpi(obj.credentialsFilePath,'credentials.json')
        credFile = which(obj.credentialsFilePath);
    else
        credFile = obj.credentialsFilePath;
    end
    if exist(credFile,'file') == 2
        % Read in configuration and credentials from static sources
        write(logObj,'verbose','Using credential file based authentication');
        % Create a client handle using basic static credentials
        credentials = jsondecode(fileread(credFile));
        % if there is no session token use static credentials otherwise use
        % STS credentials
        if ~isfield(credentials, 'session_token')
            awsCreds = BasicAWSCredentials(credentials.aws_access_key_id, credentials.secret_access_key);
        elseif strcmp(strtrim(credentials.session_token),'')
            % In this case we are allowing for a template that has the session_token field but
            % it has no value so it is probably conventional static
            % credentials file with a stray session token field
            awsCreds = BasicAWSCredentials(credentials.aws_access_key_id, credentials.secret_access_key);
        else
            % we have a potentially valid session token
            write(logObj,'verbose','Using credentials file with session token based authentication');
            awsCreds = BasicSessionCredentials(credentials.aws_access_key_id, credentials.secret_access_key, credentials.session_token);
        end
        awsCredentials = AWSStaticCredentialsProvider(awsCreds);
        % takes a string of the form "us-west-1" from the file and returns the
        % ENUM of the form US_WEST_1, NB there are format exceptions e.g.
        % GovCloud
        awsRegion = Regions.fromName(credentials.region);
    else
        write(logObj,'error',['Credentials file not found: ',credFile]);
        return;
    end
else
    write(logObj,'verbose','Using Provider Chain based authentication');

    % setup credentials and region provider
    awsCredentials = DefaultAWSCredentialsProviderChain();
    regionProvider = DefaultAwsRegionProviderChain();

    % this should return null if not set but this is a bug in the AWS SDK
    % that will not be fixed until version 2 so now an exception is thrown
    % if the default provider chain does not provide a region
    awsRegionName = char(regionProvider.getRegion());
    write (logObj,'verbose',['Provider Chain set Region to: ', awsRegionName]);

    % pass the Java ENUM object of the form US_WEST_1, this is used later
    % by the builder and to set the KMS region
    awsRegion = Regions.fromName(regionProvider.getRegion());
end

%% check if SNS is available in the given region
availableRegions = RegionUtils.getRegionsForService('sns');
if  ~contains(char(availableRegions), char(awsRegion.getName))
    write(logObj,'error',['Region: ',awsRegion.getName,' does not support SNS']);
end


%% build a handle to the SNS client
builderH = AmazonSNSClientBuilder.standard().withCredentials(awsCredentials).withClientConfiguration(obj.clientConfiguration.Handle);


%% configure the Endpoint if set else just set the region
if isempty(obj.endpointURI.Host)
    % set the region directly if not using a custom endpoint otherwise the region
    % is configured as part of the endpoint configuration
    builderH.setRegion(awsRegion.getName);
else
    % if the URI has a path we don't include it in the endpoint as this is likely bucket name
    endpointHostPort = [char(obj.endpointURI.Scheme) '://' char(obj.endpointURI.EncodedAuthority)];
    endpointRegion = char(awsRegion.getName);
    write(logObj,'verbose',['Setting Endpoint URI & Region to: ',endpointHostPort,' ',endpointRegion]);
    endPointConfig = javaObject('com.amazonaws.client.builder.AwsClientBuilder$EndpointConfiguration',endpointHostPort, endpointRegion);
    builderH.setEndpointConfiguration(endPointConfig);
end


%% Build the SNS client handle
% We are ready to build() as we have a fully configured builder
obj.Handle = builderH.build();

%% Return true if the client handle exists
if ~isempty(obj.Handle)
    write(logObj,'verbose','Client initialized');
    initStat = true;
else
    write(logObj,'error','Client initialization failed');
end

end


function initClientConfiguration(obj)
    % if the property has not been set the call the set function to initialize
    % it from preferences panel / OS settings, if it is set then we know the
    % set function has previously been called
    if isempty(obj.clientConfiguration.proxyHost)
        obj.clientConfiguration.setProxyHost();
    end
    if isempty(obj.clientConfiguration.proxyPort)
        obj.clientConfiguration.setProxyPort();
    end
    if isempty(obj.clientConfiguration.proxyUsername)
        obj.clientConfiguration.setProxyUsername();
    end
    if isempty(obj.clientConfiguration.proxyPassword)
        obj.clientConfiguration.setProxyPassword();
    end
end
