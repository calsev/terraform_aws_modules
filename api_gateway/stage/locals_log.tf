locals {
  log_format_list = [
    "accountId",
    "apiId",
    #"authenticate.error",
    #"authenticate.latency",
    #"authenticate.status",
    #"authorize.error",
    #"authorize.latency",
    #"authorize.status",
    "authorizer.error",
    "authorizer.integrationLatency",
    "authorizer.integrationStatus",
    "authorizer.latency",
    "authorizer.principalId",
    "authorizer.requestId",
    "authorizer.status",
    "awsEndpointRequestId",
    "customDomain.basePathMatched",
    "domainName",
    "domainPrefix",
    "error.message",
    "error.responseType",
    #"error.validationErrorString",
    "extendedRequestId",
    "httpMethod",
    "identity.accountId",
    #"identity.apiKey",
    #"identity.apiKeyId",
    "identity.caller",
    "identity.cognitoAuthenticationProvider",
    "identity.cognitoAuthenticationType",
    "identity.cognitoIdentityId",
    "identity.cognitoIdentityPoolId",
    "identity.principalOrgId",
    "identity.sourceIp",
    "identity.user",
    "identity.userAgent",
    "identity.userArn",
    "integration.error",
    "integration.integrationStatus",
    "integration.latency",
    "integration.requestId",
    "integration.status",
    "integrationErrorMessage",
    "integrationLatency",
    "integrationStatus",
    "path",
    "protocol",
    "requestId",
    "requestTime",
    #"resourceId",
    "resourcePath",
    "responseLatency",
    "responseLength",
    #"responseOverride.status",
    "stage",
    "status",
    #"waf.error",
    #"waf.latency",
    #"waf.status",
    #"wafResponseCode",
    #"webaclArn",
    #"xrayTraceId",
  ]
}
