//
//  BallerBallParkViewController.m
//  Baller
//
//  Created by malong on 14/11/23.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "BallerBallParkViewController.h"
#import "Baller_BallParkHomepageViewController.h"
#import "Baller_CreateBallParkViewController.h"

#import "Baller_BallParkListModel.h"

#import "Baller_BallparkCollectionViewCell.h"
#import "Baller_BallParkCollectionViewLayout.h"
#import "Baller_BallParkCollectionReusableView.h"

#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>

@interface BallerBallParkViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AMapSearchDelegate,MAMapViewDelegate>
{
    CLLocationCoordinate2D currentLocation;
    BOOL hasLocationed;
    MAMapView * _mapView;
}
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSMutableArray * ballParks; //认证通过了的球场
@property (nonatomic,strong)NSMutableArray * identifyingParks; //认证中的球场
@property (nonatomic) BallParkType ballParkType;
@end

static NSString * const Baller_BallparkCollectionViewCellId = @"Baller_BallparkCollectionViewCell";
static NSString * const BallParkCollectionHeaderViewId = @"BallParkCollectionHeaderViewId";


@implementation BallerBallParkViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BallerLogoutThenLoginNotification object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem * createBallParkItem = [ViewFactory getABarButtonItemWithTitle:@"创建球场" titleEdgeInsets:UIEdgeInsetsZero target:self selection:@selector(createBallPark)];
    createBallParkItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem = createBallParkItem;
    
    self.ballParks = [NSMutableArray array];
    self.identifyingParks = [NSMutableArray array];
    [self setupCollectionView];
    [self initMapView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:BallerLogoutThenLoginNotification object:nil];

}


- (void)reloadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getNearbyCourts];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建球场

- (void)createBallPark{
    Baller_CreateBallParkViewController * createBallParkVC = [[Baller_CreateBallParkViewController alloc]init];
    createBallParkVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createBallParkVC animated:YES];
}

#pragma mark 网络请求获取球场
- (void)getNearbyCourts{
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_nearby_courts parameters:@{@"latitude":@(currentLocation.latitude?:39.91549069),@"longitude":@(currentLocation.longitude?:116.38086026),@"type":self.ballParkType?@"authing":@"authed"} responseBlock:^(id result, NSError *error) {
        
        if (error) {
            
        }else if (0 == [[result valueForKey:@"errorcode"] intValue]){
            
            NSArray * courtList = (NSArray *)[result valueForKey:@"list"];
            NSMutableArray * courtsArray = nil;
            
            if (self.ballParkType == BallParkTypeIdentifyed) {
                
                if (1 == self.page)[self.ballParks removeAllObjects];
                courtsArray = self.ballParks;

            }else if (self.ballParkType == BallParkTypeIdentifing){
    
                if (1 == self.page)[self.identifyingParks removeAllObjects];
                courtsArray = self.identifyingParks;
            }
            
            for (NSDictionary * courtDic in courtList) {
                @autoreleasepool {
                    Baller_BallParkListModel * ballParkModel = [[Baller_BallParkListModel alloc]initWithAttributes:courtDic];
                    [courtsArray addObject:ballParkModel];
                }
            }
            
            MAIN_BLOCK(^{
                DLog(@"self.ballParks = %@",self.ballParks);
                DLog(@"self.identifyingParks = %@",self.identifyingParks);
                [self.collectionView reloadData];
            });
        }
    }];
}


#pragma mark - Initialization

- (void)initMapView{
    
    [MAMapServices sharedServices].apiKey = Baller_AMAP_Key;
    
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.view.bounds)-NUMBER(80.0, 70.0, 60.0, 60.0))];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
}


/*!
 *  @brief  设置列表
 */
- (void)setupCollectionView{
    Baller_BallParkCollectionViewLayout * layout = [[Baller_BallParkCollectionViewLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight-NavigationBarHeight-TabBarHeight) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    
    [self.collectionView registerClass:[Baller_BallparkCollectionViewCell class] forCellWithReuseIdentifier:Baller_BallparkCollectionViewCellId];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"Baller_BallParkCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BallParkCollectionHeaderViewId];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (updatingLocation) {
        currentLocation = userLocation.location.coordinate;
        AppDelegate * appDelegate = (AppDelegate *)[AppDelegate sharedDelegate];
        appDelegate.currentLocation = currentLocation;
    }
    if (currentLocation.latitude && !hasLocationed) {
        hasLocationed = YES;
        [self getNearbyCourts];
    }
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.ballParkType == BallParkTypeIdentifyed?self.ballParks.count:self.identifyingParks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Baller_BallparkCollectionViewCell * ballParkCell = [collectionView dequeueReusableCellWithReuseIdentifier:Baller_BallparkCollectionViewCellId forIndexPath:indexPath];
    [ballParkCell setBallPark:(self.ballParkType == BallParkTypeIdentifyed)?(self.ballParks[indexPath.row]):(self.identifyingParks[indexPath.row])];
    return ballParkCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    Baller_BallParkCollectionReusableView * headReusableView;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        headReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BallParkCollectionHeaderViewId forIndexPath:indexPath];
        __BLOCKOBJ(blockSelf, self);
        headReusableView.topButtonClickBlock = ^(BallParkType ballParkType){
            blockSelf.ballParkType = ballParkType;
            MAIN_BLOCK(^{
                if (ballParkType == BallParkTypeIdentifing) {
                    blockSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
                }else{
                    blockSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }
                [self.collectionView reloadData];
            });
            [self getNearbyCourts];
  
        };
        
    }else{
        return nil;
    }
    
    return headReusableView;
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_BallParkHomepageViewController * baller_BallParkHomepageViewController = [[Baller_BallParkHomepageViewController alloc] init];
    baller_BallParkHomepageViewController.isCloseMJRefresh = YES;
    baller_BallParkHomepageViewController.hidesBottomBarWhenPushed = YES;

//根据球场是否已经认证，选择跳转到不同的界面
    baller_BallParkHomepageViewController.ballParkModel = (self.ballParkType == BallParkTypeIdentifyed)?(self.ballParks[indexPath.row]):(self.identifyingParks[indexPath.row]);
    [self.navigationController pushViewController:baller_BallParkHomepageViewController animated:YES];
    
}


@end
