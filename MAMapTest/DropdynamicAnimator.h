//
//  DropdynamicAnimator.h
//  MAMapTest
//
//  Created by msp on 1/19/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdynamicAnimator : UIDynamicAnimator

-(void)addItem:(id<UIDynamicItem>)item;
-(void)removeItem:(id<UIDynamicItem>)item;
@end
