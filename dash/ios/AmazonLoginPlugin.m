#import "AmazonLoginPlugin.h"
#import "AppDelegate.h"

#import <Cordova/CDVAvailability.h>
#import <LoginWithAmazon/LoginWithAmazon.h>

@implementation AppDelegate (AmazonLogin)

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)
            url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    // NSLog(@"AmazonLoginPlugin Plugin handle openURL");
    return [AMZNAuthorizationManager handleOpenURL:url
                                 sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];

}

@end

@implementation AmazonLoginPlugin

- (void)authorize:(CDVInvokedUrlCommand *)command {
    // NSLog(@"AmazonLoginPlugin authorize request started");
    // Build an authorize request.
    AMZNAuthorizeRequest *request = [[AMZNAuthorizeRequest alloc] init];
    NSDictionary* optionObject = [[command arguments] objectAtIndex:0];
    NSString* requestScope = [optionObject valueForKey:@"scope"];
    NSDictionary* optionData = [[optionObject valueForKey:@"scope_data"] valueForKey:requestScope];
    NSMutableArray* scopeObjectArray = [NSMutableArray array];
    
    NSMutableDictionary* options = NSMutableDictionary.new;
    //YOUR_DEVICE_SERIAL_NUMBER – The serial number of the device you are associating with the DRS service. Only alphanumeric characters can be used [A-Za-z0-9], for a maximum string length of 50 characters.
    options[@"serial"] = [optionData valueForKey:@"serial"];
    //Set device model name. This is a "Device Model ID" in the Self Service portal.
    options[@"device_model"] = [optionData valueForKey:@"device_model"];
    // Set whether this registration should allow marketplaces that have not yet been certified.
    // For use in pre-release testing only, this flag must not be passed in by your released app in production.
    // SHOULD_INCLUDE_NON_LIVE should be 'true' or 'false', allows the registration to proceed using device capabilities that have not yet been certified by Amazon. You can use this parameter to test your system while awaiting Amazon certification.
    options[@"should_include_non_live"] = [optionData valueForKey:@"should_include_non_live"];
    // IS_THIS_A_TEST_DEVICE – Flag that indicates if this a test device or not. You will not be able to test devices without setting the `is_test_device` flag to true, but you must set it to false in production. Test devices will not place real orders
    // IS_THIS_A_TEST_DEVICE should be 'true' or 'false'
    options[@"is_test_device"] = [optionData valueForKey:@"is_test_device"];

    id<AMZNScope> drsScope = [AMZNScopeFactory scopeWithName:requestScope data:options];
    [scopeObjectArray addObject:drsScope];
    request.scopes = scopeObjectArray;
    request.grantType = AMZNAuthorizationGrantTypeCode;
    // Set your code challenge.
    request.codeChallenge = @"F62BB66E-49B3-4B4A-86D6-0EE196F088BD-0EE196F088BD";
    // Set code challenge method - "plain" or "S256".
    request.codeChallengeMethod = @"plain";

    // Make an Authorize call to the Login with Amazon SDK.
    [[AMZNAuthorizationManager sharedManager] authorize:request withHandler:^(AMZNAuthorizeResult *result, BOOL userDidCancel, NSError *error) {
        if (error) {
            // Handle errors from the SDK or authorization server.
            if(error.code == kAIApplicationNotAuthorized) {
                // Show authorize user button.
                // NSLog(@"AmazonLoginPlugin authorize request NotAuthorized");

                NSString* payload =@"authorize request NotAuthorized";

                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];

                // The sendPluginResult method is thread-safe.
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


            } else {
                // NSLog(@"AmazonLoginPlugin authorize request failed");
                NSString* payload = error.userInfo[@"AMZNLWAErrorNonLocalizedDescription"];

                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];

                // The sendPluginResult method is thread-safe.
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }



        } else if (userDidCancel) {
            // Handle errors caused when user cancels login.
            // NSLog(@"AmazonLoginPlugin authorize request canceled");
           NSString* payload = @"authorize request canceled";


            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];

            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        } else {
            // NSLog(@"AmazonLoginPlugin authorize success");
            // Authentication was successful.
            // Authentication was successful. Obtain the user profile data.
            id objects[] = {result.authorizationCode, result.clientId, result.redirectUri};
            id keys[] = {@"authCode", @"clientId", @"redirectUri"};
            NSUInteger count = sizeof(objects) / sizeof(id);
            NSDictionary* results = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];

            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

- (void)fetchUserProfile:(CDVInvokedUrlCommand *)command {
    //NSLog(@"AmazonLoginPlugin fetchUserProfile");

    [AMZNUser fetch:^(AMZNUser *user, NSError *error) {
        if (error) {
            // Error from the SDK, or no user has authorized to the app.
            NSString* payload = error.userInfo[@"AMZNLWAErrorNonLocalizedDescription"];

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];

            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        } else if (user) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:user.profileData];

            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        }
    }];
}

