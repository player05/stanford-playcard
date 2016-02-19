//
//  EOCNetworkFecter.h
//  MAMapTest
//
//  Created by msp on 1/13/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EOCNetworkFecter;

@protocol EOCNetworkFecterDelegate <NSObject>
@optional
-(void)networkFecter:(EOCNetworkFecter*)fecter didreceiveData:(NSData*)data;
-(void)networkFecter:(EOCNetworkFecter*)fecter didFailWithError:(NSError*)error;
-(void)networkFecter:(EOCNetworkFecter*)fecter didUploadFileToServer:(float)flag;
@end


typedef void (^EOCNetworkFecterCompletionHandler)(NSData* data);

@interface EOCNetworkFecter : NSObject

@property (nonatomic,weak)id<EOCNetworkFecterDelegate> delegate;

-(id)initWithURL:(NSURL*)url;
-(void)startWithCompletionHandler:(EOCNetworkFecterCompletionHandler)handler;

@end
