//
//  PoplarPush.h
//  Poplar
//
//  Created by Wang Yi on 12/21/15.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface PoplarPush : CDVPlugin

- (void) applicationDidEnterBackground:(NSNotification *)notification;
- (void) applicationWillEnterForeground:(NSNotification *)notification;

@end
