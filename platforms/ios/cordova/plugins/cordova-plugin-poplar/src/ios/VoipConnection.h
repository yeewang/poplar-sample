//
//  VoipConnection.h
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "VoipConnectionDelegate.h"

@interface VoipConnection : NSObject

+ (VoipConnection *)connection;
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

@property (nonatomic, assign) id<VoipConnectionDelegate> delegate;
@property (readonly, nonatomic, assign) int state;
@property (readonly, nonatomic, assign) short readyState;
@property (readonly, nonatomic, strong) NSString* responseText;
@property (readonly, nonatomic, strong) NSString* responseXML;
@property (readonly, nonatomic, assign) short status;
@property (readonly, nonatomic, strong) NSString* statusText;

@end
