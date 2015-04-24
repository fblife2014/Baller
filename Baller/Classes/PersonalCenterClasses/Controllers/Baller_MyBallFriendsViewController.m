//
//  Baller_MyBallFriendsViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_MyBallFriendsViewController.h"
#import "Baller_PlayerCardViewController.h"
#import "Baller_SearchUserViewController.h"

#import "Baller_BallFriendsTableViewCell.h"
#import "Baller_BallerFriendListModel.h"
#import "Baller_BallTeamMemberInfo.h"

@interface Baller_MyBallFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    BallFriendsSearchBar* theSearchBar;
    NSMutableArray * friends; //我的球友信息数组
    NSMutableArray * filterFriends;  //搜索结果数组
    
    NSString * searchKeyWord;
}

@property (nonatomic)BOOL searchBarSearching;
@property (nonatomic,strong)TableViewDataSource * searchBarTableViewDataSource;

@property (nonatomic,strong)NSMutableArray * chosedFriends;//邀请的球友数组
@property (nonatomic,strong)NSMutableArray * searchResultFriends; //搜索到的球员数组
@property (nonatomic,strong)TableViewDataSource * resultTableDataSource; // 搜索返回结果的数据元
@property (nonatomic)NSInteger searchPage; //搜索状态页码

@end

static NSString * const Baller_BallFriendsTableViewCellId = @"Baller_BallFriendsTableViewCell";

static NSString * const SearchFriendsTableViewCellId = @"SearchFriendsTableViewCellId";

@implementation Baller_MyBallFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [NSMutableArray arrayWithCapacity:1];
    filterFriends = [NSMutableArray arrayWithCapacity:1];
    [self getNetData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSearchBarSearching:(BOOL)searchBarSearching{
    _searchBarSearching = searchBarSearching;
    if (_searchBarSearching) {
        self.tableView.dataSource = self.searchBarTableViewDataSource;
        
    }else{
        self.tableView.dataSource = self.tableViewDataSource;
    }
}

- (NSMutableArray *)chosedFriends
{
    if (!_chosedFriends) {
        _chosedFriends = [NSMutableArray new];
    }
    return _chosedFriends;
}

- (NSMutableArray *)searchResultFriends
{
    if (!_searchResultFriends) {
        _searchResultFriends = [NSMutableArray new];
    }
    return _searchResultFriends;
}

- (TableViewDataSource *)searchBarTableViewDataSource
{
    if (!_searchBarTableViewDataSource) {
        _searchBarTableViewDataSource = [[TableViewDataSource alloc]initWithItems:filterFriends cellIdentifier:Baller_BallFriendsTableViewCellId tableViewConfigureBlock:^(Baller_BallFriendsTableViewCell * cell, Baller_BallerFriendListModel * item) {
            cell.friendListModel  = item;
        }];
    }
    return _searchBarTableViewDataSource;
}


- (TableViewDataSource *)resultTableDataSource
{
    if (!_resultTableDataSource) {
        _resultTableDataSource = [[TableViewDataSource alloc]initWithItems:self.searchResultFriends cellIdentifier:Baller_BallFriendsTableViewCellId tableViewConfigureBlock:^(Baller_BallFriendsTableViewCell * cell, Baller_BallTeamMemberInfo * item) {
            cell.userInfoModel  = item;
        }];
    }
    return _resultTableDataSource;
}


- (void)setBallFriendsListType:(BallFriendsListType)ballFriendsListType{
    if (_ballFriendsListType == ballFriendsListType) {
        return;
    }
    _ballFriendsListType = ballFriendsListType;
    [self setupSubViews];

    self.navigationItem.rightBarButtonItem = nil;

    switch (_ballFriendsListType) {
        case BallFriendsListTypeTable:
        {
            self.tableView.tableHeaderView = theSearchBar;
            [self.naviTitleScrollView resetTitle:@"球友列表"];

            UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithImage:@"tianjia" imageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15) target:self selection:@selector(addBallFriend)];
            self.navigationItem.rightBarButtonItem = rightItem;
            self.tableView.dataSource = self.tableViewDataSource;
        }
            break;
        case BallFriendsListTypeCollection:
            
            break;
        case BallFriendsListTypeChosing:
        {
            self.tableView.tableHeaderView = theSearchBar;
            [self.naviTitleScrollView resetTitle:@"邀请球友"];

            UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithTitle:@"完成" titleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15.0) target:self selection:@selector(choseBallFriendsEnd)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
            break;
        case BallFriendsListTypeSearching:
        {
            self.tableView.tableHeaderView = nil;
            [self.naviTitleScrollView resetTitle:@"搜索结果"];

            UIBarButtonItem * rightItem = [ViewFactory getABarButtonItemWithTitle:@"列表" titleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -15.0) target:self selection:@selector(changeToTabel)];
            self.navigationItem.rightBarButtonItem = rightItem;
            self.tableView.dataSource = self.resultTableDataSource;
            
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

/*!
 *  @brief  设置子视图
 */
- (void)setupSubViews{
    
    if (self.tableViewDataSource) {
        return;
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
  
    theSearchBar = [[BallFriendsSearchBar alloc]initWithFrame:CGRectMake(8.0, 7.0, ScreenWidth, 41)];
    theSearchBar.delegate = self;
    theSearchBar.returnKeyType = UIReturnKeyDone;
    self.tableView.tableHeaderView = theSearchBar;

}

#pragma mark 网络请求
/*!
 *  @brief  获取好友列表
 */
- (void)getNetData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"authcode",@"get_friends",@"action",@"1",@"page",@"10",@"per_page", nil];
    [AFNHttpRequestOPManager getWithSubUrl:Baller_get_friend_list parameters:dic responseBlock:^(id result, NSError *error) {
        if(!error)
        {
            if (self.page == 1) {
                [friends removeAllObjects];
            }
            self.total_num = [result integerForKey:@"total_num"];
           for(NSDictionary *dic in [result objectForKey:@"list"])
           {
               Baller_BallerFriendListModel *ballerFriendListModel = [[Baller_BallerFriendListModel alloc] initWithAttributes:dic];
               [friends addObject:ballerFriendListModel];
           }
            if (friends.count >= self.total_num) {
                [self.tableView.footer noticeNoMoreData];
            }else{
                [self.tableView.footer setState:MJRefreshFooterStateIdle];
            }
            [self.tableView reloadData];
        }
    }];
}

