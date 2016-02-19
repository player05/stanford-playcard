//
//  playCardView.m
//  MAMapTest
//
//  Created by msp on 1/18/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "playCardView.h"

@implementation playCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsLayout];
}

-(void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsLayout];
}

-(void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsLayout];
}

#pragma mark -drawing
#define CORNER_FONT_STANDARD_HEIGHT    180.0
#define CORNER_RADIUS  12.0

-(CGFloat)cornerScaleFactor{return self.bounds.size.height /CORNER_FONT_STANDARD_HEIGHT;}
-(CGFloat)cornerRadius{return CORNER_RADIUS*[self cornerScaleFactor];}
-(CGFloat)cornerOffset{return [self cornerRadius]/3.0;};

-(void)drawRect:(CGRect)rect
{
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
 //   CGContextSaveGState();
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    
    [self DrawCornerView];
}

-(NSString*)rankAsString
{
    return @[@"?",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][_rank];
    
}

-(void)DrawCornerView
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont * cornFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    cornFont = [cornFont fontWithSize:cornFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString * cornText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankAsString],_suit] attributes:@{NSFontAttributeName:cornFont,NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGRect textBouds;
    textBouds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBouds.size = [cornText size];
    [cornText drawInRect:textBouds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//     CGContextSaveGState(context);
    CGContextTranslateCTM(context, [self cornerOffset],[self cornerOffset]);
    CGContextRotateCTM(context, M_PI);
    
    [cornText drawInRect:textBouds];
}

#pragma mark - Initiaztion
-(void)setUp
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib
{
    [self setUp];
}
@end
