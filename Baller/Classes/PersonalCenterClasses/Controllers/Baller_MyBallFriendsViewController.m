//
//  Baller_MyBallFriendsViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBallFriendsViewController.h"
#import "Baller_PlayerCardViewController.h"

#import "Baller_BallFriendsTableViewCell.h"
#import "Baller_BallerFriendListModel.h"
@interface Baller_MyBallFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UISearchDisplayController * searchDisplayCtl;

    NSMutableArray * friends; //我的球友信息数组
    NSMutableArray * filterFriends;  //搜索结果数组
    
    //邀请的球友数组
     NSMutableArray *  invitedFriends;
    int currentPage;
}
@end

static NSString * const Baller_BallFriendsTableViewCellId = @"Baller_BallFriendsTableViewCell";

static NSString * const SearchFriendsTableViewCellId = @"SearchFriendsTableViewCellId";

@implementation Baller_MyBallFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [NSMutableArray arrayWithCapacity:1];
    filterFriends = [NSMutableArray arrayWithCapacity:1];
    [self setupSubViews];
    currentPage = 1;
    [self getNetData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*!
 *  @brief  设置子视图
 */
- (void)setupSubViews{
    
    self.navigationItem.rightBarButtonItem.customView = nil;
    
    switch (_ballFriendsListType) {
        case BallFriendsListTypeTable:
        {
            self.navigationItem.title = @"球友列表";
            UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithImage:@"tianjia" imageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15) target:self selection:@selector(addBallFriend)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
            break;
        case BallFriendsListTypeCollection:
            
            break;
        case BallFriendsListTypeChosing:
        {
            {
                self.navigationItem.title = @"邀请球友";
                UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithTitle:@"完成" titleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15.0) target:self selection:@selector(choseBallFriendsEnd)];
                self.navigationItem.rightBarButtonItem = rightItem;
            }
        }
            break;
    }

    
    [self.tableView registerNib:[UINib nibWithNibName:@"Baller_BallFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:Baller_BallFriendsTableViewCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewDataSource = [[TableViewDataSource alloc] initWithItems:friends cellIdentifier:Baller_BallFriendsTableViewCellId tableViewConfigureBlock:^(Baller_BallFriendsTableViewCell * cell, Baller_BallerFriendListModel * item)
    {
        if (self.ballFriendsListType == BallFriendsListTypeChosing)
        {
            cell.invitateStatus = YES;
            cell.chosing = NO;
        }
        cell.friendListModel  = item;

    }];
    
    self.tableView.dataSource = self.tableViewDataSource;
  
    
    BallFriendsSearchBar * searchBar = [[BallFriendsSearchBar alloc]initWithFrame:CGRectMake(8.0, 7.0, ScreenWidth, 41)];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    searchDisplayCtl = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    searchDisplayCtl.searchResultsDelegate = self;
    searchDisplayCtl.searchResultsDataSource = self;

}

- (void)getNetData
{
    currentPage = 1;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"authcode",@"get_friends",@"action",@"1",@"page",@"10",@"per_page", nil];
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_friend_list parameters:dic responseBlock:^(id result, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer noticeNoMoreData];
        [friends removeAllObjects];
        if(!error)
        {
           for(NSDictionary *dic in [result objectForKey:@"list"])
           {
               Baller_BallerFriendListModel *ballerFriendListModel = [[Baller_BallerFriendListModel alloc] initWithAttributes:dic];
               [friends addObject:ballerFriendListModel];
           }
            [self.tableView reloadData];
        }
    }];
}
- (void)getAddNetData
{
    currentPage++;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"authcode",@"get_friends",@"action",[NSString stringWithFormat:@"%d",currentPage],@"page",@"10",@"per_page", nil];
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_friend_list parameters:dic responseBlock:^(id result, NSError *error) {
        [self.tableView.header endRefreshing];
        if(!error)
        {
            NSArray *array = [result objectForKey:@"list"];
            if(array.count != 10)
            {
                [self.tableView.footer noticeNoMoreData];
            }
            for(NSDictionary *dic in [result objectForKey:@"list"])
            {
                Baller_BallerFriendListModel *ballerFriendListModel = [[Baller_BallerFriendListModel alloc] initWithAttributes:dic];
                [friends addObject:ballerFriendListModel];
            }
            [self.tableView reloadData];
        }
    }];
}
#pragma mark 下拉上拉
- (void)headerRereshing
{
    [self getNetData];
}

- (void)footerRereshing
{
    [self getAddNetData];
}

#pragma mark 按钮方法
/*!
 *  @brief  添加球友方法
 */
- (void)addBallFriend{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"authcode",@"at_friend",@"action",@"",@"friend_uid",nil];
    [AFNHttpRequestOPManager getWithSubUrl:Baller_my_attention parameters:dic responseBlock:^(id result, NSError *error) {
        if(!error)
        {
            
        }
        else
        {
            
        }
    }];
}

/*!
 *  @brief  结束邀请球友
 */
- (void)choseBallFriendsEnd{
    
    self.myBallFriendsEndChoseBallFriendsBlock(invitedFriends);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@", searchDisplayCtl.searchBar.text];
    [filterFriends removeAllObjects];
    for(Baller_BallerFriendListModel * model in friends)
    {
        if([model.friend_user_name containsString:searchDisplayCtl.searchBar.text])
        {
            [filterFriends addObject:model];
        }
    }
    return filterFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Baller_BallFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SearchFriendsTableViewCellId];
    
    if(!cell)
       {
           cell = [[Baller_BallFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchFriendsTableViewCellId];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
    cell.friendListModel = [filterFriends objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view data delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        Baller_BallerFriendListModel * ballFriendModel = friends[indexPath.row];
        if (self.ballFriendsListType == BallFriendsListTypeChosing) {
            Baller_BallFriendsTableViewCell * cell = (Baller_BallFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.chosing = !cell.chosing;
        }else{
            Baller_PlayerCardViewController * playCardVC = [[Baller_PlayerCardViewController alloc]init];
            playCardVC.friendModel = ballFriendModel;
            playCardVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
            [self.navigationController pushViewController:playCardVC animated:YES];
        }
        
    }else{
        Baller_BallerFriendListModel * ballFriendModel = filterFriends[indexPath.row];
        Baller_PlayerCardViewController * playCardVC = [[Baller_PlayerCardViewController alloc]init];
        playCardVC.friendModel = ballFriendModel;
        playCardVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
        [self.navigationController pushViewController:playCardVC animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    return YES;
}

@end



@implementation BallFriendsSearchBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"搜索";
        [self setBackgroundColor:BALLER_CORLOR_CELL];
        self.showsScopeBar = YES;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        UITextField * searchTF = (UITextField *)[self.subviews[0] subviews][1];
        searchTF.layer.cornerRadius = 5.0;
        searchTF.layer.borderColor = BALLER_CORLOR_b2b2b2.CGColor;
        searchTF.layer.borderWidth = 0.5;
        searchTF.backgroundColor = [UIColor whiteColor];
        [[self.subviews[0] subviews][0] removeFromSuperview];
    }
    return self;
}

@end

