//
//  EOCNetworkFecter.m
//  MAMapTest
//
//  Created by msp on 1/13/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "EOCNetworkFecter.h"

@interface EOCNetworkFecter()
{
    struct {
        unsigned int didReceiveData : 1;
        unsigned int didFailWithError :1;
        unsigned int didUpdateProgessTo :1;
    }_delegateFlags;
}
@end

@implementation EOCNetworkFecter

-(void)receivedDataFromServer
{
    if([_delegate respondsToSelector:@selector(networkFecter:didreceiveData:)])
    {
        [_delegate networkFecter:self didreceiveData:nil];
    }
    if(_delegateFlags.didFailWithError)
    {
        [_delegate networkFecter:self didFailWithError:nil];
    }
}

-(void)setDelegate:(id<EOCNetworkFecterDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlags.didReceiveData = [_delegate respondsToSelector:@selector(networkFecter:didreceiveData:)];
    _delegateFlags.didFailWithError = [_delegate respondsToSelector:@selector(networkFecter:didFailWithError:)];
    _delegateFlags.didUpdateProgessTo = [_delegate respondsToSelector:@selector(networkFecter:didUploadFileToServer:)];
}

-(id)initWithURL:(NSURL*)url
{
    if(self = [super init])
    {
        
    }
    return self;
}

-(void)startWithCompletionHandler:(EOCNetworkFecterCompletionHandler)handler
{
    NSData * data = [[NSData alloc] init];
    
    handler(data);
}

@end
