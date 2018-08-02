//
//  HTableViewCell.m
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "HTableViewCell.h"

@implementation HTableViewCell

- (instancetype)initWithTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:[[self class] cellReuseIdentifier]];
    return [tableView dequeueReusableCellWithIdentifier:[[self class] cellReuseIdentifier]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [[self alloc] initWithTableView:tableView];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
