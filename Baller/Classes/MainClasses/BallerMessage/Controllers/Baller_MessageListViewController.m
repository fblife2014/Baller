//
//  Baller_MessageListViewController.m
//  Baller
//
//  Created by malong on 15/4/17.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MessageListViewController.h"
#import "Baller_ChatListViewController.h"
#import "RCChatViewController.h"
#import "Baller_PlayerCardViewController.h"
#import "Baller_ActivityDetailViewController.h"
#import "Baller_MyBasketballTeamViewController.h"
#import "Baller_ManageTeamRequestViewController.h"
#import "Baller_MessageViewCell.h"

#import "RCIM.h"
#import "Baller_MessageListInfo.h"

@interface Baller_MessageListViewController ()<RCIMUserInfoFetcherDelegagte,UITableViewDataSource>
{
    Baller_MessageListInfo * chosedMessageInfo;

}
@property (nonatomic,strong)NSMutableArray * messageLists;
@property (nonatomic,strong)NSMutableArray * chatUsers;
@property (nonatomic)NSInteger page;
@property (nonatomic)NSInteger total_num;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)Baller_ChatListViewController * chatListViewController;

@property (strong, nonatomic) IBOutlet UIButton *attentionButton;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
- (IBAction)attentionButtonAction:(id)sender;
- (IBAction)chatButtonAction:(id)sender;

@end
static NSString * const Baller_MessageViewCellId = @"Baller_MessageViewCellId";
static NSString * const MessageListCellId = @"MessageListCellId";

@implementation Baller_MessageListViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BallerLogoutThenLoginNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRCUserinfo];
    self.tableView.dataSource = self;
    [self.naviTitleScrollView resetTitle:@"提醒"];

    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageData) name:BallerLogoutThenLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageData) name:BallerUpdateHeadImageNotification object:nil];
    self.page = 1;
    [self reloadMessageData];
    
    // Do any additional setup after loading the view.
}

- (Baller_ChatListViewController *)chatListViewController
{
    if (!_chatListViewController) {
        _chatListViewController = [Baller_ChatListViewController new];
        _chatListViewController.portraitStyle = RCUserAvatarRectangle;
        _chatListViewController.view.frame =self.tableView.frame;
        [self addChildViewController:_chatListViewController];
        [self.view addSubview:_chatListViewController.view];
    }
    return _chatListViewController;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_messageLists.count == 0)[self reloadMessageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)messageLists
{
    if (!_messageLists) {
        _messageLists = [NSMutableArray new];
        
    }
    return _messageLists;
}


- (void)reloadMessageData
{
    [[AppDelegate sharedDelegate] getTokenFromRC];
    [[AppDelegate sharedDelegate]connectRC];
    [self getMessageLists];
}

- (void)headerRereshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
    });
    
    self.page = 1;
    [self getMessageLists];
    
}

- (void)footerRereshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.footer endRefreshing];
    });
    
    if (self.messageLists.count<self.total_num) {
        self.page = self.messageLists.count/10+1;
        [self getMessageLists];
        
        
    }
}

#pragma mark 网络请求
- (void)getMessageLists
{
    __WEAKOBJ(weakSelf, self);
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_msg parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"page":@(self.page),@"per_page":@"10"} responseBlock:^(id result, NSError *error)
     {
         __STRONGOBJ(strongSelf, weakSelf);
         if (error) return ;
         
         if ([result integerForKey:@"errorcode"] == 0) {
             if (strongSelf.page == 1) {
                 [strongSelf.messageLists removeAllObjects];
             }
             self.total_num = [result integerForKey:@"total_num"];
             for (NSDictionary * messageInfoDic in [result valueForKey:@"data"]) {
                 Baller_MessageListInfo * messageInfoModel = [Baller_MessageListInfo shareWithServerDictionary:messageInfoDic];
                 if (![strongSelf.messageLists containsObject:messageInfoModel]) {
                     [strongSelf.messageLists addObject:messageInfoModel];
                     
                 }
             }
             if(strongSelf.messageLists.count == self.total_num)
             {
                 [strongSelf.tableView.footer noticeNoMoreData];
             }else{
                 [strongSelf.tableView.footer setState:MJRefreshFooterStateIdle];
             }
             [self.tableView reloadData];
         }
     }];
}
/*!
 *  @brief  删除消息
 */
