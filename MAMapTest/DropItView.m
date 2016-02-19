//
//  DropItView.m
//  MAMapTest
//
//  Created by msp on 1/19/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "DropItView.h"

@implementation DropItView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [self.path stroke];
}

@end
