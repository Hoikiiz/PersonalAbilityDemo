//
//  ObjectForKey.m
//  hospital
//
//  Created by LiuBin on 4/8/15.
//  Copyright (c) 2015 LiuBin. All rights reserved.
//

#import "ObjectForKey.h"

@implementation NSDictionary (OBJECT_FOR_KEY)

- (BOOL)isNULL:(id)obj
{
    if(!obj)
    {
        return YES;
    }
    if([obj isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if([obj isKindOfClass:[NSString class]] && ([obj isEqualToString:@"<null>"] || [obj isEqualToString:@"NULL"]))
    {
        return YES;
    }
    return NO;
}

- (int)objectForKeySafe_Int:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self isNULL:v])
    {
        return 0;
    }
    else
    {
        return [v intValue];
    }
}

- (NSString *)objectForKeySafe_String:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self isNULL:v])
    {
        return nil;
    }
    else
    {
        return [NSString stringWithFormat:@"%@",v];
    }
}

- (float)objectForKeySafe_Float:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self isNULL:v])
    {
        return 0.0f;
    }
    else
    {
        return [v floatValue];
    }
}

- (double)objectForKeySafe_Double:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self isNULL:v])
    {
        return 0.0f;
    }
    else
    {
        return [v doubleValue];
    }
}

- (NSDictionary *)objectForKeySafe_Dic:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self isNULL:v] || ![v isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    else
    {
        return v;
    }
}

- (NSArray *)objectForKeySafe_Array:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self  isNULL:v] || ![v isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    else
    {
        return v;
    }
}

- (BOOL)objectForKeySafe_BOOL:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self isNULL:v])
    {
        return NO;
    }
    else
    {
        return [v boolValue];
    }
}

- (id)objectForKeySafe_Object:(id)aKey
{
    id v = [self objectForKey:aKey];
    if([self isNULL:v])
    {
        return nil;
    }
    else
    {
        return v;
    }
}

-(BOOL)hasObjectForkey:(id)key{
    return [[self allKeys] containsObject:key];
}

@end

@implementation NSMutableDictionary (SET_SAFE_OBJET_FOR_KEY)

- (void)setSafe_Object:(id)object forKey:(id)key
{
    if ([key isKindOfClass:[NSString class]])
    {
        if (object && [key length])
        {
            [self setObject:object forKey:key];
        }
    }
}

-(BOOL)hasObjectForkey:(id)key{
    return [[self allKeys] containsObject:key];
}

@end
