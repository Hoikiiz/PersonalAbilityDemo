//
//  ResConfigLoader.h
//  Core
//
//  Created by LiuBin on 7/1/15.
//  Copyright (c) 2015 LiuBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ConfigLoader : HObject

- (NSString *)appVersion;
- (NSString *)appVersionBuild;
- (int)appVersionMaster;
- (int)appVersionMinor;
- (int)appVersionMicro;
- (NSString *)appScheme;
- (BOOL)isAppstoreVersion;

- (NSString *)appDisplayName;
- (NSString *)appDisplayNameAndVersion;

- (UIColor *)Color:(NSString *)key;
- (UIImage *)Image:(NSString *)key;
- (UIFont *)Font:(NSString *)key;
- (NSString *)String:(NSString *)key;
- (BOOL)Bool:(NSString *)key;
- (int)Int:(NSString *)key;
- (NSArray *)array:(NSString *)key;
- (NSDictionary *)dictionary:(NSString *)key;


- (UIImage *)ImageName:(NSString *)value;


- (BOOL)ImageInFolder:(NSString *)value;
- (BOOL)ImageInBundle:(NSString *)value;

- (NSDictionary *)getConfig;

@end


@interface ResConfigLoader : ConfigLoader

+ (ResConfigLoader *)sharedInstance;

- (void)set:(NSDictionary *)config;


- (NSArray *)allImages;

@end

@interface DefConfigLoader : HObject

+ (DefConfigLoader *)item;
+ (DefConfigLoader *)item:(NSString *)configFile;
+ (DefConfigLoader *)itemWithConfig:(NSDictionary *)config;

- (DefConfigLoader *)itemCopy;
- (NSMutableDictionary *)get;
- (void)set:(NSMutableDictionary *)data;
- (void)use;

- (void)replaceLayout:(NSMutableDictionary *)layout;
- (void)replaceProcess:(NSMutableArray *)process;
- (void)addProcess:(NSString *)process;
- (NSMutableDictionary *)layout;
- (NSMutableArray *)process;
- (NSData *)data;

@end
