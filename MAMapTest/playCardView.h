//
//  playCardView.h
//  MAMapTest
//
//  Created by msp on 1/18/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playCardView : UIView

@property (nonatomic,strong) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;
@end
