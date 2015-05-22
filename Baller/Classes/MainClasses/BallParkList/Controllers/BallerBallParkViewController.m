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

@interface BallerBallParkViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    CLLocationCoordinate2D currentLocation;
}
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSMutableArray * ballParks; //认证通过了的球场
@property (nonatomic,strong)NSMutableArray * identifyingParks; //认证中的球场
@property (nonatomic) BallParkType ballParkType;
@property (nonatomic) NSInteger identifyingPage; //认证中的列表状态页码
@property (nonatomic) NSInteger identifingTotalnum; //认证中的总条数
@end

static NSString * const Baller_BallparkCollectionViewCellId = @"Baller_BallparkCollectionViewCell";
static NSString * const BallParkCollectionHeaderViewId = @"BallParkCollectionHeaderViewId";


@implementation BallerBallParkViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.naviTitleScrollView resetTitle:@"球场"];
    
    self.identifyingPage = 1;
    UIBarButtonItem * createBallParkItem = [ViewFactory getABarButtonItemWithTitle:@"创建球场" titleEdgeInsets:UIEdgeInsetsZero target:self selection:@selector(createBallPark)];
    createBallParkItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem = createBallParkItem;
    
    if(![DataBaseManager isTableExist:@"Baller_BallParkListModel"])[DataBaseManager  createDataBaseWithDBModelName:@"Baller_BallParkListModel"];
    
    self.ballParks = [NSMutableArray array];
    self.identifyingParks = [NSMutableArray array];
    [self setupCollectionView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:BallerLogoutThenLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:BallerOpenLocationNotification object:nil];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)reloadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.identifyingPage = 1;
        self.page = 1;
        if (self.ballParkType == BallParkTypeIdentifyed)
        {
            if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
                [self getNearbyCourts];
            }else{
                [self getIdentifyedBallParkFromSQLTable];
            }
        }else{
            [self getNearbyCourts];
        }
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建球场

- (void)createBallPark{
    if (![self hasOpenUserLocation]) {
        return;
    }

    Baller_CreateBallParkViewController * createBallParkVC = [[Baller_CreateBallParkViewController alloc]init];
    createBallParkVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createBallParkVC animated:YES];
}

#pragma mark 网络请求获取球场
/*!
 *  @brief  判断用户是否打开定位
 */
- (BOOL)hasOpenUserLocation
{
    if (kCLAuthorizationStatusDenied == [CLLocationManager authorizationStatus])
    {
        NSString * alertTitle = @"定位服务已关闭";
        NSString * alertMessage = @"请到设置->隐私->定位服务中开启【Baller】定位服务，已便Baller能够准确获取您的位置信息";
        
        if (IOS8) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction * setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            [alertController addAction:cancel];
            [alertController addAction:setting];
            [self presentViewController:alertController animated:NO completion:nil];
            
        }else if (IOS7){
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
            
        }
        return NO;
    }
    return YES;
}


- (void)getNearbyCourts{
    if (![self hasOpenUserLocation]) {
        return;
    }
    __WEAKOBJ(weakSelf, self);
    AppDelegate * appDelegate = (AppDelegate *)[AppDelegate sharedDelegate];
    currentLocation = appDelegate.currentLocation;
    
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_nearby_courts parameters:@{@"latitude":@(currentLocation.latitude),@"longitude":@(currentLocation.longitude),@"type":self.ballParkType?@"authing":@"authed",@"per_page":@"10",@"page":self.ballParkType?@(self.identifyingPage):@(self.page)} responseBlock:^(id result, NSError *error) {
        __STRONGOBJ(strongSelf, weakSelf);
        if (error) {
            
        }else if (0 == [[result valueForKey:@"errorcode"] intValue]){
            
            NSArray * courtList = (NSArray *)[result valueForKey:@"list"];
            NSMutableArray * courtsArray = nil;
            NSInteger totalnum = [result integerForKey:@"total_num"];
            if (strongSelf.ballParkType == BallParkTypeIdentifyed) {
                strongSelf.total_num = totalnum;
                if (1 == strongSelf.page)[strongSelf.ballParks removeAllObjects];
                courtsArray = strongSelf.ballParks;

            }else if (strongSelf.ballParkType == BallParkTypeIdentifing){
                strongSelf.identifingTotalnum = totalnum;
                if (1 == strongSelf.identifyingPage)[strongSelf.identifyingParks removeAllObjects];
                courtsArray = strongSelf.identifyingParks;
            }
            
            for (NSDictionary * courtDic in courtList) {
                @autoreleasepool {
                    Baller_BallParkListModel * ballParkModel = [[Baller_BallParkListModel alloc]initWithAttributes:courtDic];
                    [courtsArray addObject:ballParkModel];
                }
            }
            
            if (strongSelf.ballParkType == BallParkTypeIdentifyed) {
                if (strongSelf.ballParks.count<strongSelf.total_num)
                {
                    if (strongSelf.collectionView.footer.state == MJRefreshFooterStateNoMoreData) {
                        [strongSelf.collectionView.footer setState:MJRefreshFooterStateIdle];
                    }
                
                }else{
                    [strongSelf.collectionView.footer noticeNoMoreData];

                }
            }else{

                if (strongSelf.identifyingParks.count<strongSelf.identifingTotalnum)
                {
                    if (strongSelf.collectionView.footer.state == MJRefreshFooterStateNoMoreData) {
                        [strongSelf.collectionView.footer setState:MJRefreshFooterStateIdle];
                    }
                
                }else{
                    [strongSelf.collectionView.footer noticeNoMoreData];
                }
            }
            MAIN_BLOCK(^{
                [strongSelf.collectionView reloadData];
            });
            if (strongSelf.ballParkType == BallParkTypeIdentifyed)
            {
                dispatch_queue_t serailQueue = dispatch_queue_create([@"com.serailQueue.BallerBallParkViewController" UTF8String], NULL);
                
                dispatch_async(serailQueue, ^{
                    for (NSInteger i = MAX(0, strongSelf.ballParks.count-10); i<strongSelf.ballParks.count; i++)
                    {
                        @autoreleasepool {
                            Baller_BallParkListModel * ballParkModel = strongSelf.ballParks[i];
                            if (![DataBaseManager isModelExist:@"Baller_BallParkListModel" keyName:@"court_id" keyValue:@(ballParkModel.court_id)])
                            {
                                [DataBaseManager insertDataWithMDBModel:ballParkModel];
                            }
                        }
                        
                    }
                }); 
            }

            
        }
    }];
}

