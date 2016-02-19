//
//  DropItViewController.m
//  MAMapTest
//
//  Created by msp on 1/19/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "DropItViewController.h"
#import "DropItView.h"
#import "DropDynamicBehavior.h"

@interface DropItViewController ()<UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet DropItView *myDropItView;
@property (nonatomic,strong) UIDynamicAnimator * animator;
@property (nonatomic,strong) UIGravityBehavior * gravity;
@property (nonatomic,strong) UICollisionBehavior * collision;
@property (nonatomic,strong) DropDynamicBehavior * dropBehavior;
@property (nonatomic,strong) UIAttachmentBehavior * attach;
@property (nonatomic,strong) UIView * droppingView;

@end

static const CGSize DROP_SIZR = {40,40};
@implementation DropItViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)Tap:(UITapGestureRecognizer *)sender {
    [self Drop];
}

- (IBAction)Pan:(UIPanGestureRecognizer *)sender {
    
    CGPoint gesturePoint = [sender locationInView:self.myDropItView];
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [self attachDroppintViewToPoint:gesturePoint];
    }else if(sender.state == UIGestureRecognizerStateChanged)
    {
        self.attach.anchorPoint = gesturePoint;
    }else if(sender.state == UIGestureRecognizerStateEnded)
    {
        [self.animator removeBehavior:self.attach];
        self.myDropItView.path =  nil;
    }
}

-(void)attachDroppintViewToPoint:(CGPoint)gesturePoint
{
    if(self.droppingView)
    {
        self.attach = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:gesturePoint];
        UIView *droppingView = self.droppingView;
        __weak DropItViewController * dropController = self;
        self.attach.action = ^{
            UIBezierPath * path = [[UIBezierPath alloc] init];
            [path moveToPoint:dropController.attach.anchorPoint];
            [path addLineToPoint:droppingView.center];
            dropController.myDropItView.path = path;
        };
        self.droppingView = nil;
        [self.animator addBehavior:self.attach];
    }
}

-(UIDynamicAnimator*)animator
{
    if(_animator == nil)
    {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_myDropItView];
        _animator.delegate = self;
    }
    return _animator;
}

//-(UIAttachmentBehavior *)attach
//{
//    if(!_attach)
//    {
//        _attach = [[UIAttachmentBehavior alloc] init];
//    }
//    return _attach;
//}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRow];
}

-(void)removeCompletedRow
{
    NSMutableArray * dropArray = [[NSMutableArray alloc]init];
    for (CGFloat y = self.myDropItView.bounds.size.height - DROP_SIZR.height/2; y>0; y+=DROP_SIZR.height) {
        BOOL rowIsCompleted = YES;
        NSMutableArray * founds = [[NSMutableArray alloc] init];
        for(int x = DROP_SIZR.width/2;x<=self.myDropItView.bounds.size.width-DROP_SIZR.width/2;x+=DROP_SIZR.width)
        {
            UIView * hitView = [self.myDropItView hitTest:CGPointMake(x, y) withEvent:NULL];
            if([hitView superview] == self.myDropItView)
            {
                [founds addObject:hitView];
            }else{
                rowIsCompleted = NO;
                break;
            }
        }
        if(![founds count])break;
        if(rowIsCompleted)[dropArray addObjectsFromArray:founds];
    }
    
    if([dropArray count])
    {
        for (UIView * dropView in dropArray) {
            [self.dropBehavior removeItem:dropView];
        }
        [self animationToRemoveDropView:dropArray];
    }
}

-(void)animationToRemoveDropView:(NSMutableArray *)dropArray
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         for(UIView * view in dropArray)
                         {
                             int x = (arc4random()%(int)self.myDropItView.bounds.size.width*5 - self.myDropItView.bounds.size.width*2);
                             int y = self.myDropItView.bounds.size.height;
                             view.center = CGPointMake(x, -y);
                         }
                         
                     }
                     completion:^(BOOL finish){
                         if(finish)
                         {
                             [dropArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         }
                     }];
}

-(DropDynamicBehavior*)dropBehavior
{
    if(_dropBehavior == nil)
    {
        _dropBehavior = [[DropDynamicBehavior alloc] init];
        [self.animator addBehavior:_dropBehavior];
    }
    return _dropBehavior;
}

-(void)Drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    
    frame.size = DROP_SIZR;
    
    int x = (arc4random()%(int)self.myDropItView.bounds.size.width) /DROP_SIZR.width;
    frame.origin.x = x * DROP_SIZR.width;
    _droppingView = [[UIView alloc] initWithFrame:frame];
    _droppingView.backgroundColor = [self randomColor];
    
    
    [self.myDropItView addSubview:_droppingView];
    
//    [self.gravity addItem:dropView];
//    [self.collision addItem:dropView];
    [self.dropBehavior addItem:_droppingView];
}

-(UIColor*)randomColor
{
    switch (arc4random()%5) {
        case 0:return [UIColor greenColor];break;
        case 1:return [UIColor redColor];break;
        case 2:return [UIColor yellowColor];break;
        case 3:return [UIColor purpleColor];break;
        case 4:return [UIColor blueColor];break;
        default:
            break;
    }
    return [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