- (void)deleteMessage:(Baller_MessageListInfo *)messageInfo
{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_del_msg parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"msg_ids":messageInfo.msg_id} responseBlock:^(id result, NSError *error) {
        if (error) return ;
        if ([result integerForKey:@"errorcode"] == 0)
        {
            NSIndexPath * deleteID = [NSIndexPath indexPathForRow:[self.messageLists indexOfObject:messageInfo] inSection:0];
            [self.messageLists removeObject:messageInfo];
            
            [self.tableView deleteRowsAtIndexPaths:@[deleteID]withRowAnimation:UITableViewRowAnimationFade];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Baller_MessageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Baller_MessageViewCellId forIndexPath:indexPath];
    cell.backgroundColor = indexPath.row%2?BALLER_CORLOR_CELL:[UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.messageInfo = self.messageLists[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PersonInfoCell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    chosedMessageInfo = self.messageLists[indexPath.row];
    switch (chosedMessageInfo.type) {
        case 1:
        {
            RCChatViewController * rcChatVC = [[RCIM sharedRCIM]createPrivateChat:chosedMessageInfo.from_uid title:chosedMessageInfo.from_username completion:^{
            }];
            rcChatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rcChatVC animated:YES];
        }
            break;
        case 2:
        {
            Baller_PlayerCardViewController * playCardView = [[Baller_PlayerCardViewController alloc]init];
            playCardView.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
            playCardView.photoUrl = chosedMessageInfo.photo;
            playCardView.uid = chosedMessageInfo.from_uid;
            playCardView.hidesBottomBarWhenPushed = YES;
            
            playCardView.userName = chosedMessageInfo.from_username;
            [self.navigationController pushViewController:playCardView animated:YES];
        }
            break;
        case 3:
        case 4:
        {
            Baller_ActivityDetailViewController * activityDVC = [[Baller_ActivityDetailViewController alloc]init];
            activityDVC.activityID = chosedMessageInfo.theme_id;
            activityDVC.activity_CreaterID = chosedMessageInfo.from_uid;
            activityDVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activityDVC animated:YES];
        }
            break;
        case 5:
        {
            Baller_MyBasketballTeamViewController * teamInfoVC = [[Baller_MyBasketballTeamViewController alloc]init];
            teamInfoVC.isCloseMJRefresh = YES;
            NSDictionary * userinfo = [USER_DEFAULT valueForKey:Baller_UserInfo];
            if ([userinfo intForKey:@"team_id"] && [userinfo intForKey:@"team_status"]==1) {
                teamInfoVC.teamType = Baller_TeamJoinedType;
            }else{
                teamInfoVC.ti_id = chosedMessageInfo.theme_id;
                teamInfoVC.teamType = Baller_TeamInvitingType;
            }
            teamInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamInfoVC animated:YES];
        }
            break;
        case 6:
        case 7:
        {
            Baller_MyBasketballTeamViewController * teamInfoVC = [[Baller_MyBasketballTeamViewController alloc]init];
            teamInfoVC.isCloseMJRefresh = YES;
            teamInfoVC.teamType = Baller_TeamJoinedType;
            teamInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamInfoVC animated:YES];
        }
            
            break;
        case 8:
        {
            Baller_ManageTeamRequestViewController * manageTeamRequestVC = [[Baller_ManageTeamRequestViewController alloc]init];
            manageTeamRequestVC.dontNeedTitle = YES;
            manageTeamRequestVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
            manageTeamRequestVC.photoUrl = chosedMessageInfo.photo;
            manageTeamRequestVC.uid = chosedMessageInfo.from_uid;
            manageTeamRequestVC.tm_id = chosedMessageInfo.theme_id;
            manageTeamRequestVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:manageTeamRequestVC animated:YES];
        }
            break;
        case 9:
        {
            Baller_PlayerCardViewController * playCardView = [[Baller_PlayerCardViewController alloc]init];
            playCardView.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
            playCardView.photoUrl = chosedMessageInfo.photo;
            playCardView.uid = chosedMessageInfo.from_uid;
            playCardView.hidesBottomBarWhenPushed = YES;
            
            playCardView.userName = chosedMessageInfo.from_username;
            [self.navigationController pushViewController:playCardView animated:YES];
        }
            break;
        default:
            break;
    }
    
}

//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete)
    {
        Baller_MessageListInfo * deleteInfo = self.messageLists[indexPath.row];
        [self deleteMessage:deleteInfo];
    }
}

#pragma mark 融云

- (void)setRCUserinfo{
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
}

- (NSMutableArray *)chatUsers
{
    if (!_chatUsers) {
        _chatUsers = [NSMutableArray new];
        
        
        RCUserInfo * myUserInfo = [[RCUserInfo alloc]initWithUserId:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"] name:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"user_name"] portrait:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"photo"]];
        
        RCUserInfo * friendUserInfo = [[RCUserInfo alloc]initWithUserId:chosedMessageInfo.from_uid name:chosedMessageInfo.from_username portrait:chosedMessageInfo.photo];
        
        [_chatUsers addObject:myUserInfo];
        [_chatUsers addObject:friendUserInfo];
    }
    
    return _chatUsers;
}

#pragma mark RCIMUserInfoFetcherDelegagte

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    RCUserInfo *user  = nil;
    if([userId length] == 0)
        return completion(nil);
    for(RCUserInfo *u in self.chatUsers)
    {
        if([u.userId isEqualToString:userId])
        {
            user = u;
            break;
        }
    }
    return completion(user);
}

- (IBAction)attentionButtonAction:(id)sender {
    [self.naviTitleScrollView resetTitle:@"提醒"];
    [_attentionButton setTitleColor:UIColorFromRGB(0x1e8ad3) forState:UIControlStateNormal];
    [_chatButton setTitleColor:UIColorFromRGB(0x767676) forState:UIControlStateNormal];
    
    self.tableView.hidden = NO;
    self.chatListViewController.view.hidden = YES;
}

- (IBAction)chatButtonAction:(id)sender {
    [self.naviTitleScrollView resetTitle:@"聊天"];
    [_attentionButton setTitleColor:UIColorFromRGB(0x767676) forState:UIControlStateNormal];
    [_chatButton setTitleColor:UIColorFromRGB(0x1e8ad3) forState:UIControlStateNormal];
    
    self.tableView.hidden = YES;
    self.chatListViewController.view.hidden = NO;
}
@end
