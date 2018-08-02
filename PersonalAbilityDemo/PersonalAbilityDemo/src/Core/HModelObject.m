//
//  HModelObject.m
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "HModelObject.h"
#import <objc/runtime.h>


@implementation HModelObject


#pragma mark - Initializer

+ (instancetype)configWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]]) {
            if (dict.allKeys.count == 0) {
                return nil;
            }
            self.HModelObjectOriginalDict = dict;
            [self setValuesForKeysWithDictionary:dict];
        } else {
            NSLog(@"Initialize model %@ with none dictionary %@", NSStringFromClass([self class]), dict);
            return nil;
        }
    }
    return self;
}

+ (NSArray *)generateModels:(Class)modelClass withArray:(NSArray<NSDictionary *> *)dicts {
    if ([[modelClass alloc] isKindOfClass:[HModelObject class]]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            HModelObject *object = [modelClass alloc];
            object = [object initWithDict:dict];
            [temp addObject:object];
        }
        return [temp copy];
    } else {
        return nil;
    }
}

- (NSDictionary *)subModelUserInfo {
    return [NSDictionary dictionary];
}

#pragma mark - KVC

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *newKey;
    if ([[self originKeyMapping].allKeys containsObject:key]) {
        newKey = [[self originKeyMapping] valueForKey:key];
    }
    
    if (newKey.length) {
        [self setValue:value forKey:newKey];
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSDictionary *subInfo = [self subModelUserInfo];
    // 对指定的Key进行迭代
    if ([subInfo.allKeys containsObject:key]) {
        value = [self convertJSONObject:value];
        Class subClass = NSClassFromString(subInfo[key]);
        NSParameterAssert([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]);
        if ([value isKindOfClass:[NSDictionary class]]) {
            // single object
            HModelObject *object = [subClass alloc];
            [super setValue:[object initWithDict:value] forKey:key];
        } else if ([value isKindOfClass:[NSArray class]]) {
            // list objects
            [super setValue:[HModelObject generateModels:subClass withArray:value] forKey:key];
        }
    } else {
        //         type safe
        NSString *keyType = [self HModelObjectGetPropertyInfo:key];
        if ([keyType isEqualToString:@"i"] || [keyType isEqualToString:@"q"]) {
            value = @(INT_VALUE_FORKEY(self.HModelObjectOriginalDict, key));
        } else if ([keyType isEqualToString:@"Number"]) {
            value = @(Double_VALUE_FORKEY(self.HModelObjectOriginalDict, key));
        }
        else if ([keyType containsString:@"String"]) {
            value = STRING_VALUE_FORKEY(self.HModelObjectOriginalDict, key);
        } else if ([keyType isEqualToString:@"f"]) {
            value = @(FLOAT_VALUE_FORKEY(self.HModelObjectOriginalDict, key));
        } else if ([keyType isEqualToString:@"d"]) {
            value = @(Double_VALUE_FORKEY(self.HModelObjectOriginalDict, key));
        }
        else if ([keyType containsString:@"Dictionary"]) {
            value = DICT_VALUE_FORKEY(self.HModelObjectOriginalDict, key);
        } else if ([keyType isEqualToString:@"Array"]) {
            value = ARRAY_VALUE_FORKEY(self.HModelObjectOriginalDict, key);
        }
        
        // mutable change
        if ([keyType containsString:@"Mutable"]) {
            value = [value mutableCopy];
        }
        [super setValue:value forKey:key];
    }
}

- (id)convertJSONObject:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)value) dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    } else if ([value isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)value options:0 error:nil];
    } else {
        return value;
    }
}

#pragma mark - Runtime

- (NSString *)HModelObjectGetPropertyInfo:(NSString *)propertyString {
    NSDictionary *propertyInfo = HModelObjectPropertyInfo[NSStringFromClass([self class])];
    if (propertyInfo == nil) {
        [self initializePropertyInfo];
    }
    return propertyInfo[propertyString];
}

- (BOOL)initializePropertyInfo {
    if (HModelObjectPropertyInfo == nil) {
        HModelObjectPropertyInfo = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    
    unsigned int ivarCount;
    Class currentClass = [self class];
    while (![NSStringFromClass(currentClass) isEqualToString:@"HModelObject"]) {
        Ivar *ivars = class_copyIvarList(currentClass, &ivarCount);
        for (int i = 0; i < ivarCount; i ++) {
            Ivar ivar = ivars[i];
            NSString *typeCoding = [[[NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"@" withString:@""];
            NSString *name = [[NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"_" withString:@""];
            [tmp setObject:typeCoding forKey:name];
        }
        free(ivars);
        currentClass = currentClass.superclass;
    }
    [HModelObjectPropertyInfo setObject:[tmp copy] forKey:NSStringFromClass([self class])];
    return true;
}

@end
