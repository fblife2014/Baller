//
//  Baller_AnnotationMapViewController.m
//  Baller
//
//  Created by malong on 15/2/27.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_AnnotationMapViewController.h"
#import "Baller_CustomAnnotationView.h"
#import <MAMapKit/MAMapKit.h>

#import "ReGeocodeAnnotation.h"

#import "AMapSearchAPI.h"

@interface Baller_AnnotationMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView * _mapView;
    Baller_CustomAnnotationView * annotationView;
    AMapSearchAPI *_search;
    
    

    //中心点坐标
    
    CLLocationCoordinate2D xcoordinate;
}

@property (nonatomic,strong)UIImageView * centerImage; //中心点
@property (nonatomic,strong)UILabel * centerLabel;  //中心店上面显示的label

@end

@implementation Baller_AnnotationMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _autoAnnotion?@"自动定位球场位置":@"手动标注球场位置";
    xcoordinate = [[AppDelegate sharedDelegate] currentLocation];
    
    UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithTitle:@"完成" titleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15) target:self selection:@selector(doneButtonAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_mapView) {
        [MAMapServices sharedServices].apiKey = Baller_AMAP_Key;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
        
        if (_autoAnnotion) {
            _mapView.scrollEnabled = NO;
            
        }else{
            [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
        }
        _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x
                                           , 22.);
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] initWithSearchKey:Baller_AMAP_Key Delegate:self];
        //构造 AMapReGeocodeSearchRequest 对象,location 为必选项,radius 为可选项
        
        self.centerLabel.center=CGPointMake(self.centerImage.center.x, self.centerImage.center.y-50);
        _mapView.centerCoordinate = xcoordinate;
 
    }

}

- (UILabel *)centerLabel
{
    if (!_centerLabel) {
        _centerLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _centerLabel.backgroundColor=BALLER_CORLOR_NAVIGATIONBAR;
        _centerLabel.textColor=[UIColor colorWithRed:220/255.f green:220/255.f blue:230/255.f alpha:1];
        _centerLabel.font=[UIFont systemFontOfSize:16];
        _centerLabel.layer.cornerRadius=3;
        _centerLabel.layer.masksToBounds=YES;
        _centerLabel.numberOfLines=3;
        _centerLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_centerLabel];

    }
    return _centerLabel;
}

- (UIImageView *)centerImage
{
    if (!_centerImage) {
        _centerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_big"]];
        _centerImage.center = CGPointMake(self.view.frame.size.width / 2.f, -10+self.view.frame.size.height / 2.f);
        [self.view addSubview:_centerImage];
    }
    return _centerImage;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self clearMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonAction{
    
    self.posionCallBack(@{@"latitude":@(xcoordinate.latitude),
                      @"longitude":@(xcoordinate.longitude) ,
                          @"address":self.centerLabel.text});
    
    [self PopToLastViewController];
}


#pragma mark--手动标注

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    return nil;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    
    xcoordinate = [mapView convertPoint:_centerImage.center
                   toCoordinateFromView:mapView];
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:xcoordinate.latitude longitude:xcoordinate.longitude ];
    regeoRequest.radius = 200; regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    
    if(response.regeocode != nil) {
        //处理搜索结果
        NSString *result =[NSString
                           stringWithFormat:@"ReGeocode: %@", response.regeocode];
        
    
        //        NSDictionary *_dic=;
        /*{address: 北京市昌平区回龙观地区, addressComponent: {province: 北京市, city: , district: 昌平区, township: 回龙观地区, neighborhood: , building: , citycode: 010, adcode: 110114, streetNumber: {street: , number: , location: {0.000000, 0.000000}, distance: 0, direction: }}, roads: [
         Road: {uid: 010K50F0480191617, name: 同成街, distance: 47, direction: 南, location: {40.071300, 116.322000}, citycode: , width: , type: }], roadinters: [], pois: []}*/
        NSLog(@"ReGeo: %@", result);
    }
    
    self.centerLabel.text=response.regeocode.formattedAddress;
    [self.centerLabel sizeToFit];
    self.centerLabel.center=CGPointMake(_centerImage.center.x, _centerImage.center.y-50);
    
}



#pragma mark--mapEND



#pragma mark - Utility

- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView removeOverlays:_mapView.overlays];
    
    _mapView.delegate = nil;
}

@end
