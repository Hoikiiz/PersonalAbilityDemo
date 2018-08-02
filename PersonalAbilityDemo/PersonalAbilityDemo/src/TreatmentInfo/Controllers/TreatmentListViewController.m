//
//  TreatmentListViewController.m
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "TreatmentListViewController.h"
#import "TreatmentInfoStore.h"
#import "TreatmentListCell.h"

@interface TreatmentListViewController ()<UITableViewDataSource, UITableViewDelegate, CellDelegateAction>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray<TreatmentInfoModel *> *dataSource;

@end

@implementation TreatmentListViewController

#pragma mark - Lazy Initialized

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style: UITableViewStylePlain];
        [self.view addSubview: tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.tableFooterView = [UIView new];
        tableView.backgroundColor = [UIColor clearColor];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[ResConfigLoader sharedInstance] Color:@"TABLEVIEW_BGColor"];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidChange:) name:__TreatmentInfoStoreDidChangeNotiName object:nil];
    [self loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Datas

- (IBAction)loadData {
    [[TreatmentInfoStore defaultStore] reloadData:^(NSURLSessionDataTask *task) {
        NSLog(@"success");
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"fail");
    }];
}

- (void)dataDidChange:(NSNotification *)noti {
    self.dataSource = [TreatmentInfoStore defaultStore].allItems;
    TreatmentInfoStoreChangeBehavior behavior = INT_VALUE_FORKEY(noti.userInfo, @"behavior");
    switch (behavior) {
        case TreatmentInfoStoreChangeBehaviorReset:
        {
            [self.tableView reloadData];
        }
            break;
        case TreatmentInfoStoreChangeBehaviorAppend:
        {
            NSArray *indexes = ARRAY_VALUE_FORKEY(noti.userInfo, @"indexes");
            NSMutableArray *indexPathes = [NSMutableArray arrayWithCapacity:indexes.count];
            for (NSNumber *index in indexes) {
                [indexPathes addObject:[NSIndexPath indexPathForRow:index.integerValue inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
    }
}

#pragma mark - Layouts

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    时间原因，暂不处理iPhone X等适配问题
    self.tableView.frame = CGRectMake(0, 64.0, self.view.width, self.view.height - 64.0 - 49.0);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TreatmentListCell *cell = [TreatmentListCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    cell.actionDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].__cellHeight__;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - Actions

- (void)onAction:(NSDictionary *)userData {
    UITableViewCell *cell = OBJECT_VALUE_FORKEY(userData, kCellDelegateActionSenderKey);
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSLog(@"%@", [NSString stringWithFormat:@"Click %@", self.dataSource[indexPath.row].name]);
    }
}


@end
