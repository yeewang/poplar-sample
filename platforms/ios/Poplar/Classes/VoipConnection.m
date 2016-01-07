//
//  VoipConnection.m
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

//#import "AFHTTPRequestOperation.h"
#import "VoipConnection.h"

@interface VoipConnection ()
@end

@implementation VoipConnection

+ (VoipConnection *)connection
{
    static VoipConnection * conn = nil;
    @synchronized(conn) {
        if (conn == nil)
            conn = [[VoipConnection alloc] init];
    }
    return conn;
}

- (VoipConnection *)init
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    _manager = [AFHTTPSessionManager manager];
    _manager.securityPolicy.allowInvalidCertificates = YES; // TODO: not recommended for production
    
    self = [super init];
    return self;
}

- (void)connect:(NSString *)url
{
    [_manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Request succeeded: %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Request failed: %@", error);
    }];
    
    // http://www.2cto.com/kf/201312/261962.html
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setNetworkServiceType:(NSURLNetworkServiceTypeVoIP)];
    
    [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        // <#code#>
    }];
}

@end
