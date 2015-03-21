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

@interface Baller_AnnotationMapViewController ()<MAMapViewDelegate>
{
    MAMapView * _mapView;
    Baller_CustomAnnotationView * annotationView;
}
@end

@implementation Baller_AnnotationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _autoAnnotion?@"自动定位球场位置":@"手动标注球场位置";
    
    UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithTitle:@"完成" titleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15) target:self selection:@selector(doneButtonAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self initMapView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    
    self.posionCallBack(@{@"latitude":[NSNumber numberWithDouble:annotationView.annotation.coordinate.latitude],@"longitude":[NSNumber numberWithDouble:annotationView.annotation.coordinate.longitude]});

    [self PopToLastViewController];
}

#pragma mark - Initialization

- (void)initMapView{
    
    [MAMapServices sharedServices].apiKey = Baller_AMAP_Key;
    
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.view.bounds))];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.delegate = self;
    [_mapView setZoomLevel:16.1 animated:YES];
    
    if (_autoAnnotion) {
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动

    }else{
        
    }
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x
                                       , 22.);
    [self.view addSubview:_mapView];
    
 
    
}
#pragma mark MAMapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        annotationView = (Baller_CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
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
