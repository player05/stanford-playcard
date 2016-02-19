//
//  ViewController.m
//  MAMapTest
//
//  Created by msp on 1/8/16.
//  Copyright © 2016 zw. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapSearchKit/AMapSearchObj.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "EOCAutoDictionary.h"
#import "NSString+EOCMyAddtions.h"
#import "EOCPerson.h"
#import "EOCNetworkFecter.h"
#import "myViewController.h"
#import "mySecondViewController.h"

static const NSString * kAlertViewAssoicte = @"kAlertViewAssoicte";

@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate,UIAlertViewDelegate>
{
    MAMapView * _mapView;
    AMapSearchAPI * _mapSearch;
}
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;
@end

@implementation ViewController

#define TileOverlayViewControllerCoordinate CLLocationCoordinate2DMake(39.910695, 116.372830)

- (MATileOverlay *)constructTileOverlayWithFloor:(NSInteger)floor
{
    //
    /* 构建tileOverlay的URL模版. */
    NSString *URLTemplate = [NSString stringWithFormat: @"http://sdkdemo.amap.com:8080/tileserver/Tile?x={x}&y={y}&z={z}&f=%ld", (long)floor];
    
    MATileOverlay *tileOverlay = [[MATileOverlay alloc] initWithURLTemplate:URLTemplate];
    
    tileOverlay.minimumZ = 18; //设置可见最小Zoom值
    tileOverlay.maximumZ = 20; //设置可见最大Zoom值
    
    tileOverlay.boundingMapRect = MAMapRectForCoordinateRegion(MACoordinateRegionMakeWithDistance(TileOverlayViewControllerCoordinate, 200, 200)); //设置可渲染区域
    
    return tileOverlay;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"mySecondView"])
    {
        NSLog(@"This mySecondView");
        if([segue.destinationViewController isKindOfClass:[mySecondViewController class]])
        {
            mySecondViewController * vc = (mySecondViewController*)segue.destinationViewController;
            vc.textToAnalyze = self.body.textStorage;
            
        }
        
    }
}


-(void)awakeFromNib
{
    NSLog(@"awakeFromNib");
}

- (IBAction)changeBodyColorMatchBackgroudcoler:(UIButton*)sender {
    [self.body.textStorage addAttribute:NSForegroundColorAttributeName
                                  value:sender.backgroundColor
                                  range:self.body.selectedRange];
}

//- (IBAction)bodyOutlineSelectText:(UIButton *)sender {
//    [self.body.textStorage addAttributes:@{NSStrokeColorAttributeName: @-3,
//                                          NSStrokeColorAttributeName:[UIColor blackColor]}
//                                  range:self.body.selectedRange];
//}
//
//- (IBAction)bodyUnOutlineSelectText:(UIButton *)sender {
//    [self.body.textStorage removeAttribute:NSStrokeColorAttributeName
//                                     range:self.body.selectedRange];
//}
- (IBAction)bodyOutlineSelectText {
    [self.body.textStorage addAttributes:@{NSStrokeWidthAttributeName: @3,                                        NSStrokeColorAttributeName:[UIColor redColor]}
range:self.body.selectedRange];
    
//    UIStoryboard * story = [UIStoryboard storyboardWithName:@"myfirst" bundle:nil];
//    myViewController * myController = [story instantiateInitialViewController];
//    [myController setUpForMyController];

}
- (IBAction)bodyUnOutlineSelectText {
    
    [self.body.textStorage removeAttribute:NSStrokeColorAttributeName
                                          range:self.body.selectedRange];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithAttributedString:self.outlineButton.currentAttributedTitle];
    [title setAttributes:@{NSStrokeWidthAttributeName:@-3,
                          NSStrokeColorAttributeName:self.outlineButton.tintColor}
                   range:NSMakeRange(0, [title length])];
    [self.outlineButton setAttributedTitle:title    forState:UIControlStateNormal];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappend:)];
    [self.body addGestureRecognizer:panGesture];
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureHappend:)];
    [self.view addGestureRecognizer:pinGesture];
}

-(void)pinGestureHappend:(UIPinchGestureRecognizer*)recognizer
{
    NSLog(@"pinGestureHappend--%f",recognizer.scale);
}

-(void)panGestureHappend:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer translationInView:self.view];
    CGPoint point2 = [recognizer translationInView:self.body];
    NSLog(@"panGestureHappend-%f-%f",point.x,point.y);
    NSLog(@"panGestureHappend2-%f-%f",point2.x,point2.y);
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self myPreferredFontChange];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredFontChange:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

