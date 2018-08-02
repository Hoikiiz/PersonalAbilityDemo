//
//  ObjectForKey.h
//  hospital
//
//  Created by LiuBin on 4/8/15.
//  Copyright (c) 2015 LiuBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (OBJECT_FOR_KEY)

- (int)objectForKeySafe_Int:(id)aKey;
- (NSString *)objectForKeySafe_String:(id)aKey;
- (float)objectForKeySafe_Float:(id)aKey;
- (double)objectForKeySafe_Double:(id)aKey;
- (NSDictionary *)objectForKeySafe_Dic:(id)aKey;
- (NSArray *)objectForKeySafe_Array:(id)aKey;
- (BOOL)objectForKeySafe_BOOL:(id)aKey;
- (id)objectForKeySafe_Object:(id)aKey;
-(BOOL)hasObjectForkey:(id)key;

@end

#define INT_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_Int:KEY]
#define STRING_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_String:KEY]
#define FLOAT_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_Float:KEY]
#define Double_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_Double:KEY]
#define DICT_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_Dic:KEY]
#define ARRAY_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_Array:KEY]
#define BOOL_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_BOOL:KEY]
#define OBJECT_VALUE_FORKEY(DIC,KEY) [DIC objectForKeySafe_Object:KEY]

@interface NSMutableDictionary(SET_SAFE_OBJET_FOR_KEY)

- (void)setSafe_Object:(id)object forKey:(id)key;
-(BOOL)hasObjectForkey:(id)key;

@end
