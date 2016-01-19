/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#include <sys/types.h>
#include <sys/sysctl.h>
#include "TargetConditionals.h"

#import <Cordova/CDV.h>
#import "CDVPoplar.h"
#import "VoipConnection.h"
#import "VoipConnectionDelegate.h"

@interface CDVPoplar () {}
@property (nonatomic, strong) VoipConnection *voipConnection;
@end

@implementation CDVPoplar

static NSString *const kAPPBackgroundJsNamespace = @"cordova.plugins.poplar";
static NSString *const kAPPBackgroundEventSuspended = @"inSuspendedState";
static NSString *const kAPPBackgroundEventDidEnterBackground = @"didEnterBackground";
static NSString *const kAPPBackgroundEventWillEnterForeground = @"willEnterForeground";

#pragma mark -
#pragma mark Initialization methods

/**
 * Initialize the plugin.
 */
- (void) pluginInitialize
{
    self.voipConnection = [VoipConnection connection];
    self.voipConnection.delegate = self;
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
    // setKeepAliveTimeout has been deprecated in iOS9
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

// The setKeepAliveTimeout has been deprecated in iOS9, so this function could not be invoked in iOS9.
- (void)backgroundHandler {
    
    NSLog(@"### -->VOIP backgrounding callback"); // What to do here to extend timeout?
    
    [self fireEvent:kAPPBackgroundEventSuspended withParams:NULL];
}

/**
 * Method to fire an event with some parameters in the browser.
 */
- (void) fireEvent:(NSString*)event withParams:(NSString*)params
{
    NSString* js = [NSString stringWithFormat:@"setTimeout('%@.%@(%@)',0);",
                    kAPPBackgroundJsNamespace, event, params];

    [self.commandDelegate evalJs:js];
}

- (void)getInfo:(CDVInvokedUrlCommand*)command
{
    NSDictionary* poplarProperties = [self poplarProperties];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:poplarProperties];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary*)poplarProperties
{
    NSMutableDictionary* poplarProps = [NSMutableDictionary dictionaryWithCapacity:4];
    poplarProps[@"readyState"] = [NSNumber numberWithInt:[_voipConnection readyState]];
    poplarProps[@"responseText"] = [_voipConnection responseText];
    poplarProps[@"responseXML"] = [_voipConnection responseXML];
    poplarProps[@"status"] = [NSNumber numberWithInt:[_voipConnection status]];
    poplarProps[@"statusText"] = [_voipConnection statusText];
    NSDictionary* devReturn = [NSDictionary dictionaryWithDictionary:poplarProps];
    return devReturn;
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}

- (void)init:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"init"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)abort:(CDVInvokedUrlCommand*)command
{
    [_voipConnection abort];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"abort"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getAllResponseHeaders:(CDVInvokedUrlCommand*)command
{
    NSString * allHeaders = [_voipConnection getAllResponseHeaders];;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:allHeaders];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getResponseHeader:(CDVInvokedUrlCommand*)command
{
    NSString* header = [command.arguments objectAtIndex:0];
    NSString *reponseHeader = [_voipConnection getResponseHeader:header];
    NSString *message = reponseHeader;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)open:(CDVInvokedUrlCommand*)command
{
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString *methodName = options[@"method"];
    NSString *url = options[@"url"];
    BOOL async = [options[@"async"] boolValue];
    NSString *username = options[@"username"];
    NSString *password = options[@"password"];
    
    [_voipConnection open:methodName url:url async:async username:username password:password];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"open"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)send:(CDVInvokedUrlCommand*)command
{
    id body = [command.arguments objectAtIndex:0];
    
    [_voipConnection sendWithBody:body];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"send"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setRequestHeader:(CDVInvokedUrlCommand*)command
{
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString *name = options[@"name"];
    NSString *value = options[@"value"];
    
    [_voipConnection setRequestHeaderWithName:name value:value];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"setRequestHeader"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setTimeout:(CDVInvokedUrlCommand*)command
{
    NSNumber* timeout = [command.arguments objectAtIndex:0];
    
    [_voipConnection setTimeout:[timeout doubleValue]];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"setTimeout"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - delegate

- (void)onReadyStateChange:(VoipConnection *)connection
{
    NSString * js =[NSString stringWithFormat:@"var me = poplar;\n"
                    "me.readyState = %d;\n"
                    "me.responseText = \"%@\";\n"
                    "me.responseXML = \"%@\";\n"
                    "me.status = %d;\n"
                    "me.statusText = \"%@\";\n"
                    "me.onreadystatechange();\n",
                    _voipConnection.readyState,
                    _voipConnection.responseText,
                    _voipConnection.responseXML == nil ? @"null":_voipConnection.responseXML,
                    _voipConnection.status,
                    _voipConnection.statusText == nil ? @"null":_voipConnection.statusText];
    [self.commandDelegate evalJs:js];
    
    if (_voipConnection.readyState == 4) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        [notification setUserInfo:@{@"Poplar" : @"Notification"}];
        notification.fireDate = [NSDate date];
        notification.alertBody = _voipConnection.responseText;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
