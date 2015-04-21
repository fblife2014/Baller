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
#import "LocationChange.h"

#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>

@interface Baller_BallParkMapViewController ()<MAMapViewDelegate,UIActionSheetDelegate>
{
    MAMapView * _mapView;
    CLLocationCoordinate2D centerCoordinate;
    UIButton * bottomPositionButton;
    UILabel * positionLabel;
}
@property (nonatomic,strong)UIAlertController * alertController;
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
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;

    if (_ballParkModel)
    {
        centerCoordinate.latitude = [_ballParkModel.latitude doubleValue];
        centerCoordinate.longitude = [_ballParkModel.longitude doubleValue];
    }
    [_mapView setZoomLevel:16.1 animated:YES];
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x
                                       , 22.);
    [self.view addSubview:_mapView];

    //定位按钮
    UIButton * dingweiButton = [ViewFactory getAButtonWithFrame:CGRectMake(CGRectGetWidth(_mapView.bounds)-60.0, CGRectGetHeight(_mapView.bounds)- 53.0-NavigationBarHeight, 40, 40) nomalTitle:nil hlTitle:nil titleColor:nil bgColor:CLEARCOLOR nImage:@"map_center" hImage:@"map_center" action:@selector(goBackToCenter) target:self buttonTpye:UIButtonTypeCustom];
    [_mapView addSubview:dingweiButton];
    
    //添加标注
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = centerCoordinate;
    pointAnnotation.title = _ballParkModel.court_name;
    pointAnnotation.subtitle = _ballParkModel.address;
    [_mapView addAnnotation:pointAnnotation];
    [self goBackToCenter];
    
}

/*!
 *  @brief  添加底部标注
 */
- (void)addBottomPositionButton{
    
    float buttonHeight = NUMBER(80.0, 70.0, 60.0, 60.0);
    
    bottomPositionButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0,ScreenHeight-buttonHeight-NavigationBarHeight, ScreenWidth, buttonHeight) nomalTitle:nil hlTitle:nil titleColor:BALLER_CORLOR_696969 bgColor:[UIColor whiteColor] nImage:nil hImage:nil action:@selector(showNaviAlertView) target:self buttonTpye:UIButtonTypeCustom];
    [self.view addSubview:bottomPositionButton];

    positionLabel = [ViewFactory addAlabelForAView:bottomPositionButton withText:_ballParkModel?_ballParkModel.address:@"" frame:CGRectMake(30.0,5.0,ScreenWidth-60.0,buttonHeight-10.0) font:SYSTEM_FONT_S(15.0) textColor:BALLER_CORLOR_696969];
    
    UIImageView * leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_small"]];
    leftImageView.frame = CGRectMake(10.0, buttonHeight/2.0-15.0, 20, 30.0);
    [bottomPositionButton addSubview:leftImageView];
    
    UIImageView * rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mycenter_jiantou"]];
    rightArrow.frame = CGRectMake(ScreenWidth-30, buttonHeight/2.0-10.5, 12.0, 21.0);
    [bottomPositionButton addSubview:rightArrow];
    
    
}


-(void)openGPSTips{
    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alet show];
}

#pragma mark  点击方法
/*!
 *  @brief  回到当前位置
 */
- (void)goBackToCenter{
    _mapView.centerCoordinate = centerCoordinate;
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
        annotationView.imageUrl = _ballParkModel.court_img;
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.image = [UIImage imageNamed:@"location_big"];
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    switch([error code]) {
        case kCLErrorDenied:
            [self openGPSTips];
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
}

#pragma mark 导航
- (UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController new];
        
    }
    return _alertController;
}

/*!
 *  @brief  弹出照片选择提示框
 */
- (void)showNaviAlertView{
    
    if (IOS8) {
        self.alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"导航到 %@",_ballParkModel.address] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"Google地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self goToGoogleMap];
            
        }]];
//        [self.alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self goToGaoDeMap];
//        }]];
//        
//        [self.alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self goTobaiduMap];
//        }]];
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
        
        [[[MLViewConrollerManager sharedVCMInstance] rootViewController] presentViewController:self.alertController animated:YES completion:nil];

    }else if (IOS7){
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[NSString stringWithFormat:@"导航到 %@",_ballParkModel.address]
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Google地图",nil];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

    }


}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self goToGoogleMap];
            break;
        default:
            break;
    }
}

- (void)goToGoogleMap
{
    if (!IOS7) {//ios7以下 调用goole网页地图
        NSString *urlString = [[NSString alloc]
                               initWithFormat:@"http://maps.google.com/maps?saddr=&daddr=%0.8f,%0.8f&dirfl=d",[self.ballParkModel.latitude doubleValue],[self.ballParkModel.longitude doubleValue]];
        
        NSURL *aURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:aURL];
    }else{//ios7 跳转apple map
        CLLocationCoordinate2D to;
        
        to.latitude = [self.ballParkModel.latitude doubleValue];
        to.longitude = [self.ballParkModel.longitude doubleValue];
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        
        toLocation.name = self.ballParkModel.court_name;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }

}

- (void)goToGaoDeMap{
    BOOL hasGaodeMap = NO;
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        hasGaodeMap = YES;
    }
    if (hasGaodeMap) {
        //backScheme=%
        NSString *gaodeUrl = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&@&poiname=%@&lat=%@&lon=%@&dev=1&style=2",@"Baller", @"终点", self.ballParkModel.latitude,
                                self.ballParkModel.longitude]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gaodeUrl]];
    }else{
        [Baller_HUDView bhud_showWithTitle:@"您尚未安装高德地图客户端!"];
    }
    
}

- (void)goTobaiduMap{
    
    BOOL hasBaiduMap = NO;
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        hasBaiduMap = YES;
    }
    
    if (hasBaiduMap) {
        CLLocationCoordinate2D currentLocation = [AppDelegate sharedDelegate].currentLocation;
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%@,%@|name:终点&mode=driving",currentLocation.latitude, currentLocation.longitude,self.ballParkModel.latitude,self.ballParkModel.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        
    }else{
        [Baller_HUDView bhud_showWithTitle:@"您尚未安装百度地图客户端!"];
    }

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
