//
//  NSString+EOCMyAddtions.m
//  MAMapTest
//
//  Created by msp on 1/12/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+EOCMyAddtions.h"

@implementation NSString(EOCMyAddtions)

-(NSString*)eoc_myLowercaseString
{
    NSString * lowercase = [self eoc_myLowercaseString];
    NSLog(@"%@-->%@",self,lowercase);
    return lowercase;
}

@end
