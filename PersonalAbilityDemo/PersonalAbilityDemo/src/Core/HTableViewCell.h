//
//  HTableViewCell.h
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSString *kCellDelegateActionSenderKey = @"sender";
static const NSString *kCellDelegateActionActionKey = @"action";

@protocol CellDelegateAction <NSObject>

@optional
- (void)onAction:(NSDictionary *)userData;

@end

@interface HTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CellDelegateAction>actionDelegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;
+ (NSString *)cellReuseIdentifier;

@end
