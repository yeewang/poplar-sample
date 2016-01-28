//
//  VoipConnection.m
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

#import "VoipConnection.h"

@interface VoipConnection ()
@property (nonatomic, strong) NSString* url;
@property (nonatomic, assign) BOOL async;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) NSString* requestHeaders;
@property (nonatomic, strong) NSMutableURLRequest* request;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSURLSessionDataTask* dataTask;
@end

@implementation VoipConnection

+ (VoipConnection*)connection
{
    static VoipConnection* conn = nil;
    @synchronized(conn)
    {
        if (conn == nil) {
            conn = [[VoipConnection alloc] init];
        }
    }
    return conn;
}

- (VoipConnection*)init
{
    self = [super init];
    if (self != nil) {
#if 0
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.allowsBackgroundLocationUpdates = YES;
        
        self.locationManager.distanceFilter = 100000;
        self.locationManager.desiredAccuracy = 100000; // > kCLLocationAccuracyThreeKilometers;
        
        self.needLocationUpdate = NO;
#endif
        [self resetDefault];
    }
    return self;
}

- (void)resetDefault
{
    _timeoutInterval = 240;
    _readyState = 0;
    _responseText = nil;
    _responseXML = nil;
    _status = 0;
    _statusText = nil;
}

- (void)open:(NSString*)method
         url:(NSString*)url
       async:(BOOL)async
    username:(NSString*)username
    password:(NSString*)password
{
    if (_readyState == 0 || _readyState == 4) {
        self.requestHeaders = nil;
        [self resetDefault];
        
        self.url = url;
        self.async = async;
        
        // http://www.2cto.com/kf/201312/261962.html
        
        self.request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:self.url]];
        //        [_request setValue:authValue forKey:@"\"Authorization\""];
        //        [_request setValue:contentLengthVal forKey:@"\"Content-Length\""];
        //        [_request setValue:contentMD5Val forKey:@"\"Content-MD5\""];
        //        [_request setValue:contentTypeVal forKey:@"\"Content-Type\""];
        //        [_request setValue:dateVal forKey:@"\"Date\""];
        //        [_request setValue:hostVal forKey:@"\"Host\""];
        //        [_request setValue:publicValue forKey:@"\"public-read-write\""];
        
        [_request setNetworkServiceType:(NSURLNetworkServiceTypeVoIP)];
        [_request setHTTPMethod:method];
        [_request setHTTPShouldHandleCookies:YES];
        [_request setTimeoutInterval:_timeoutInterval];
        
        NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [_request setAllHTTPHeaderFields:headers];
        
        // [_request setValue:@"VALUE" forHTTPHeaderField:@"User-Agent"];
        [_request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        if (username != nil && password != nil) {
            //[[_manager requestSerializer] setAuthorizationHeaderFieldWithUsername:username password:password];
        }
        
        _readyState = 1;
        [self.delegate onReadyStateChange:[self encapsulate]];
    }
}

- (void)sendWithBody:(id)body
{
    if (_readyState == 1) {
        if (([[_request HTTPMethod] isEqualToString:@"POST"] ||
             [[_request HTTPMethod] isEqualToString:@"PUT"])
            && body != nil) {
            NSString* text = [body description];
            [self.request setHTTPBody:[text dataUsingEncoding:(NSUTF8StringEncoding)]];
        }
        
        _readyState = 2;
        [self.delegate onReadyStateChange:[self encapsulate]];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        self.session = [NSURLSession sharedSession];
        self.dataTask = [self.session dataTaskWithRequest:_request
                                        completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
                                            NSLog(@"Received %lld bytes content\n", [response expectedContentLength]);
                                            
                                            _readyState = 4;
                                            
                                            self.responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            self.responseXML = nil;
                                            self.status = [(NSHTTPURLResponse*)response statusCode];
                                            
                                            self.needLocationUpdate = NO;
                                            
                                            if (self.status == 200) {
                                                self.statusText = @"OK";
                                            }
                                            else if (self.status == 404) {
                                                self.statusText = @"Not Found";
                                            }
                                            else {
                                                self.needLocationUpdate = YES;
                                                
                                                if ([error code] == kCFURLErrorTimedOut) {
                                                    self.status = -1;
                                                    self.statusText = @"Timeout";
                                                }
                                                else {
                                                    self.statusText = @"Unknown";
                                                }
                                            }
                                            
                                            NSLog(@"Status code: %d\n", self.status);
                                            
                                            [self.delegate onReadyStateChange:[self encapsulate]];
                                            dispatch_semaphore_signal(semaphore);
                                            
                                            // Continue to perform send HTTP GET
                                            //_readyState = 1;
                                            //[self performSelectorInBackground:@selector(sendWithBody:) withObject:body];
                                        }];
        [self.dataTask resume];
        
        if (!_async) {
            if (_readyState != 4) {
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
    }
}

- (void)setRequestHeaderWithName:(NSString*)name value:(NSString*)value
{
    if (_readyState == 1) {
        [_request setValue:value forHTTPHeaderField:name];
    }
}

- (NSString*)getAllResponseHeaders
{
    if (_readyState < 3) {
        return nil;
    }
    
    NSMutableString* header = [[NSMutableString alloc] init];
    NSDictionary* headers = [_request allHTTPHeaderFields];
    for (NSString* key in headers) {
        [header appendFormat:@"%@:%@\r\n", key, headers[key]];
    }
    return header;
}

- (NSString*)getResponseHeader:(NSString*)header
{
    if (_readyState < 3) {
        return nil;
    }
    
    return [_request valueForHTTPHeaderField:header];
}

- (void)abort
{
    [self.dataTask cancel];
    _readyState = 0;
    [self.delegate onReadyStateChange:[self encapsulate]];
}

- (void)setTimeout:(NSTimeInterval)timeoutInterval
{
    if (_readyState == 0 || _readyState == 1 || _readyState == 4) {
        _timeoutInterval = timeoutInterval;
        [self.request setTimeoutInterval:timeoutInterval];
    }
}

- (NSDictionary*)encapsulate
{
    NSDictionary* info = @{ @"readyState" : [NSNumber numberWithInt:self.readyState],
                            @"responseText" : self.responseText == nil ? [NSNull null] : self.responseText,
                            @"responseXML" : self.responseXML == nil ? [NSNull null] : self.responseXML,
                            @"status" : [NSNumber numberWithInt:self.status],
                            @"statusText" : self.statusText == nil ? [NSNull null] : self.statusText };
    return info;
}

@end
