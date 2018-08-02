//
//  HModelObject.h
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "HObject.h"

static NSMutableDictionary *HModelObjectPropertyInfo;

@interface HModelObject : HObject

@property (copy, nonatomic) NSDictionary *HModelObjectOriginalDict;

/**
 自动生成模型时用于处理包含关系的mapping {@"key": @"ModelName"}
 
 @return 字典： {@"key": @"ModelName"}
 */
@property (copy, nonatomic) NSDictionary *subModelUserInfo;

/**
 用于Mapping自定义的key和实际下发的key
 
 @return 字典： @{@"backend_key": @"myKey"}
 */
@property (copy, nonatomic) NSDictionary *originKeyMapping;

+ (instancetype)configWithDict:(NSDictionary *)dict;

/**
 字典 =》 Model，根据字典键值对自动赋值，如果实现了 -originKeyMapping 方法则
 字典中的key会映射到 originKeyMapping 中绑定的key
 
 @param dict 赋值用的字典
 @return 如果传入的不是字典类型或者字典中没有数据则会返回nil
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSArray *)generateModels:(Class)modelClass withArray:(NSArray<NSDictionary *> *)dicts;

- (BOOL)initializePropertyInfo;

@end