- (void)getToken:(CDVInvokedUrlCommand *)command {
    // NSLog(@"AmazonLoginPlugin authorize request started");
    // Build an authorize request.
    AMZNAuthorizeRequest *request = [[AMZNAuthorizeRequest alloc] init];
    NSDictionary* optionObject = [[command arguments] objectAtIndex:0];
    NSString* requestScope = [optionObject valueForKey:@"scope"];
    NSDictionary* optionData = [[optionObject valueForKey:@"scope_data"] valueForKey:requestScope];
    NSMutableArray* scopeObjectArray = [NSMutableArray array];
    
    NSMutableDictionary* options = NSMutableDictionary.new;
    //YOUR_DEVICE_SERIAL_NUMBER – The serial number of the device you are associating with the DRS service. Only alphanumeric characters can be used [A-Za-z0-9], for a maximum string length of 50 characters.
    options[@"serial"] = [optionData valueForKey:@"serial"];
    //Set device model name. This is a "Device Model ID" in the Self Service portal.
    options[@"device_model"] = [optionData valueForKey:@"device_model"];
    // Set whether this registration should allow marketplaces that have not yet been certified.
    // For use in pre-release testing only, this flag must not be passed in by your released app in production.
    // SHOULD_INCLUDE_NON_LIVE should be 'true' or 'false', allows the registration to proceed using device capabilities that have not yet been certified by Amazon. You can use this parameter to test your system while awaiting Amazon certification.
    options[@"should_include_non_live"] = [optionData valueForKey:@"should_include_non_live"];
    // IS_THIS_A_TEST_DEVICE – Flag that indicates if this a test device or not. You will not be able to test devices without setting the `is_test_device` flag to true, but you must set it to false in production. Test devices will not place real orders
    // IS_THIS_A_TEST_DEVICE should be 'true' or 'false'
    options[@"is_test_device"] = [optionData valueForKey:@"is_test_device"];
    
    id<AMZNScope> drsScope = [AMZNScopeFactory scopeWithName:requestScope data:options];
    [scopeObjectArray addObject:drsScope];
    request.scopes = scopeObjectArray;
    request.grantType = AMZNAuthorizationGrantTypeCode;
    request.interactiveStrategy = AMZNInteractiveStrategyNever;
    // Set your code challenge.
    request.codeChallenge = @"F62BB66E-49B3-4B4A-86D6-0EE196F088BD-0EE196F088BD";
    // Set code challenge method - "plain" or "S256".
    request.codeChallengeMethod = @"plain";
    
    // Make an Authorize call to the Login with Amazon SDK.
    [[AMZNAuthorizationManager sharedManager] authorize:request withHandler:^(AMZNAuthorizeResult *result, BOOL userDidCancel, NSError *error) {
        if (error) {
            // Handle errors from the SDK or authorization server.
            if(error.code == kAIApplicationNotAuthorized) {
                // Show authorize user button.
                // NSLog(@"AmazonLoginPlugin authorize request NotAuthorized");
                
                NSString* payload =@"authorize request NotAuthorized";
                
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];
                
                // The sendPluginResult method is thread-safe.
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                
                
            } else {
                // NSLog(@"AmazonLoginPlugin authorize request failed");
                NSString* payload = error.userInfo[@"AMZNLWAErrorNonLocalizedDescription"];
                
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];
                
                // The sendPluginResult method is thread-safe.
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
            
            
            
        } else if (userDidCancel) {
            // Handle errors caused when user cancels login.
            // NSLog(@"AmazonLoginPlugin authorize request canceled");
            NSString* payload = @"authorize request canceled";
            
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];
            
            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
        } else {
            // NSLog(@"AmazonLoginPlugin authorize success");
            // Authentication was successful.
            // Authentication was successful. Obtain the user profile data.
            id objects[] = {result.authorizationCode, result.clientId, result.redirectUri};
            id keys[] = {@"authCode", @"clientId", @"redirectUri"};
            NSUInteger count = sizeof(objects) / sizeof(id);
            NSDictionary* results = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
            
            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

- (void)signOut:(CDVInvokedUrlCommand *)command {
    //NSLog(@"AmazonLoginPlugin signOut");
    [[AMZNAuthorizationManager sharedManager] signOut:^(NSError * _Nullable error) {
        if (!error) {
            // error from the SDK or Login with Amazon authorization server.
            NSString* payload = error.userInfo[@"AMZNLWAErrorNonLocalizedDescription"];

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:payload];

            // The sendPluginResult method is thread-safe.
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}
@end
