//
//  mySecondViewController.m
//  MAMapTest
//
//  Created by msp on 1/15/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "mySecondViewController.h"

@interface mySecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorText;
@property (weak, nonatomic) IBOutlet UILabel *outlineText;

@end

@implementation mySecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad2");
//    self.textToAnalyze = [[NSAttributedString alloc] initWithString:@"Test is fine" attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSStrokeWidthAttributeName:@-3}];
    
    
    [self updateUI];
    // Do any additional setup after loading the view.
}

-(void)awakeFromNib
{
    NSLog(@"awakeFromNib2");
}


-(void)setTextToAnalyze:(NSAttributedString *)textToAnalyze
{
    _textToAnalyze = textToAnalyze;
    if(self.view.window) [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear2");
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI
{
    self.colorText.text = [NSString stringWithFormat:@"%lu colorful characters",
                      (unsigned long)[self characterMacthSelectedString:NSForegroundColorAttributeName].length];
    self.outlineText.text = [NSString stringWithFormat:@"%lu outlineText characters",
                           (unsigned long)[self characterMacthSelectedString:NSStrokeWidthAttributeName].length];
    
    UIView * btn = [[UIView alloc] init];
    btn.frame = CGRectMake(100, self.outlineText.frame.origin.y + self.outlineText.frame.size.height + 20, 100, 100);
    btn.backgroundColor  =[UIColor blackColor];
    
    [self.view addSubview:btn];
    [UIView animateWithDuration:3.0 delay:1 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(){
                        btn.frame = CGRectMake(200, self.outlineText.frame.origin.y + self.outlineText.frame.size.height + 20, 100, 100);
                     }
                     completion:^(BOOL stop){
                         if(stop){
                             NSLog(@"animateWithDuration-stop");
                         }
                     }];
    [UIView animateWithDuration:3.0 delay:1 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^(){
                         btn.frame = CGRectMake(200, self.outlineText.frame.origin.y + self.outlineText.frame.size.height + 20, 100, 100);
                     }
                     completion:^(BOOL stop){
                         NSLog(@"animateWithDuration-stop");
                     }];
//    [btn animateWithDuration:]
//    [btn animateWithDuration:]
    
}

-(NSAttributedString*)characterMacthSelectedString:(NSString*)selected
{
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] init];
    
    NSRange range ;
    int index = 0;
    while (index < [self.textToAnalyze length]) {
        id value = [self.textToAnalyze attribute:selected atIndex:index effectiveRange:&range];
        
        if(value)
        {
            [attributeString appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = (int)(range.location + range.length);
        }
        else{
            index ++;
        }
    }
   
    
    return attributeString;
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
