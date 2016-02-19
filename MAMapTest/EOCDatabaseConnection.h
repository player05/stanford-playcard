//
//  EOCDatabaseConnection.h
//  MAMapTest
//
//  Created by msp on 1/13/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EOCDatabaseConection
-(void)connect;
-(void)disconnect;
-(void)isConnected;
-(NSArray*)performQuery:(NSString*)query;
@end

@interface EOCDatabaseConnection : NSObject

@end

//@class EOCClassA;
//@class EOCClassB;
//
//@interface EOCClassA : NSObject
//
//@property(nonatomic,strong) EOCClassB * other;
//
//@end
//
//@interface EOCClassB : NSObject
//
//@property(nonatomic,strong) EOCClassA * other;
//
//@end

