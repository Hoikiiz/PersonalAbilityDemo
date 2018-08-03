//
//  TreatmentInfoStore.m
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "TreatmentInfoStore.h"

#pragma mark - TreatmentInfoStore
#pragma mark -

@interface TreatmentInfoStore()

@property (strong, nonatomic) NSMutableArray<TreatmentInfoModel *> *items;

@end

@implementation TreatmentInfoStore

static TreatmentInfoStore *_treatmentInfoStore;

+ (instancetype)defaultStore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _treatmentInfoStore = [TreatmentInfoStore new];
    });
    return _treatmentInfoStore;
}

- (NSMutableArray<TreatmentInfoModel *> *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


- (NSArray<TreatmentInfoModel *> *)allItems {
    return self.items.copy;
}

#pragma mark - Data Change

- (void)resetItems:(NSArray<TreatmentInfoModel *> *)items {
    self.items = items.mutableCopy;
    NSDictionary *userInfo = @{
                               @"behavior": @(TreatmentInfoStoreChangeBehaviorReset),
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:__TreatmentInfoStoreDidChangeNotiName object:nil userInfo:userInfo];
}

- (void)appendItems:(NSArray<TreatmentInfoModel *> *)items {
    if (items.count > 0) {
        [self.items addObjectsFromArray:items];
    }
    NSMutableArray *indexes = [NSMutableArray array];
    for (TreatmentInfoModel *item in items) {
        [indexes addObject:@([self.items indexOfObject:item])];
    }
    NSDictionary *userInfo = @{
                               @"behavior": @(TreatmentInfoStoreChangeBehaviorAppend),
                               @"indexes": indexes.copy
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:__TreatmentInfoStoreDidChangeNotiName object:nil userInfo:userInfo];
}

- (void)reloadData:(NetSuccessCB)success fail:(NetFailureCB)fail {
//    fake network request
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"treatment_data" ofType:@"json"];
        NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:NULL];
        NSDictionary *dataDict = DICT_VALUE_FORKEY(JSONDict, @"data");
        NSArray *treatmentsDatas = ARRAY_VALUE_FORKEY(dataDict, @"treatments");
        [self resetItems:[TreatmentInfoModel generateModels:[TreatmentInfoModel class] withArray:treatmentsDatas]];
    });
    //    if fail call fail();
}

@end

#pragma mark - TreatmentInfoModel
#pragma mark -

@implementation TreatmentInfoModel

- (NSDictionary *)subModelUserInfo {
    return @{
             NSStringFromSelector(@selector(infos)): NSStringFromClass([KeyValueModel class])
             };
}

- (CGFloat)__cellHeight__ {
    if (___cellHeight__ == 0) {
        ___cellHeight__ = kTreatmentListCellMargin + kTreatmentListCellIconWidth + kTreatmentListCellSpacine + self.infos.count * kTreatmentListCellInfoLineHeight + kTreatmentListCellMargin;
    }
    return ___cellHeight__;
}

- (UIImage *)__iconImage__ {
    if (___iconImage__ == nil) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, kTreatmentListCellIconWidth, kTreatmentListCellIconWidth);
        label.text = self.icon;
        label.textColor = [[ResConfigLoader sharedInstance] Color:@"COLOR_ffffff"];
        label.font = [[ResConfigLoader sharedInstance] Font:@"FONT_18"];
        [label.layer addSublayer:[self gradientLayer]];
        label.textAlignment = NSTextAlignmentCenter;
        UIImage *labelImage = [label imageByRenderingView];
        
        ___iconImage__ = [self roundImage:labelImage];
    }
    return ___iconImage__;
}

- (UIImage *)__infoImage__ {
    if (___infoImage__ == nil) {
//        此处使用神奇数字计算，实际开发中会根据实际页面标注宏
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - kTreatmentListCellMargin * 2 - kTreatmentListCellIconWidth - kTreatmentListCellSpacine, self.infos.count * kTreatmentListCellInfoLineHeight)];
        [self.infos enumerateObjectsUsingBlock:^(KeyValueModel * _Nonnull model, NSUInteger i, BOOL * _Nonnull stop) {
            KeyValueView *kv = [[KeyValueView alloc] initWithFrame:CGRectMake(0, 7 + kTreatmentListCellInfoLineHeight * i, container.width, 13.0)];
            kv.model = model;
            [container addSubview:kv];
        }];
        ___infoImage__ = [container imageByRenderingView];
    }
    return ___infoImage__;
}

- (UIImage *)roundImage:(UIImage *)originImage {
    UIGraphicsBeginImageContextWithOptions(originImage.size, false, [UIScreen mainScreen].scale);
    UIBezierPath *path =[UIBezierPath bezierPathWithOvalInRect:CGRectMake( 0, 0, originImage.size.width, originImage.size.height)];
    [path addClip];
    [originImage drawAtPoint:CGPointZero];
    originImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return originImage;
}

- (CALayer *)gradientLayer {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.colors = @[
                     (__bridge id)[[ResConfigLoader sharedInstance] Color:@"COLOR_686868"].CGColor,
                     (__bridge id)[[ResConfigLoader sharedInstance] Color:@"COLOR_b2b2b2"].CGColor
                     ];
    layer.frame = CGRectMake(0, 0, kTreatmentListCellIconWidth, kTreatmentListCellIconWidth);
    layer.startPoint = CGPointMake(0.5, 0.0);
    layer.endPoint = CGPointMake(0.5, 1.0);
    return layer;
}

@end

#pragma mark - KeyValueModel
#pragma mark -

@implementation KeyValueModel
@end






