-(void)preferredFontChange:(NSNotification*)notification
{
    [self myPreferredFontChange];
}

-(void)myPreferredFontChange
{
    self.body.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.headline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

-(void)viewDidLoad_D
{
    [super viewDidLoad];
    
    NSURL * url = [[NSURL alloc] initWithString:@"http://www.baidu.com"];
    
    EOCNetworkFecter * fecter = [[EOCNetworkFecter alloc] initWithURL:url];
    
    [fecter startWithCompletionHandler:^(NSData *data) {
        NSData * myData = data;
        
        NSLog(@"myData:%@",myData);
    }];
}

-(void)viewDidLoad_C
{
    [super viewDidLoad];
    
    NSString * name = @"Memu";
    EOCPerson * person = [[EOCPerson alloc] initWithName:name andAddress:@"beijing"];
    EOCPerson * person1 = [[EOCPerson alloc] initWithName:@"Swift" andAddress:@"shanghai"];
   
    [person addFriend:person1];
    
    EOCPerson * person3 = [[EOCPerson alloc] initWithName:@"adele" andAddress:@"newyork"];
    [person addFriend:person3];
    
    EOCPerson * person2 = [person copy];
    name = @"John";
    person1.address = @"guangzhou";
    NSLog(@"person2-->%@",person2);
    
    person.name = @"adele";
    
//    NSmutableSet * set = [NSMutableSet alloc] initWithSet:<#(nonnull NSSet *)#> copyItems:<#(BOOL)#>]

    NSLog(@"person-->%@",person);
    
    person3.name = @"robin";
    
    NSLog(@"person2-1-->%@",person2);
    
    NSLog(@"person-1-->%@",person);
}

- (void)viewDidLoad_B {
    [super viewDidLoad];
    
//    NSString *string = @"dddd";
//    NSString *stringCopy = [string copy];
//    string = @"ttttt";
//    NSMutableString *stringDCopy = [string mutableCopy];
//    [stringDCopy appendString:@"!!"];
    
    // create an immutable array
    NSArray *arr = [NSArray arrayWithObjects: @"one", @"two", @"three", nil ];
    NSArray *arrB = @[@"one", @"two", @"three"];
    
    // create a mutable copy, and mutate it
    NSMutableArray *mut = [arrB mutableCopy];
    [mut removeObject: @"one"];
    
    NSLog(@"%@--2:%@",arr,mut);
    
    NSMutableSet * set = [[NSMutableSet alloc]init];
    
    NSMutableArray * arrayA = [@[@1,@2] mutableCopy];
    
    [set addObject:arrayA];
    
//    NSLog(@"%@",set);
    
    
    NSMutableArray * arrayB = [@[@1] mutableCopy];
    
    [set addObject:arrayB];
    
    NSLog(@"1---%@",set);
    
    [arrayB addObject:@2];
    
     NSLog(@"2---%@",set);
    
    NSMutableArray * arrayC = [@[@1,@2] mutableCopy];
    
    [set addObject:arrayC];
    
    NSLog(@"3--%@",set);
    
    NSSet * setB = [set copy];
    
    NSLog(@"setB--%@",setB);
    
    UIButton * btn = [[UIButton alloc]init];
    
    btn.frame = CGRectMake(50,50 , 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(askUserQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    EOCAutoDictionary *dict = [EOCAutoDictionary new];
    dict.date = [NSDate dateWithTimeIntervalSince1970:475372800];
//    dict.string = @"nice";
//    NSLog(@"dict.date = %@,dict.string = %@", dict.date,dict.string);
//    Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
//    Method swapMethod = class_getInstanceMethod([NSString class], @selector(uppercaseString));
//    
//    method_exchangeImplementations(originalMethod, swapMethod);
//    
//    NSString * string = @"this Is My First runtime function";
//    NSString * lowString = [string lowercaseString];
//    NSLog(@"low:%@",lowString);
    
    Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method swapMethod = class_getInstanceMethod([NSString class], @selector(eoc_myLowercaseString));

    method_exchangeImplementations(originalMethod, swapMethod);

    NSString * string = @"this Is My First runtime function";
    NSString * lowString = [string lowercaseString];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if(buttonIndex == 0)
//    {
//        NSLog(@"OK");
//    }else if (buttonIndex == 1)
//    {
//        NSLog(@"Cancel");
//    }
    
    void (^block)(NSInteger) = objc_getAssociatedObject(@"123", &kAlertViewAssoicte);
    block(buttonIndex);
}

-(void)dosomething
{
    
}

-(void)askUserQuestion
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"OK" message:@"this is alert" delegate:self cancelButtonTitle:@"Canel" otherButtonTitles:@"OK", nil];
    
    void(^block)(NSInteger)=^(NSInteger buttonIndex)
    {
        if(buttonIndex == 0)
        {
            NSLog(@"OK");
        }else if (buttonIndex == 1)
        {
            
            
            NSLog(@"Cancel");
        }
    };
//    objc_msgSend(self,dosomething);
    objc_setAssociatedObject(@"123",&kAlertViewAssoicte,block,OBJC_ASSOCIATION_ASSIGN);
    [alertView show];
    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//                                                                   message:@"This is an alert."
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                    
//        handler:^(UIAlertAction * action)
//    {
//        NSLog(@"alert OK");
//    }];
//    
//    
//    UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
//                                    
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        NSLog(@"alert Cancel");
//                                    }];
//    
//    UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"do" style:UIAlertActionStyleDefault
//                                     
//                                                           handler:^(UIAlertAction * action)
//                                     {
//                                         NSLog(@"alert do");
//                                         NSLog(@"----%@",alert.textFields[0].text);
//                                     }];
//    
//    [alert addAction:defaultAction];
//    [alert addAction:defaultAction1];
//    [alert addAction:defaultAction2];
//    
//    alert.preferredAction = defaultAction2;
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        NSLog(@"----%@",textField.text);
//    }];
//
//    [self presentViewController:alert animated:YES completion:^(void)
//     {
//         NSLog(@"alert end");
//     }];
//
}

-(void)objc_setAss
{
   // objc_msgSend();
   // objc_setAssociatedObject();
}

- (void)viewDidLoad_Map {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"e636a668b89ccae76920bcc97c8e3f9b";
    [AMapSearchServices sharedServices].apiKey = @"e636a668b89ccae76920bcc97c8e3f9b";
    
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
//    _mapView.showsLabels = NO;
    _mapView.delegate = self;
//    _mapView.mapType = MAMapTypeSatellite;
//    _mapView.showsLabels = NO;
//    _mapView.showTraffic = YES;
    _mapView.compassOrigin = CGPointMake(50, 50);
    
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
    
    
    //构造多边形数据对象
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.810892;
    coordinates[0].longitude = 116.233413;
    
    coordinates[1].latitude = 39.816600;
    coordinates[1].longitude = 116.331842;
    
    coordinates[2].latitude = 39.762187;
    coordinates[2].longitude = 116.357932;
    
    coordinates[3].latitude = 39.733653;
    coordinates[3].longitude = 116.278255;
    
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: polygon];
    
    //构造圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.952136, 116.50095) radius:5000];
    
    //在地图上添加圆
    [_mapView addOverlay: circle];
    
    CLLocationCoordinate2D geodesicCoords[2];
    geodesicCoords[0].latitude = 39.905151;
    geodesicCoords[0].longitude = 116.401726;
    
    geodesicCoords[1].latitude = 38.905151;
    geodesicCoords[1].longitude = 70.401726;
    
    //构造大地曲线对象
    MAGeodesicPolyline *geodesicPolyline = [MAGeodesicPolyline polylineWithCoordinates:geodesicCoords count:2];
    
    [_mapView addOverlay:geodesicPolyline];
    
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake
                                                                 (39.939577, 116.388331),CLLocationCoordinate2DMake(39.935029, 116.384377));
    
    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"xiaojiaoya"]];
    
    [_mapView addOverlay:groundOverlay];
    _mapView.visibleMapRect = groundOverlay.boundingMapRect;
