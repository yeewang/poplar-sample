//
//  XHRSimulator.m
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

#import "XHRSimulator.h"

@implementation XHRSimulator

- (XHRSimulator *)initWithWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        // Save cookie, refer to:
        // http://blog.it985.com/11248.html
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        self.cookies = [cookieJar cookies];
        for (NSHTTPCookie * cookie in _cookies) {
            NSLog(@"Get cookie: %@", cookie);
        }
    }
    return self;
}

- (NSString *)createXHR
{
    return nil;
}

- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    self.callbackID = [arguments pop];
    
    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"我是返回的:"];
    [stringToReturn appendString: stringObtainedFromJavascript];
    
    // Create Plugin Result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: stringToReturn];
    
    NSLog(@ "%@",stringToReturn);
    
    if ([stringObtainedFromJavascript isEqualToString:@"HelloWorld"] == YES){
        // Call the javascript success function
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else{
        // Call the javascript error function
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
}

- (void)abort
{
    // Create Plugin Result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"abort"];
}

- (NSString *)getAllResponseHeaders
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"getAllResponseHeaders"];
}

- (NSString *)getResponseHeader:(NSString *)header
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"getResponseHeader"];
}

- (void)open:(NSString *)methodName
         url:(NSString *) url
     isAsync:(BOOL) async
    username:(NSString *) username password:(NSString *) password
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"open"];
}

- (void)send:(id)body
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"send"];
}

- (void)setRequestHeader:(NSString *)name value:(NSString *) value
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"setRequestHeader"];
}

@end
