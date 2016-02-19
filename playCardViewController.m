//
//  playCardViewController.m
//  MAMapTest
//
//  Created by msp on 1/18/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "playCardViewController.h"
#import "playCardView.h"

@interface playCardViewController ()
@property (weak, nonatomic) IBOutlet playCardView *myPlayCardView;

@end

@implementation playCardViewController

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super init])
    {
        self.view.frame = frame;
        [_myBlocks addObject:^{
            [self doSomething];
        }];
    }
    return self;
}

-(void)doSomething
{
    NSLog(@"doSomething-begain");
    NSLog(@"doSomething-end");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myPlayCardView.suit = @"❤️";
    _myPlayCardView.rank = 13;
    __weak playCardViewController * playController = self;
    if(_myBlocks == nil)
    {
        _myBlocks = [[NSMutableArray alloc]init];
    }
    [_myBlocks addObject:^{
        [playController doSomething];
    }];
    
    void (^doit)(void) = self.myBlocks[0];
    doit();
 //   __block BOOL
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
