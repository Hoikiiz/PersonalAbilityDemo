//
//  KeyValueView.h
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyValueModel;

@interface KeyValueView : UIView

@property (weak, nonatomic) UILabel *keyLabel;
@property (weak, nonatomic) UILabel *valueLabel;
@property (strong, nonatomic) KeyValueModel *model;

@end
