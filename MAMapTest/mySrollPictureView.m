//
//  mySrollPictureView.m
//  MAMapTest
//
//  Created by msp on 1/21/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "mySrollPictureView.h"

@interface mySrollPictureView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView  * imageView;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) UIScrollView * myScrollView;
@property (nonatomic,strong) NSURL * myStringUrl;
@property (nonatomic,strong) UIButton * myReturnBtn;

@end

@implementation mySrollPictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame url:(NSString*)url
{
    if(self = [super initWithFrame:frame])
    {
        _myStringUrl = [[NSURL alloc] initWithString:url];
    //    _myStringUrl = url;
        [self updateUI];
    
    }
    
    return self;
}

-(void)setImage:(UIImage *)image
{
    image = image;
}

-(UIImage *)image
{
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:_myStringUrl];
    NSURLSessionConfiguration * configueration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configueration];
    NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error)
        {
            if([request.URL isEqual:self.myStringUrl])
            {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }
        }
    }];
    [task resume];
    
    return self.image;
}

-(void)updateUI
{
    
    _myScrollView = [[UIScrollView alloc] init];
    _myScrollView.frame = CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-10);
    _myScrollView.backgroundColor = [UIColor greenColor];
    _myScrollView.maximumZoomScale = 2.0;
    _myScrollView.minimumZoomScale = 0.5;
    _myScrollView.delegate = self;
   // _myScrollView.contentSize = CGSizeMake(_myScrollView.frame.size.width*2,_myScrollView.frame.size.height*2) ;
    _myScrollView.contentSize = _myScrollView.frame.size;
    [self addSubview:_myScrollView];
    
    _myReturnBtn = [[UIButton alloc] init];
    _myReturnBtn.frame = CGRectMake(10, 10, 40, 40);
    _myReturnBtn.backgroundColor = [UIColor redColor];
    [_myReturnBtn addTarget:self action:@selector(returnBackToSuperView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_myReturnBtn];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, _myScrollView.frame.size.width, _myScrollView.frame.size.height);
    
 //   _imageView.image = [UIImage imageWithContentsOfFile:_myStringUrl];
    
 //   _imageView.image = _image;
    
    [_myScrollView addSubview:_imageView];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for(UIView * view in [scrollView subviews])
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            return view;
        }
    }
    return nil;
}

-(void)returnBackToSuperView
{
    [self removeFromSuperview];
}

@end