//    CLLocationCoordinate2D toCoordiante = CLLocationCoordinate2DMake(22.5525792314,114.0904970893);
//    CABasicAnimation *centerAnimation = [CABasicAnimation animationWithKeyPath:kMAMapLayerCenterMapPointKey];
//    centerAnimation.duration       = 3.f;
//    centerAnimation.toValue        = [NSValue valueWithMAMapPoint:MAMapPointForCoordinate(toCoordiante)];
//    centerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    [_mapView.layer addAnimation:centerAnimation forKey:kMAMapLayerCenterMapPointKey];
    
    _mapView.centerCoordinate   = TileOverlayViewControllerCoordinate;
    _mapView.zoomLevel          = 19;
    
    [_mapView addOverlay: [self constructTileOverlayWithFloor:3]];
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
    
//    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
//    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    [self.view addSubview:_mapView];
    
    //初始化检索对象
    _mapSearch = [[AMapSearchAPI alloc] init];
    _mapSearch.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.keywords = @"方恒";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
//    [_mapSearch AMapPOIAroundSearch: request];
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:39.990459     longitude:116.481476];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_mapSearch AMapReGoecodeSearch: regeo];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode.formattedAddress];
        NSLog(@"ReGeo: %@", result);
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MAPointAnnotation * point = [[MAPointAnnotation alloc]init];
    point.coordinate = CLLocationCoordinate2DMake(39.989632, 116.481018);
    point.title = @"深圳康佳大厦";
    point.subtitle = @"北京子公司";
    [_mapView addAnnotation:point];
}

