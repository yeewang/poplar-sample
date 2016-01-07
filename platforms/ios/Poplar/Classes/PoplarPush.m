//
//  PoplarPush.m
//  Poplar
//
//  Created by Wang Yi on 12/21/15.
//
//

#import "PoplarPush.h"
#import "XHRSimulator.h"


@implementation PoplarPush

NSString *const kAPPBackgroundJsNamespace = @"cordova.plugins.PoplarPush";
NSString *const kAPPBackgroundEventSuspended = @"inSuspendedState";
NSString *const kAPPBackgroundEventDidEnterBackground = @"didEnterBackground";
NSString *const kAPPBackgroundEventWillEnterForeground = @"willEnterForeground";

#pragma mark -
#pragma mark Initialization methods

/**
 * Initialize the plugin.
 */
- (void) pluginInitialize
{
    // [self disable:NULL];
    [self observeLifeCycle];
}

/**
 * Register the listener for pause and resume events.
 */
- (void) observeLifeCycle
{
    NSNotificationCenter* listener = [NSNotificationCenter defaultCenter];
    
    if (&UIApplicationDidEnterBackgroundNotification && &UIApplicationWillEnterForegroundNotification) {
        
        [listener addObserver:self
                     selector:@selector(applicationDidEnterBackground:)
                         name:UIApplicationDidEnterBackgroundNotification
                       object:nil];
        
        [listener addObserver:self
                     selector:@selector(applicationWillEnterForeground:)
                         name:UIApplicationWillEnterForegroundNotification
                       object:nil];
        
    } else {
        
        //Do something else
    }
}


- (void)applicationDidEnterBackground:(NSNotification *) notification
{
    
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self backgroundHandler]; }];
    if (backgroundAccepted) {
        [self fireEvent:kAPPBackgroundEventDidEnterBackground withParams:NULL];
        NSLog(@"VOIP backgrounding accepted for the App");
    } else {
        NSLog(@"VOIP backgrounding NOT accepted for the App");
    }
}

- (void)applicationWillEnterForeground:(NSNotification *) notification
{
    [[UIApplication sharedApplication] clearKeepAliveTimeout];
    
    [self fireEvent:kAPPBackgroundEventWillEnterForeground withParams:NULL];
    
    NSLog(@"App will enter foreground");
}

- (void)backgroundHandler {
    
    NSLog(@"### -->VOIP backgrounding callback"); // What to do here to extend timeout?
    
    [self fireEvent:kAPPBackgroundEventSuspended withParams:NULL];
}


/**
 * Method to fire an event with some parameters in the browser.
 */
- (void) fireEvent:(NSString*)event withParams:(NSString*)params
{
    /*
    NSString* js = [NSString stringWithFormat:@"setTimeout('%@.%@(%@)',0);",
                    kAPPBackgroundJsNamespace, event, params];
    
    [self.commandDelegate evalJs:js];
    */
    
    
    XHRSimulator *XHR = [[XHRSimulator alloc] initWithWebView:self.webView];
    [self didReceiveMessage:[XHR createXHR]];
}

- (void)didReceiveMessage:(NSString *)message
{
    [self.delegate pushSink:self didReceiveMessage:message];
}

@end
