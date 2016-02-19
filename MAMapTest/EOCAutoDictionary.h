//
//  EOCAutoDictionary.h
//  MAMapTest
//
//  Created by msp on 1/12/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface EOCAutoDictionary : NSObject

@property (nonatomic,strong)    NSString * string;
@property (nonatomic,strong)    NSNumber  * number;
@property (nonatomic,strong)    NSDate *   date;
@property (nonatomic,strong)    id  opaqueObject;

@end