//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorRed;
//        return annotationView;
//    }
//    return nil;
//}

//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
//        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:reuseIndetifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"xiaojiaoya"];
//        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
//        return annotationView;
//    }
//    return nil;
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"redPin"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineView.lineJoinType = kMALineJoinMiter;//连接类型
        polylineView.lineCapType = kMALineCapArrow;//端点类型
        
        int n = [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"xiaojiaoya"]];
        
        NSLog(@"MAOverlayView-%d",n);
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        
        polygonView.lineWidth = 5.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        polygonView.fillColor = [UIColor colorWithRed:0.77 green:0.88 blue:0.94 alpha:0.8];
        polygonView.lineJoinType = kMALineJoinMiter;//连接类型
        
        return polygonView;
    }
    
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 5.f;
        circleView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        circleView.lineDash = NO;
        
        return circleView;
    }
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 8.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.8];
        
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]
                                                  initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayView *tileOverlayView = [[MATileOverlayView alloc] initWithTileOverlay:overlay];
        
        return tileOverlayView;
    }

    return nil;
}

//- (void)setupCities
//{
//    self.sectionTitles = @[@"全国", @"直辖市", @"省份"];
//    
//    self.cities = [MAOfflineMap sharedOfflineMap].cities;//普通城市和直辖市
//    self.provinces = [MAOfflineMap sharedOfflineMap].provinces;//省
//    self.municipalities = [MAOfflineMap sharedOfflineMap].municipalities;//直辖市
//    
//}
//
//- (MAOfflineItem *)itemForIndexPath:(NSIndexPath *)indexPath
//{
//    MAOfflineItem *item = nil;
//    switch (indexPath.section)
//    {
//        case 0:
//        {
//            item = [MAOfflineMap sharedOfflineMap].nationWide;//全国概要图
//            break;
//        }
//        case 1:
//        {
//            item = self.municipalities[indexPath.row];//直辖市
//            break;
//        }
//        case 2:
//        {
//            item = nil;
//            break;
//        }
//        default:
//        {
//            MAOfflineProvince *pro = self.provinces[indexPath.section - self.sectionTitles.count];
//            if (indexPath.row == 0)
//            {
//                item = pro; //整个省
//            }
//            else
//            {
//                item = pro.cities[indexPath.row - 1]; //市
//            }
//            break;
//        }
//    }
//    return item;
//}
//
//- (void)download:(MAOfflineItem *)item
//{
//    if (item == nil || item.itemStatus == MAOfflineItemStatusInstalled)
//    {
//        return;
//    }
//    
//    NSLog(@"download :%@", item.name);
//    
//    [[MAOfflineMap sharedOfflineMap] downloadItem:item shouldContinueWhenAppEntersBackground:YES downloadBlock:^(MAOfflineMapDownloadStatus downloadStatus, id info) {
//        
//        /* Manipulations to your application’s user interface must occur on the main thread. */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (downloadStatus == MAOfflineMapDownloadStatusWaiting)
//            {
//                NSLog(@"状态为: %@", @"等待下载");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusStart)
//            {
//                NSLog(@"状态为: %@", @"开始下载");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusProgress)
//            {
//                NSLog(@"状态为: %@", @"正在下载");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusCancelled) {
//                NSLog(@"状态为: %@", @"取消下载");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusCompleted) {
//                NSLog(@"状态为: %@", @"下载完成");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusUnzip) {
//                NSLog(@"状态为: %@", @"下载完成，正在解压缩");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusError) {
//                NSLog(@"状态为: %@", @"下载错误");
//            }
//            else if(downloadStatus == MAOfflineMapDownloadStatusFinished) {
//                NSLog(@"状态为: %@", @"全部完成");
//                [_mapView reloadMap];              //激活离线地图
//            }
//        });
//    }];
//}

- (void)pause:(MAOfflineItem *)item
{
    NSLog(@"pause :%@", item.name);
    
    [[MAOfflineMap sharedOfflineMap] pauseItem:item];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}


//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
