//
//  Baller_BallParkMapViewController.m
//  Baller
//
//  Created by malong on 15/2/12.
//  Copyright (c) 2015年 malong. All rights reserved.
//
#import "Baller_BallParkMapViewController.h"
#import "Baller_BallParkListModel.h"
#import "Baller_CustomAnnotationView.h"
#import <MAMapKit/MAMapKit.h>

@interface Baller_BallParkMapViewController ()<MAMapViewDelegate>
{
    MAMapView * _mapView;
    CLLocationCoordinate2D centerCoordinate;
    UIButton * bottomPositionButton;
    UILabel * positionLabel;
}

@end

@implementation Baller_BallParkMapViewController


- (void)dealloc{
    [self clearMapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"球场位置";
    [self initMapView];
    [self addBottomPositionButton];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //添加标注
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = centerCoordinate;
    pointAnnotation.title = _ballParkModel.court_name;
    pointAnnotation.subtitle = _ballParkModel.address;
    [_mapView addAnnotation:pointAnnotation];
    [self goBackToCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)initMapView{
    
    [MAMapServices sharedServices].apiKey = Baller_AMAP_Key;
    
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.view.bounds)-NUMBER(80.0, 70.0, 60.0, 60.0))];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
//    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;

    if (_ballParkModel)
    {
        centerCoordinate.latitude = [_ballParkModel.latitude doubleValue];
        centerCoordinate.longitude = [_ballParkModel.longitude doubleValue];
    }
    [_mapView setZoomLevel:16.1 animated:YES];
//    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x
                                       , 22.);
    [self.view addSubview:_mapView];

    //定位按钮
    UIButton * dingweiButton = [ViewFactory getAButtonWithFrame:CGRectMake(CGRectGetWidth(_mapView.bounds)-60.0, CGRectGetHeight(_mapView.bounds)- 53.0-NavigationBarHeight, 40, 40) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:CLEARCOLOR nImage:@"map_center" hImage:@"map_center" action:@selector(goBackToCenter) target:self buttonTpye:UIButtonTypeCustom];
    [_mapView addSubview:dingweiButton];
    
}

/*!
 *  @brief  添加底部标注
 */
- (void)addBottomPositionButton{
    
    float buttonHeight = NUMBER(80.0, 70.0, 60.0, 60.0);
    
    bottomPositionButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0,ScreenHeight-buttonHeight-NavigationBarHeight, ScreenWidth, buttonHeight) nomalTitle:nil hlTitle:nil titleColor:BALLER_CORLOR_696969 bgColor:[UIColor whiteColor] nImage:nil hImage:nil action:@selector(goToDetailView) target:self buttonTpye:UIButtonTypeCustom];
    [self.view addSubview:bottomPositionButton];

    positionLabel = [ViewFactory addAlabelForAView:bottomPositionButton withText:_ballParkModel?_ballParkModel.address:@"" frame:CGRectMake(30.0,5.0,ScreenWidth-60.0,buttonHeight-10.0) font:SYSTEM_FONT_S(15.0) textColor:BALLER_CORLOR_696969];
    
    UIImageView * leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_small"]];
    leftImageView.frame = CGRectMake(10.0, buttonHeight/2.0-15.0, 20, 30.0);
    [bottomPositionButton addSubview:leftImageView];
    
    UIImageView * rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mycenter_jiantou"]];
    rightArrow.frame = CGRectMake(ScreenWidth-30, buttonHeight/2.0-10.5, 12.0, 21.0);
    [bottomPositionButton addSubview:rightArrow];
    
    
}

#pragma mark  点击方法
/*!
 *  @brief  回到当前位置
 */
- (void)goBackToCenter{
    _mapView.centerCoordinate = centerCoordinate;
}

/*!
 *  @brief  前往位置详情界面
 */
- (void)goToDetailView{
    
}


#pragma mark MAMapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        Baller_CustomAnnotationView *annotationView = (Baller_CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[Baller_CustomAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"location_big"];
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}


#pragma mark - Utility

- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView removeOverlays:_mapView.overlays];
    
    _mapView.delegate = nil;
}

@end
