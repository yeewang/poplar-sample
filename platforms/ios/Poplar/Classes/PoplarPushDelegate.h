//
//  PoplarPushDelegate.h
//  Poplar
//
//  Created by Wang Yi on 12/25/15.
//
//

#import <Foundation/Foundation.h>


@class PoplarPush;

@protocol PoplarPushDelegate <NSObject>

@required

- (void)pushSink:(PoplarPush *)pushSink didReceiveMessage:(NSString *)message;

@end
