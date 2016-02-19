//
//  DropDynamicBehavior.m
//  MAMapTest
//
//  Created by msp on 1/19/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "DropDynamicBehavior.h"

@interface DropDynamicBehavior()

@property (nonatomic,strong) UIGravityBehavior * gravity;
@property (nonatomic,strong) UICollisionBehavior * collision;
@property (nonatomic,strong) UIDynamicItemBehavior * rotetion;
@end

@implementation DropDynamicBehavior

-(instancetype)init
{
    self = [super init];
    [self addChildBehavior:self.collision];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.rotetion];
    return self;
}

-(UIGravityBehavior*)gravity
{
    if(_gravity == nil)
    {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9;

    }
    return _gravity;
}

-(UICollisionBehavior*)collision
{
    if(_collision == nil)
    {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collision;
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


-(void)addItem:(id<UIDynamicItem>)item
{
    [self.collision addItem:item];
    [self.gravity addItem:item];
    [self.rotetion addItem:item];
}

-(void)removeItem:(id<UIDynamicItem>)item
{
    [self.collision removeItem:item];
    [self.gravity removeItem:item];
    [self.rotetion removeItem:item];
}

@end

