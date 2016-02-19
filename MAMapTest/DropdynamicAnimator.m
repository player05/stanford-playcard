//
//  DropdynamicAnimator.m
//  MAMapTest
//
//  Created by msp on 1/19/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "DropdynamicAnimator.h"

@interface DropdynamicAnimator()
@property (nonatomic,strong) UIDynamicAnimator * animator;
@property (nonatomic,strong) UIGravityBehavior * gravity;
@property (nonatomic,strong) UICollisionBehavior * collision;
@property (nonatomic,strong) UIDynamicItemBehavior * rotetion;

@end

@implementation DropdynamicAnimator

-(instancetype)init
{
    self = [super init];
    
    return self;
}

-(UIGravityBehavior*)gravity
{
    if(_gravity == nil)
    {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9;
        [self.animator addBehavior:_gravity];
    }
    return _gravity;
}

-(UIDynamicItemBehavior*)rotetion
{
    if(_rotetion == nil)
    {
        _rotetion = [[UIDynamicItemBehavior alloc] init];
        _rotetion.allowsRotation = NO;
    }
    return _rotetion;
}

-(UICollisionBehavior*)collision
{
    if(_collision == nil)
    {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:_collision];
    }
    return _collision;
}

@end
