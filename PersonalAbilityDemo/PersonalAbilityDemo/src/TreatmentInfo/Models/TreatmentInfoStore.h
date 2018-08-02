//
//  TreatmentInfoStore.h
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "HObject.h"

#pragma mark - KeyValueModel
#pragma mark -

@interface KeyValueModel : HModelObject

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *value;

@end

#pragma mark - TreatmentInfoModel
#pragma mark -

@interface TreatmentInfoModel : HModelObject

@property (assign, nonatomic) NSInteger id;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray<KeyValueModel *> *infos;
@property (assign, nonatomic) CGFloat __cellHeight__;
@property (strong, nonatomic) UIImage *__infoImage__;
@property (strong, nonatomic) UIImage *__iconImage__;

@end

#pragma mark - TreatmentInfoStore
#pragma mark -

typedef NS_ENUM(NSInteger, TreatmentInfoStoreChangeBehavior) {
    TreatmentInfoStoreChangeBehaviorReset,
    TreatmentInfoStoreChangeBehaviorAppend
};

static NSString *__TreatmentInfoStoreDidChangeNotiName = @"__TreatmentInfoStoreDidChangeNotiName";

typedef void (^NetSuccessCB)(NSURLSessionDataTask *task);
typedef void (^NetFailureCB)(NSURLSessionDataTask *task, NSError *error);

@interface TreatmentInfoStore : HObject

+ (instancetype)defaultStore;
- (NSArray<TreatmentInfoModel *> *)allItems;
- (void)resetItems:(NSArray<TreatmentInfoModel *> *)items;
- (void)appendItems:(NSArray<TreatmentInfoModel *> *)items;
- (void)reloadData:(NetSuccessCB)success fail:(NetFailureCB)fail;

@end
