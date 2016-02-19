//
//  mySrollViewController.m
//  MAMapTest
//
//  Created by msp on 1/20/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "mySrollViewController.h"
#import <Masonry.h>
#import "mySrollPictureView.h"

@interface mySrollViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * myScrollView;
@property (nonatomic,strong) UIImageView * myImageView;

@property (nonatomic,strong) UIButton * pictureOneBtn;
@property (nonatomic,strong) UIButton * pictureTwoBtn;
@property (nonatomic,strong) UIButton * pictureThreeBtn;
@end

@implementation mySrollViewController

- (void)viewDidLoad_Scroll {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView * view = UIScrollView.new;
    view.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 20);
    view.minimumZoomScale = 0.5;
    view.maximumZoomScale = 2.0;
    view.backgroundColor = [UIColor redColor];
    
    view.contentSize = CGSizeMake(1000 , 1000);
    view.delegate = self;
    
    UIImageView * imageView = UIImageView.new;
    imageView.image = [UIImage imageNamed:@"pic"];
    
  //  imageView.frame = CGRectMake(0, 0, 1500, 1500);
    imageView.frame = view.frame;
    [view addSubview:imageView];
    
 //   [view scrollRectToVisible:CGRectMake(100, 100, 100 , 100) animated:YES];
    [self.view addSubview:view];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singerTap:)];
    
    [self.view addGestureRecognizer:tap];
    _myScrollView = view;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _pictureOneBtn = UIButton.new;
    _pictureOneBtn.titleLabel.text = @"Picture one";
    _pictureOneBtn.titleLabel.textColor = [UIColor blackColor];
 //   _pictureOneBtn.layer.backgroundColor = UIColor.redColor.CGColor;
    _pictureOneBtn.backgroundColor = [UIColor redColor];
    _pictureOneBtn.tag = PICTURE_ONE;
    [_pictureOneBtn addTarget:self action:@selector(showSelectPictureView:) forControlEvents:UIControlEventTouchUpInside];
    
    _pictureTwoBtn = UIButton.new;
    _pictureTwoBtn.titleLabel.text = @"Picture two";
    _pictureTwoBtn.titleLabel.textColor = [UIColor blueColor];
    _pictureTwoBtn.layer.backgroundColor = UIColor.blueColor.CGColor;

    _pictureTwoBtn.tag = PICTURE_TWO;
    [_pictureTwoBtn addTarget:self action:@selector(showSelectPictureView:) forControlEvents:UIControlEventTouchUpInside];
    
    _pictureThreeBtn = UIButton.new;
    _pictureThreeBtn.titleLabel.text = @"Picture one";
    _pictureThreeBtn.titleLabel.textColor = [UIColor yellowColor];
    _pictureThreeBtn.layer.backgroundColor = UIColor.yellowColor.CGColor;

    _pictureThreeBtn.tag = PICTURE_THREE;
    [_pictureThreeBtn addTarget:self action:@selector(showSelectPictureView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_pictureOneBtn];
    [self.view addSubview:_pictureTwoBtn];
    [self.view addSubview:_pictureThreeBtn];

    UIView *superview = self.view;
    int padding = 100;
    int offset = 10;
    
    [_pictureOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.greaterThanOrEqualTo(superview.top).offset(padding);
        make.left.equalTo(superview.left).offset(padding);
        make.bottom.equalTo(_pictureTwoBtn.top).offset(-offset);
        make.right.equalTo(superview.right).offset(-padding);
        make.width.equalTo(_pictureTwoBtn.width);
        make.width.equalTo(_pictureThreeBtn.width);
        
        make.height.equalTo(@[_pictureThreeBtn,_pictureTwoBtn ]);
    }];
    
    [_pictureTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pictureOneBtn.bottom).offset(offset);
        make.left.equalTo(superview.left).offset(padding);
        make.right.equalTo(superview.right).offset(-padding);
        make.bottom.equalTo(_pictureThreeBtn.top).offset(-offset);
        
        make.width.equalTo(_pictureOneBtn.width);
        make.width.equalTo(_pictureThreeBtn.width);
        
        make.height.equalTo(_pictureThreeBtn.height);
        make.height.equalTo(_pictureOneBtn.height);
    }];
    
    [_pictureThreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pictureTwoBtn.bottom).offset(offset);
        make.left.equalTo(superview.left).offset(padding);
        make.right.equalTo(superview.right).offset(-padding);
        make.bottom.equalTo(superview.bottom).offset(-padding);
        
        make.width.equalTo(_pictureTwoBtn.width);
        make.width.equalTo(_pictureOneBtn.width);
        
        make.height.equalTo(_pictureTwoBtn.height);
        make.height.equalTo(_pictureOneBtn.height);
    }];

    
}

-(void)showSelectPictureView:(UIButton*)btn
{
    mySrollPictureView * view = [[mySrollPictureView alloc] initWithFrame:self.view.frame url:[NSString stringWithFormat:@"http://img3.3lian.com/2013/s1/20/d/%ld.jpg",btn.tag+58]];
    
    [self.view addSubview:view];
    
}

-(void)singerTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:_myScrollView];
    
    [_myScrollView zoomToRect:CGRectMake(point.x, point.y, 100, 100) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = scrollView.contentOffset;
    
 //   CGRect rect  = [scrollView convertRect:scrollView.bounds toView:scrollView];
    
//    NSLog(@"%f-%f",point.x,point.y);
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
