//
//  Baller_SearchUserViewController.m
//  Baller
//
//  Created by malong on 15/3/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_SearchUserViewController.h"
#import "LTools.h"

@interface Baller_SearchUserViewController ()<UISearchBarDelegate>

@end

@implementation Baller_SearchUserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromSuperview)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

- (void)removeFromSuperview{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    if (_ballFriendVC && [LTools isValidateName:searchBar.text]) {
        [_ballFriendVC searchWithKeyWord:searchBar.text];
        [self removeFromSuperview];
    }
    
}

@end
