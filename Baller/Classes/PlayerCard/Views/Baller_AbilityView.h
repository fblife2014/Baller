//
//  Baller_AbilityView.h
//  Baller
//
//  Created by malong on 15/1/28.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Baller_AbilityView : UIView
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *rightTopView;
@property (weak, nonatomic) IBOutlet UIView *rightBottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *leftBottomView;
@property (weak, nonatomic) IBOutlet UIView *leftTopView;
@property (nonatomic,copy)NSString * evaluatedPersonUid;
@property (nonatomic,copy)NSString * evaluateType;
@property (nonatomic,copy)NSString * activity_id;
@property (nonatomic,strong)UIButton * evaluateButton;
@property (nonatomic)BOOL showEvaluateViews;
@property (nonatomic,strong)NSMutableDictionary * chosedAttributes;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *cancel;

@end
