//
//  VoipConnection.h
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

#import <Foundation/Foundation.h>
#import "VoipConnectionDelegate.h"

@interface VoipConnection : NSObject

- (void)open:(NSString *)method
         url:(NSString *)url
       async:(BOOL)async
    username:(NSString *)username
    password:(NSString *)password;
- (void)sendWithBody:(id)body;
- (void)setRequestHeaderWithName:(NSString *)name value:(NSString *)value;
- (NSString *)getAllResponseHeaders;
- (NSString *)getResponseHeader:(NSString *)header;
- (void)abort;
- (void)setTimeout:(NSTimeInterval)timeInterval;

@property (nonatomic, assign) id<VoipConnectionDelegate> delegate;
@property (nonatomic, assign) short readyState;
@property (nonatomic, strong) NSString* responseText;
@property (nonatomic, strong) NSString* responseXML;
@property (nonatomic, assign) short status;
@property (nonatomic, strong) NSString* statusText;

@end
