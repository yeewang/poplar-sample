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
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) BOOL async;
@property (nonatomic, strong) NSString * requestHeaders;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (atomic, strong) NSURLSessionDataTask *session;
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
    if (self != nil) {
        _state = 0;
    }
    return self;
}

- (void)open:(NSString *)method
         url:(NSString *)url
       async:(BOOL)async
    username:(NSString *)username
    password:(NSString *)password
{
    if (_readyState == 0 || _readyState == 4) {
        self.requestHeaders = nil;
        _responseText = nil;
        _responseXML = nil;
        _status = 0;
        _statusText = nil;
        
        self.url = url;
        self.async = async;
        
        // http://www.2cto.com/kf/201312/261962.html
        
        self.request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:self.url]];
        [_request setNetworkServiceType:(NSURLNetworkServiceTypeVoIP)];
        [_request setHTTPMethod:method];
        [_request setHTTPShouldHandleCookies:YES];
        [_request setTimeoutInterval:3600 * 24];
        [_request setValue:@"VALUE" forHTTPHeaderField:@"cookie"];
        [_request setValue:@"VALUE" forHTTPHeaderField:@"User-Agent"];
        
        if (username != nil && password != nil) {
            [[_manager requestSerializer] setAuthorizationHeaderFieldWithUsername:username password:password];
        }
        
        _readyState = 1;
        [self.delegate onReadyStateChange:self];
    }
}

- (void)sendWithBody:(id)body
{
    if (_readyState == 1) {
        if (body != nil) {
            NSString *text = [body description];
            [self.request setHTTPBody:[text dataUsingEncoding:(NSUTF8StringEncoding)]];
        }
        
        _readyState = 2;
        [self.delegate onReadyStateChange:self];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        self.session = [_manager dataTaskWithRequest:self.request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            NSLog(@"Response %lld content\n", [response expectedContentLength]);
            
            NSString* s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            _responseText = s;
            _responseXML = nil;
            _status = [(NSHTTPURLResponse *)response statusCode];
            if (_status == 200) {
                _statusText = @"OK";
            }
            else if (_status == 404) {
                _statusText = @"Not Found";
            }
            else {
                _statusText = @"Unknown";
            }

            _readyState = 4;
            [self.delegate onReadyStateChange:self];
            dispatch_semaphore_signal(semaphore);
        }];
        
        if (!_async) {
            if (_readyState != 4) {
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
    }
}

- (void)setRequestHeaderWithName:(NSString *) name value:(NSString *) value
{
    if (_readyState == 1) {
        [_request setValue:value forHTTPHeaderField:name];
    }
}

- (NSString *)getAllResponseHeaders
{
    if (_readyState < 3) {
        return nil;
    }
    
    NSMutableString *header = [[NSMutableString alloc] init];
    NSDictionary *headers = [_request allHTTPHeaderFields];
    for (NSString *key in headers) {
        [header appendFormat:@"%@:%@\r\n", key, headers[key]];
    }
    return header;
}

- (NSString *)getResponseHeader:(NSString *)header
{
    if (_readyState < 3) {
        return nil;
    }
    
    return [_request valueForHTTPHeaderField:header];
}

- (void)abort
{
    [self.session cancel];
    _readyState = 0;
    [self.delegate onReadyStateChange:self];
}

@end
