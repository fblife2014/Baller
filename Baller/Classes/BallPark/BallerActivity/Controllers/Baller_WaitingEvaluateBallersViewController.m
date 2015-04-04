//
//  Baller_WaitingEvaluateBallersViewController.m
//  Baller
//
//  Created by malong on 15/4/4.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_WaitingEvaluateBallersViewController.h"
#import "Baller_PlayerCardViewController.h"

#import "Baller_WaitingEvaluateBallerInfo.h"

#import "Baller_BPAttentionPersonCollectionViewCell.h"
#import "Baller_BPAttentionPersonCellFlowLayout.h"
#import "Baller_AbilityView.h"

@interface Baller_WaitingEvaluateBallersViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate>
{
    UICollectionView * ballerCollectionView;

}
@property (nonatomic,strong)NSMutableArray * items;
@end

@implementation Baller_WaitingEvaluateBallersViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待评价球员列表";
    self.items = [NSMutableArray arrayWithCapacity:1];
    
    Baller_BPAttentionPersonCellFlowLayout * layout = [[Baller_BPAttentionPersonCellFlowLayout alloc] init];
    
    ballerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight-NavigationBarHeight) collectionViewLayout:layout];
    ballerCollectionView.showsHorizontalScrollIndicator = NO;
    
    ballerCollectionView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    
    [ballerCollectionView registerNib:[UINib nibWithNibName:@"Baller_BPAttentionPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Baller_BPAttentionPersonCollectionViewCellId"];
    ballerCollectionView.delegate = self;
    ballerCollectionView.dataSource = self;
    [self.view addSubview:ballerCollectionView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetItems:) name:@"EvaluateDone" object:nil];
    
    [self getBallerLists];

    // Do any additional setup after loading the view.
}

- (void)resetItems:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[Baller_AbilityView class]])
    {
        Baller_AbilityView * abilityView = (Baller_AbilityView *)notification.object;
        __BLOCKOBJ(blockItem, self.items);
        [self.items enumerateObjectsUsingBlock:^(Baller_WaitingEvaluateBallerInfo * obj, NSUInteger idx, BOOL *stop) {
            if ([obj.uid isEqualToString:abilityView.evaluatedPersonUid]) {
                [blockItem removeObject:obj];
                [ballerCollectionView reloadData];
                *stop = YES;
            }
        }];

    }
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取待评价球员列表
- (void)getBallerLists
{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_no_appraised_by_activity parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"activity_id":_activityID} responseBlock:^(id result, NSError *error) {
        if (!error) {
            if ([result intForKey:@"errorcode"] == 0)
            {
                [self.items removeAllObjects];
                NSArray * ballers = nil;
                
                if ([[result valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
                    ballers = [result valueForKey:@"list"];
                    
                }else if ([[result valueForKey:@"list"] isKindOfClass:[NSDictionary class]]){
                    ballers = [[result valueForKey:@"list"] allValues];
                }
                
                for (NSDictionary * ballerInfoDic in ballers) {
                    [self.items addObject:[Baller_WaitingEvaluateBallerInfo shareWithServerDictionary:ballerInfoDic]];

                }
                [ballerCollectionView reloadData];
                
            }else{
                [Baller_HUDView bhud_showWithTitle:[result valueForKey:@"msg"]];
            }
        }
    }];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Baller_BPAttentionPersonCollectionViewCell * bpAttentionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Baller_BPAttentionPersonCollectionViewCellId" forIndexPath:indexPath];
    bpAttentionCell.waitingEvaluateBallerInfo = _items[indexPath.row];
    return bpAttentionCell;
}



#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_PlayerCardViewController * personalVC = [[Baller_PlayerCardViewController alloc]init];
    Baller_WaitingEvaluateBallerInfo * userModel = _items[indexPath.row];
    personalVC.activity_id = userModel.activity_id;
    if ([userModel.uid isEqualToString:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"]]) {
        personalVC.ballerCardType = kBallerCardType_MyPlayerCard;
    }else{
        personalVC.userName = userModel.user_name;
        personalVC.photoUrl = userModel.photo;
        personalVC.uid = userModel.uid;
        personalVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
    }
    [self.navigationController pushViewController:personalVC animated:YES];
    
}

@end
