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

- (NSString*)uniqueAppInstanceIdentifier:(UIPoplar*)device
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString* UUID_KEY = @"CDVUUID";
    
    // Check user defaults first to maintain backwards compaitibility with previous versions
    // which didn't user identifierForVendor
    NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
    if (app_uuid == nil) {
        app_uuid = @"xxxxxx";
        [userDefaults setObject:app_uuid forKey:UUID_KEY];
        [userDefaults synchronize];
    }
    
    return app_uuid;
}

- (void)getPoplarInfo:(CDVInvokedUrlCommand*)command
{
    NSDictionary* deviceProperties = [self deviceProperties];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:deviceProperties];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary*)deviceProperties
{
    UIPoplar* device = [UIPoplar currentPoplar];
    NSMutableDictionary* devProps = [NSMutableDictionary dictionaryWithCapacity:4];

    [devProps setObject:@"Apple" forKey:@"manufacturer"];
    [devProps setObject:[device modelVersion] forKey:@"model"];
    [devProps setObject:@"iOS" forKey:@"platform"];
    [devProps setObject:[device systemVersion] forKey:@"version"];
    [devProps setObject:[self uniqueAppInstanceIdentifier:device] forKey:@"uuid"];
    [devProps setObject:[[self class] cordovaVersion] forKey:@"cordova"];
    [devProps setObject:@([self isVirtual]) forKey:@"isVirtual"];
    NSDictionary* devReturn = [NSDictionary dictionaryWithDictionary:devProps];
    return devReturn;
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}

- (BOOL)isVirtual
{
    #if TARGET_OS_SIMULATOR
        return true;
    #elif TARGET_IPHONE_SIMULATOR
        return true;
    #else
        return false;
    #endif
}

@end
