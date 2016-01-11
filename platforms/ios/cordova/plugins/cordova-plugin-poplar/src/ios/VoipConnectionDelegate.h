//
//  PoplarPushDelegate.h
//  Poplar
//
//  Created by Wang Yi on 12/25/15.
//
//

#import <Foundation/Foundation.h>


@class VoipConnection;

@protocol VoipConnectionDelegate <NSObject>

@required

- (void)onReadyStateChange:(VoipConnection *)connection;

@end
