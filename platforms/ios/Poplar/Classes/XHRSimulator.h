//
//  XHRSimulator.h
//  Poplar
//
//  Created by Wang Yi on 12/23/15.
//
//

#import <Foundation/Foundation.h>

@interface XHRSimulator : NSObject

- (XHRSimulator *)initWithWebView:(UIWebView *)webView;
- (NSString *)createXHR;

@end
