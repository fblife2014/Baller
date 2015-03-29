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

#import "Baller_MessageViewCell.h"
#import "Baller_MessageTop.h"

#import "RCIM.h"
#import "Baller_MessageListInfo.h"

@interface Baller_MessageViewController ()<RCIMUserInfoFetcherDelegagte,UITableViewDataSource,RCIMUserInfoFetcherDelegagte>
{
    Baller_MessageListInfo * chosedMessageInfo;
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
}

- (void)headerRereshing{
    [super headerRereshing];
    self.page = 1;
    [self getMessageLists];
}

- (void)footerRereshing{
    [super footerRereshing];
    if (self.messageLists.count/10) {
        self.page = self.messageLists.count/10+1;
        [self getMessageLists];
    }
}

#pragma mark 网络请求
- (void)getMessageLists
{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_msg parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"page":@(self.page),@"per_page":@"10"} responseBlock:^(id result, NSError *error)
    {
        if (error) return ;
        
        if ([result integerForKey:@"errorcode"] == 0) {
            if (self.page == 1) {
                [self.messageLists removeAllObjects];
            }
            for (NSDictionary * messageInfoDic in [result valueForKey:@"data"]) {
                [self.messageLists addObject:[Baller_MessageListInfo shareWithServerDictionary:messageInfoDic]];
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
            NSIndexPath * deleteID = [NSIndexPath indexPathForRow:[self.messageLists indexOfObject:messageInfo]+1 inSection:0];
            [self.messageLists removeObject:messageInfo];
            [self.tableView deleteRowsAtIndexPaths:@[deleteID]withRowAnimation:UITableViewRowAnimationFade];
            
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
    if (indexPath.row) {
        Baller_MessageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Baller_MessageViewCellId forIndexPath:indexPath];
        cell.messageInfo = self.messageLists[indexPath.row-1];
        
        if (indexPath.row == 0) {
            cell.backgroundType = BaseCellBackgroundTypeUpWhite;
        }else if (indexPath.row == (self.messageLists.count)){
            cell.backgroundType = (indexPath.row%2)?BaseCellBackgroundTypeDownGrey:BaseCellBackgroundTypeDownWhite;
            
        }else{
            cell.backgroundType = indexPath.row%2?BaseCellBackgroundTypeMiddleGrey:BaseCellBackgroundTypeMiddleWhite;
            
        }
        
        return cell;
    }else{
        Baller_MessageTop * cell = [tableView dequeueReusableCellWithIdentifier:MessageListCellId forIndexPath:indexPath];
    
        cell.backgroundType = BaseCellBackgroundTypeUpWhite;
        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row?PersonInfoCell_Height:60;
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
        {
//            Baller_ActivityDetailViewController * activityDVC = [[Baller_ActivityDetailViewController alloc]init];
//            
//            [self.navigationController pushViewController:activityDVC animated:YES];
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
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格

    return result;
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
        if ([userId containsString:@"baller_"]) {
            if([u.userId isEqualToString:[userId substringFromIndex:7]])
            {
                user = u;
                break;
            }
        }else{
            if([u.userId isEqualToString:userId])
            {
                user = u;
                break;
            }
        }
        
    }
    return completion(user);
}

@end