/*!
 *  @brief  搜索用户
 */
- (void)searchUsers
{
    [AFNHttpRequestOPManager getWithSubUrl:Baller_search_user parameters:@{@"keywords":searchKeyWord,@"page":@(self.page),@"per_page":@(10)} responseBlock:^(id result, NSError *error) {
        if (!error) {
            if ([result intForKey:@"errorcode"] == 0) {
                if (self.searchPage == 1) {
                    [self.searchResultFriends removeAllObjects];
                }
                for (NSDictionary * memberDic in [result valueForKey:@"list"]) {
                    [self.searchResultFriends addObject:[Baller_BallTeamMemberInfo shareWithServerDictionary:memberDic]];
                }

                if (self.searchPage == 1 && self.searchResultFriends.count == 0) {
                    [Baller_HUDView bhud_showWithTitle:@"没有找到对应用户，换个关键字试试"];
                }
                [self.tableView reloadData];

            }
        }
    }];
}


#pragma mark 下拉上拉
- (void)headerRereshing
{
    [super headerRereshing];
    if (_ballFriendsListType == BallFriendsListTypeTable) {
        self.page = 1;
        [self getNetData];
    }else if (_ballFriendsListType == BallFriendsListTypeSearching){
        self.searchPage = 1;
        [self searchUsers];
    }

}

- (void)footerRereshing
{
    [super footerRereshing];
    if (_ballFriendsListType == BallFriendsListTypeTable) {
        if (friends.count<self.total_num) {
            self.page = friends.count/10+1;
            [self getNetData];
        }
    }else if (_ballFriendsListType == BallFriendsListTypeSearching){
        if (_searchResultFriends.count%10 == 0) {
            self.searchPage = friends.count/10+1;
            [self searchResultFriends];
        }
    }

}

#pragma mark 搜索回调方法
/*!
 *  @brief  搜索好友
 *
 *  @param keyWord 搜素关键词
 */
