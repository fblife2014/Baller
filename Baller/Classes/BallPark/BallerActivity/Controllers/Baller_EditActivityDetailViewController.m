//
//  Baller_EditActivityDetailViewController.m
//  Baller
//
//  Created by malong on 15/1/31.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_EditActivityDetailViewController.h"
#import "Baller_BallParkHomepageViewController.h"

#import "Baller_InfoItemView.h"
#import "MGConferenceDatePicker.h"
#import "MGConferenceDatePickerDelegate.h"

@interface Baller_EditActivityDetailViewController ()<UITextFieldDelegate,MGConferenceDatePickerDelegate>
{
    UIView * bottomView;
    NSMutableArray * bottomViewTextFields; //底部视图的输入框集合
    UIViewController *pickerViewController;
}

@end

@implementation Baller_EditActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑活动详情";
    UIImage * image = nil;
    if ([USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]) {
        image = [UIImage imageWithData:[USER_DEFAULT valueForKey:Baller_UserInfo_HeadImageData]];
    }
    [self showBlurBackImageViewWithImage:image?image:[UIImage imageNamed:@"ballPark_default"] belowView:nil];
    [self setupSubViews];
    // Do any additional setup after loading the view from its nib.
}

/*!
 *  @brief  设置子视图
 */
- (void)setupSubViews{
    
    float space = NUMBER(22.0, 20.0, 15.0, 15.0);
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(space, 1.5*space, ScreenWidth-2*space, 5*PersonInfoCell_Height)];
    bottomView.backgroundColor = BALLER_CORLOR_CELL;
    bottomView.layer.cornerRadius = NUMBER(30.0, 25.0, 20.0, 20.0);
    bottomView.clipsToBounds = YES;
    [self.view addSubview:bottomView];
    
    NSArray * colors = @[BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_CELL,[UIColor whiteColor],BALLER_CORLOR_NAVIGATIONBAR];
    NSArray * titles = @[@"主题",@"备注",@"时间",@"人数上限",@"发起活动"];
    NSArray * placeHolders = @[@"输入主题",@"可选",@"必填",@"由你而定"];

    bottomViewTextFields = [NSMutableArray array];
    
    for (int i = 0; i < colors.count; i++) {
        if (i<4) {
            Baller_InfoItemView * itemView = [[Baller_InfoItemView alloc]initWithFrame:CGRectMake(0.0, i*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) title:titles[i] placeHolder:placeHolders[i]];
            itemView.backgroundColor = colors[i];
            itemView.infoTextField.font = SYSTEM_FONT_S(17.0);
            [bottomViewTextFields addObject:itemView.infoTextField];
            itemView.titleLabel.font = SYSTEM_FONT_S(17.0);
            itemView.infoTextField.delegate = self;
            itemView.tag= 100+i;
            itemView.infoTextField.tag = 1000+i;
            itemView.infoCanEdited = YES;
            if (i<3) {
                itemView.infoTextField.returnKeyType = UIReturnKeyNext;

            }else{
                itemView.infoTextField.returnKeyType = UIReturnKeyGo;
                itemView.infoTextField.keyboardType = UIKeyboardTypeNumberPad;

            }
            [bottomView addSubview:itemView];
            
        }else{
            UIButton * launchButton = [ViewFactory getAButtonWithFrame:CGRectMake(0.0, 4*PersonInfoCell_Height, ScreenWidth-2*space, PersonInfoCell_Height) nomalTitle:titles[4] hlTitle:titles[4] titleColor:[UIColor whiteColor] bgColor:BALLER_CORLOR_NAVIGATIONBAR nImage:nil hImage:nil action:@selector(launchButtonAction) target:self buttonTpye:UIButtonTypeCustom];
            [bottomView addSubview:launchButton];
        }
        
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_ballParkVC) {
        [_ballParkVC ballerParkHome_get_activities];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*!
 *  @brief  发起活动按钮方法
 */
- (void)launchButtonAction{
    [self.view endEditing:YES];
    
    for (int i = 0; i < bottomViewTextFields.count; i++) {
        UITextField * tf = (UITextField *)bottomViewTextFields[i];
        switch (i) {
            case 0:
                if (tf.text.length == 0) {
                    [Baller_HUDView bhud_showWithTitle:@"请输入活动标题"];
                    return;
                }
                break;
            case 2:
                if (tf.text.length == 0) {
                    [Baller_HUDView bhud_showWithTitle:@"请输入活动时间"];
                    return;
                }
                break;
            case 3:
                if (tf.text.length == 0) {
                    [Baller_HUDView bhud_showWithTitle:@"请设置人数上限"];
                    return;
                }
                break;
            default:
                break;
        }
    }
    UITextField * timetf = (UITextField *)bottomViewTextFields[2];

    [AFNHttpRequestOPManager postWithSubUrl:Baller_activity_create parameters:@{@"authcode":[USER_DEFAULT valueForKey:Baller_UserInfo_Authcode],@"court_id":_court_id,@"title":@"测试活动接口",@"info":@"",@"start_time":timetf.text,@"max_num":@"15"} responseBlock:^(id result, NSError *error) {
        if (error)return ;
        
        if (0 == [[result valueForKey:@"errorcode"] integerValue]) {
            [Baller_HUDView bhud_showWithTitle:@"成功发起活动！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)showDatePickerVC
{
    //New view controller
    if (!pickerViewController) {
        pickerViewController = [[UIViewController alloc] init];
        pickerViewController.view.backgroundColor = RGBAColor(0.0, 0.0, 0., 0.5);
        //Init the datePicker view and set self as delegate
        MGConferenceDatePicker *datePicker = [[MGConferenceDatePicker alloc] initWithFrame:self.view.bounds];
        [datePicker setDelegate:self];
        
        //OPTIONAL: Choose the background color
        [datePicker setBackgroundColor:BALLER_CORLOR_CELL];
        
        //Set the data picker as view of the new view controller
        [pickerViewController setView:datePicker];
        
    }

    //Present the view controller
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

#pragma mark MGConferenceDatePickerDelegate

-(void)conferenceDatePicker:(MGConferenceDatePicker *)datePicker saveDate:(NSDate *)date {
    [pickerViewController dismissViewControllerAnimated:YES completion:nil];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    UITextField * timetf = (UITextField *)bottomViewTextFields[2];
    timetf.text = [df stringFromDate:date];
}

#pragma mark uitextfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1002)
    {
        [self showDatePickerVC];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    Baller_InfoItemView * itemView = (Baller_InfoItemView *)[textField superview];
    
    if (itemView.tag == 103) {
        [self launchButtonAction];
    }else{
        Baller_InfoItemView * nextItemView = (Baller_InfoItemView *)[bottomView viewWithTag:(itemView.tag+1)];
        [nextItemView.infoTextField becomeFirstResponder];
    }
    return YES;
}

@end
