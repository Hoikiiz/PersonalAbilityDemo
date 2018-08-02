//
//  KeyValueView.m
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "KeyValueView.h"
#import "TreatmentInfoStore.h"

@implementation KeyValueView

#pragma mark - Lazy Initialized

- (UILabel *)keyLabel {
    if (_keyLabel == nil) {
        UILabel *label = [UILabel new];
        label.font = [[ResConfigLoader sharedInstance] Font:@"FONT_13"];
        label.textColor = [[ResConfigLoader sharedInstance] Color:@"COLOR_686868"];
        [self addSubview:label];
        _keyLabel = label;
    }
    return _keyLabel;
}

- (UILabel *)valueLabel {
    if (_valueLabel == nil) {
        UILabel *label = [UILabel new];
        label.font = [[ResConfigLoader sharedInstance] Font:@"FONT_13"];
        label.textColor = [[ResConfigLoader sharedInstance] Color:@"COLOR_252525"];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentRight;
        _valueLabel = label;
    }
    return _valueLabel;
}

#pragma mark - Layouts

- (void)layoutSubviews {
    [super layoutSubviews];
    self.keyLabel.frame = self.bounds;
    self.valueLabel.frame = self.bounds;
}

#pragma mark - Setter

- (void)setModel:(KeyValueModel *)model {
    _model = model;
    self.keyLabel.text = model.key;
    self.valueLabel.text = model.value;
}

@end
