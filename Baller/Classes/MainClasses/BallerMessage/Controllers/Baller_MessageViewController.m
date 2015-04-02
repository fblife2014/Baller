//
//  Baller_MessageViewController.m
//  Baller
//
//  Created by malong on 15/1/22.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MessageViewController.h"
#import "Baller_ChatListViewController.h"
#import "RCChatViewController.h"
#import "Baller_PlayerCardViewController.h"
#import "Baller_ActivityDetailViewController.h"
#import "Baller_MyBasketballTeamViewController.h"

#import "Baller_MessageViewCell.h"

#import "RCIM.h"
#import "Baller_MessageListInfo.h"

@interface Baller_MessageViewController ()<RCIMUserInfoFetcherDelegagte,UITableViewDataSource,RCIMUserInfoFetcherDelegagte>
{
    Baller_MessageListInfo * chosedMessageInfo;
    BOOL deleted; //删除过消息
}
@property (nonatomic,strong)NSMutableArray * messageLists;
@property (nonatomic,strong)NSMutableArray * chatUsers;
@end

static NSString * const Baller_MessageViewCellId = @"Baller_MessageViewCellId";
static NSString * const MessageListCellId = @"MessageListCellId";


@implementation Baller_MessageViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BallerLogoutThenLoginNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRCUserinfo];
    self.tableView.dataSource = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageData) name:BallerLogoutThenLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageData) name:BallerUpdateHeadImageNotification object:nil];
    [self getMessageLists];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadMessageData];
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
    [super headerRereshing];
    self.page = 1;
    [self getMessageLists];
}

- (void)footerRereshing{
    [super footerRereshing];
    if (0 == self.messageLists.count%10 && !deleted) {
        deleted = NO;
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
            for (NSDictionary * messageInfoDic in [result valueForKey:@"data"]) {
                [strongSelf.messageLists addObject:[Baller_MessageListInfo shareWithServerDictionary:messageInfoDic]];
            }
            if(strongSelf.messageLists.count != 0 && strongSelf.messageLists.count%10)
            {
                [strongSelf.tableView.footer noticeNoMoreData];
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
            deleted = YES;
            NSIndexPath * deleteID = [NSIndexPath indexPathForRow:[self.messageLists indexOfObject:messageInfo]+1 inSection:0];
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
    return self.messageLists.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Baller_MessageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Baller_MessageViewCellId forIndexPath:indexPath];
    cell.backgroundColor = indexPath.row%2?BALLER_CORLOR_CELL:[UIColor whiteColor];
    if (indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.messageInfo = self.messageLists[indexPath.row-1];
        
    }else{
        cell.messageTitleLabel.text = @"聊天列表";
        cell.messageDetailLabel.text = @"快去跟你的球友聊聊吧";
        cell.timeLabel.text = nil;
        cell.messageNumberLable.hidden = YES;
        cell.headImageView.image = [UIImage imageNamed:@"ballericon.jpg"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PersonInfoCell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        // 创建会话列表视图控制器。
        Baller_ChatListViewController *chatlistVc = [[Baller_ChatListViewController alloc]init];
        chatlistVc.portraitStyle = RCUserAvatarCycle;
        chatlistVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatlistVc animated:YES];
        return;
    }
    
    chosedMessageInfo = self.messageLists[indexPath.row-1];
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
            teamInfoVC.teamId = [[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"team_status"];
            teamInfoVC.ti_id = chosedMessageInfo.theme_id;
            teamInfoVC.teamType = Baller_TeamInvitingType;
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
        default:
            break;
    }
    
}

//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;
    }
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
        Baller_MessageListInfo * deleteInfo = self.messageLists[indexPath.row-1];
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

@end
