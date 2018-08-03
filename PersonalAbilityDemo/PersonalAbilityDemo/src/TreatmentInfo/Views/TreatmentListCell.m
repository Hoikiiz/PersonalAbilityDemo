//
//  TreatmentListCell.m
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "TreatmentListCell.h"
#import "TreatmentInfoStore.h"

@interface TreatmentListCell()

@property (weak, nonatomic) UIButton *iconButton;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *infoImageView;

@end

@implementation TreatmentListCell

#pragma mark - Lazy Initialized

- (UIButton *)iconButton
{
    if(_iconButton == nil)
    {
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
        iconButton.adjustsImageWhenHighlighted = false;
        [self addSubview:iconButton];
        _iconButton = iconButton;
    }
    return _iconButton;
}

- (UILabel *)nameLabel
{
    if(_nameLabel == nil)
    {
        UILabel *nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        nameLabel.font = [[ResConfigLoader sharedInstance] Font:@"FONT_BOLD_16"];
        nameLabel.textColor = [[ResConfigLoader sharedInstance] Color:@"COLOR_252525"];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (UIImageView *)infoImageView
{
    if(_infoImageView == nil)
    {
        UIImageView *infoImageView = [UIImageView new];
        [self addSubview:infoImageView];
        _infoImageView = infoImageView;
    }
    return _infoImageView;
}


#pragma mark - Layouts



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconButton.frame = CGRectMake(kTreatmentListCellMargin, kTreatmentListCellMargin, kTreatmentListCellIconWidth, kTreatmentListCellIconWidth);
    CGFloat nameX = self.iconButton.right + kTreatmentListCellSpacine;
    self.nameLabel.frame = CGRectMake(nameX, self.iconButton.top, self.width - nameX - kTreatmentListCellMargin, self.iconButton.height);
    CGFloat infoY = self.nameLabel.bottom + kTreatmentListCellSpacine;
    self.infoImageView.frame = CGRectMake(self.nameLabel.left, infoY, self.nameLabel.width, self.height - infoY - kTreatmentListCellMargin);
}

#pragma mark - Actions

- (void)setModel:(TreatmentInfoModel *)model {
    _model = model;
    [self.iconButton setImage:model.__iconImage__ forState:UIControlStateNormal];
    self.nameLabel.text = model.name;
    self.infoImageView.image = model.__infoImage__;
}

- (void)iconButtonClick {
    if ([self.actionDelegate respondsToSelector:@selector(onAction:)]) {
        [self.actionDelegate onAction:@{
                                        kCellDelegateActionSenderKey: self,
                                        kCellDelegateActionActionKey: @"iconClick"
                                        }];
    }
}

@end