/*!
 *  @brief  从数据库读取数据
 */
- (void)getIdentifyedBallParkFromSQLTable
{
    self.total_num = [DataBaseManager findTheTableItemNumberWithModelName:@"Baller_BallParkListModel" keyName:nil keyValue:nil];
    if (self.ballParks.count < self.total_num)
    {
        [self.ballParks addObjectsFromArray: [DataBaseManager findTheTableItemWithModelName:@"Baller_BallParkListModel" sql:$str(@"SELECT * FROM Baller_BallParkListModel limit %lu,%lu",(unsigned long)self.ballParks.count,MIN(10, self.total_num-self.ballParks.count))]];
        
    }
    [self.collectionView reloadData];
    if (self.ballParks.count == self.total_num) {
        [self.collectionView.footer noticeNoMoreData];
    }
}

#pragma mark 上拉下拉
- (void)headerRereshing{
    [super headerRereshing];
    if (0 == self.ballParkType) {
        self.page = 1;
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            [self getNearbyCourts];
        }else{
            [self.ballParks removeAllObjects];
            [self getIdentifyedBallParkFromSQLTable];
        }
    }else{
        self.identifyingPage = 1;
        [self getNearbyCourts];

    }

}

- (void)footerRereshing{
    [super footerRereshing];
    
    if (0 == self.ballParkType) {
        if (self.ballParks.count<self.total_num) {
            self.page = self.ballParks.count/10+1;
            if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
                [self getNearbyCourts];
            }else{
                [self getIdentifyedBallParkFromSQLTable];
            }
        }
    }else{
        if (self.identifyingParks.count<self.identifingTotalnum) {
            self.identifyingPage = self.identifyingParks.count/10+1;
            
            [self getNearbyCourts];

        }
    }
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
    [self setupMJRefreshScrollView:self.collectionView];
    [self.view addSubview:self.collectionView];
}




#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
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
        __WEAKOBJ(weakSelf, self);
        headReusableView.topButtonClickBlock = ^(BallParkType ballParkType){
            __STRONGOBJ(strongSelf, weakSelf);
            blockSelf.ballParkType = ballParkType;
            MAIN_BLOCK(^{
                if (ballParkType == BallParkTypeIdentifing) {
                    blockSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
                    [strongSelf.collectionView reloadData];
                    if (strongSelf.identifyingParks.count == 0) {
                        [strongSelf getNearbyCourts];
                    }else if (strongSelf.identifyingParks.count < strongSelf.identifingTotalnum){
                        [strongSelf.collectionView.footer setState:MJRefreshFooterStateIdle];

                    }else{
                        [strongSelf.collectionView.footer noticeNoMoreData];

                    }
                }else{
                    blockSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
                    [strongSelf.collectionView reloadData];

                    if (strongSelf.ballParks.count == 0) {
                        [strongSelf getNearbyCourts];
                        
                    }else if (strongSelf.ballParks.count < strongSelf.total_num){
                        [strongSelf.collectionView.footer setState:MJRefreshFooterStateIdle];
                        
                    }else{
                        [strongSelf.collectionView.footer noticeNoMoreData];
                        
                    }
                }
            });
  
        };
        
    }else{
        return nil;
    }
    
    return headReusableView;
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_BallParkHomepageViewController * baller_BallParkHomepageViewController = [[Baller_BallParkHomepageViewController alloc] init];
    baller_BallParkHomepageViewController.isCloseMJRefresh = self.ballParkType != BallParkTypeIdentifyed;
    baller_BallParkHomepageViewController.hidesBottomBarWhenPushed = YES;

//根据球场是否已经认证，选择跳转到不同的界面
    baller_BallParkHomepageViewController.ballParkModel = (self.ballParkType == BallParkTypeIdentifyed)?(self.ballParks[indexPath.row]):(self.identifyingParks[indexPath.row]);
    [self.navigationController pushViewController:baller_BallParkHomepageViewController animated:YES];
    
}


@end
