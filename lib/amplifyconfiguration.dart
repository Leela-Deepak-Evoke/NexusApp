const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "ap-south-1:13da9269-b56f-4f90-9f21-5fbbce70b8ff",
                            "Region": "ap-south-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-south-1_VBSD4mk4o",
                        "AppClientId": "6fpao7sa8kk6cgeht9k23a5jam",
                        "Region": "ap-south-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "OAuth": {
                          "WebDomain": "https://evoke-nexus.auth.ap-south-1.amazoncognito.com",
                          "AppClientId": "6fpao7sa8kk6cgeht9k23a5jam",
                          "SignInRedirectURI": "http://localhost:5858/home",
                          "SignOutRedirectURI": "http://localhost:5858",
                          "Scopes": [
                            "phone",
                            "email",
                            "openid",
                            "profile",
                            "aws.cognito.signin.user.admin"
                          ]
                        }
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "evoke-nexus-media",
                        "Region": "ap-south-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "evoke-nexus-media",
                "region": "ap-south-1",
                "defaultAccessLevel": "guest"
            }
        }
    },
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Nexus": {
                    "endpointType": "REST",
                    "endpoint": "https://im44yb68y0.execute-api.ap-south-1.amazonaws.com/dev",
                    "region": "ap-south-1",
                    "authorizationType": "NONE"
                }
            }
        }
    }
}''';
