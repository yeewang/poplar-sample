//
//  VoipConnection.h
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface VoipConnection : NSObject

+ (VoipConnection *)connection;
- (void)connect:(NSString *)url;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end