- (void)searchWithKeyWord:(NSString *)keyWord
{
    searchKeyWord = keyWord;
    [self.searchResultFriends removeAllObjects];
    self.ballFriendsListType = BallFriendsListTypeSearching;
    [self searchUsers];
}
#pragma mark 按钮方法
/*!
 *  @brief  添加球友方法
 */
- (void)addBallFriend{
    
    [theSearchBar resignFirstResponder];
    
    Baller_SearchUserViewController * searchUserVC = [[Baller_SearchUserViewController alloc]initWithNibName:@"Baller_SearchUserViewController" bundle:nil];
    searchUserVC.ballFriendVC = self;
    searchUserVC.view.backgroundColor = RGBAColor(50, 50, 50, 0.5);
    searchUserVC.view.frame = CGRectMake(0.0, -NavigationBarHeight, ScreenWidth, ScreenHeight);
    [self addChildViewController:searchUserVC];
    [self.view addSubview:searchUserVC.view];
}

/*!
 *  @brief  结束邀请球友
 */
- (void)choseBallFriendsEnd
{
    self.myBallFriendsEndChoseBallFriendsBlock([_chosedFriends copy]);
    [self.navigationController popViewControllerAnimated:YES];
}

/*!
 *  @brief  便会列表状态
 */
- (void)changeToTabel{
    self.ballFriendsListType = BallFriendsListTypeTable;
}



#pragma mark - Table view data delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [theSearchBar resignFirstResponder];
    
    switch (_ballFriendsListType) {
        case BallFriendsListTypeChosing:
        {
            Baller_BallFriendsTableViewCell * cell = (Baller_BallFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.chosing = !cell.chosing;
            if (cell.chosing) {
                if (![self.chosedFriends containsObject:cell.friendListModel]) {
                    [self.chosedFriends addObject:cell.friendListModel];
                }
                
            }else{
                [self.chosedFriends removeObject:cell.friendListModel];
            }
        }
            break;
        case BallFriendsListTypeTable:
            if (!_searchBarSearching) {
                
                Baller_BallerFriendListModel * ballFriendModel = friends[indexPath.row];
                Baller_PlayerCardViewController * playCardVC = [[Baller_PlayerCardViewController alloc]init];
                playCardVC.friendModel = ballFriendModel;
                playCardVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
                [self.navigationController pushViewController:playCardVC animated:YES];
                
            }else{
                Baller_BallerFriendListModel * ballFriendModel = filterFriends[indexPath.row];
                Baller_PlayerCardViewController * playCardVC = [[Baller_PlayerCardViewController alloc]init];
                playCardVC.friendModel = ballFriendModel;
                playCardVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;
                [self.navigationController pushViewController:playCardVC animated:YES];
            }
            break;
        case BallFriendsListTypeCollection:
            
            break;
        case BallFriendsListTypeSearching:
        {

            Baller_BallTeamMemberInfo * userModel = _searchResultFriends[indexPath.row];
            Baller_PlayerCardViewController * playCardVC = [[Baller_PlayerCardViewController alloc]init];

            if ([userModel.uid isEqualToString:[[USER_DEFAULT valueForKey:Baller_UserInfo] valueForKey:@"uid"]]) {
                playCardVC.ballerCardType = kBallerCardType_MyPlayerCard;

            }else{
                playCardVC.uid = userModel.uid;
                playCardVC.userName = userModel.user_name;
                playCardVC.photoUrl = userModel.photo;
                playCardVC.ballerCardType = kBallerCardType_OtherBallerPlayerCard;

            }
            [self.navigationController pushViewController:playCardVC animated:YES];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    theSearchBar.showsCancelButton = YES;

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchBarSearching = YES;
    [filterFriends removeAllObjects];

    for(Baller_BallerFriendListModel * model in friends)
    {
        DLog(@"model.friend_user_name = %@",model.friend_user_name);
        if([model.friend_user_name rangeOfString:searchText].length || [model.friend_uid rangeOfString:searchText].length)
        {
            [filterFriends addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = nil;

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchBarShouldEndEditing:searchBar];

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.searchBarSearching = NO;
    searchBar.text = nil;
    [self.tableView reloadData];
    theSearchBar.showsCancelButton = NO;
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
        self.tintColor = BALLER_CORLOR_NAVIGATIONBAR;
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

