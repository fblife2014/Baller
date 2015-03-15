//
//  Baller_PickView.m
//  Baller
//
//  Created by malong on 15/2/25.
//  Copyright (c) 2015年 malong. All rights reserved.
//

#import "Baller_PickView.h"

@interface Baller_PickView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)UIPickerView * pickerView; //个人信息选择器视图

@end

@implementation Baller_PickView

- (id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = RGBAColor(44, 61, 81, 0.8);
        [self pickerView];
    }
    return self;
}

- (void)setFatherView:(UIView *)fatherView{
    if (fatherView == nil) {
        [self removeFromSuperview];
    }
    if (_fatherView == fatherView) {
        return;
    }
    _fatherView = fatherView;
    [_fatherView addSubview:self];
    
}

/*!
*  @brief  个人信息选择器视图，可选身高、体重、位置、性别等
*/
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.frame = CGRectMake(20.0, CGRectGetHeight(self.bounds)/2.0-120, CGRectGetWidth(self.bounds)-40.0, 240);
        _pickerView.layer.cornerRadius = BackLayer_CornerRadius;

        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}

- (void)reloadData{
    [self.pickerView reloadAllComponents];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.components.count;
}

#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return NavigationBarHeight;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.components[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    __WEAKOBJ(weakSelf, self);
    self.selectedCallBack(weakSelf.components[row]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.fatherView = nil;
}

@end
