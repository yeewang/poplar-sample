//
//  XHRSimulator.h
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface XHRSimulator : CDVPlugin

- (XHRSimulator *)initWithWebView:(UIWebView *)webView;
- (NSString *)createXHR;

- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)abort;
- (NSString *)getAllResponseHeaders;
- (NSString *)getResponseHeader:(NSString *)header;
- (void)open:(NSString *)methodName
         url:(NSString *)url
     isAsync:(BOOL)async
    username:(NSString *)username password:(NSString *)password;
- (void)send:(id)body;
- (void)setRequestHeader:(NSString *)name value:(NSString *)value;

// callback
// Function onreadystatechange;

@property (nonatomic, strong) NSArray *cookies;
@property (nonatomic, copy) NSString *callbackID;
@property (nonatomic, readonly) short readyState;
@property (nonatomic, strong, readonly) NSString *responseText;
@property (nonatomic, strong, readonly) NSArray *responseXML;
@property (nonatomic, readonly) short status;
@property (nonatomic, strong, readonly) NSString *statusText;

@end
