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

@interface CDVPoplar () {}
@end

@implementation CDVPoplar

- (void)getPoplarInfo:(CDVInvokedUrlCommand*)command
{
    NSDictionary* poplarProperties = [self poplarProperties];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:poplarProperties];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary*)poplarProperties
{
    NSMutableDictionary* poplarProps = [NSMutableDictionary dictionaryWithCapacity:4];
    poplarProps[@"readyState"] = [NSNumber numberWithInt:0];
    poplarProps[@"responseText"] = @"";
    poplarProps[@"responseXML"] = @"";
    poplarProps[@"status"] = @"200";
    poplarProps[@"statusText"] = @"200";
    NSDictionary* devReturn = [NSDictionary dictionaryWithDictionary:poplarProps];
    return devReturn;
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}

- (void)abort:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"abort"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getAllResponseHeaders:(CDVInvokedUrlCommand*)command
{
    NSMutableDictionary* message = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString * allHeaders = [message description];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:allHeaders];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getResponseHeader:(CDVInvokedUrlCommand*)command
{
    NSString* header = [command.arguments objectAtIndex:0];
    NSDictionary *reponseHeader = nil; //TODO:
    
    NSString *message = reponseHeader[header];
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
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"open"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)send:(CDVInvokedUrlCommand*)command
{
    NSDictionary* body = [command.arguments objectAtIndex:0];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"send"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setRequestHeader:(CDVInvokedUrlCommand*)command
{
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString *name = options[@"name"];
    NSString *value = options[@"value"];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"setRequestHeader"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
