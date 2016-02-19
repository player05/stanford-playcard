//
//  EOCDataModel.m
//  MAMapTest
//
//  Created by msp on 1/13/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "EOCDataModel.h"
#import "EOCNetworkFecter.h"

@interface EOCDataModel()<EOCNetworkFecterDelegate>

@end

@implementation EOCDataModel

-(void)networkFecter:(EOCNetworkFecter*)fecter didreceiveData:(NSData*)data
{

}

-(void)networkFecter:(EOCNetworkFecter*)fecter didFailWithError:(NSError*)error
{
    
}

-(void)networkFecter:(EOCNetworkFecter*)fecter didUploadFileToServer:(float)flag
{
    
}

@end
