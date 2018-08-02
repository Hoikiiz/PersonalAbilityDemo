//
//  ResConfigLoader.m
//  Core
//
//  Created by LiuBin on 7/1/16.
//  Copyright (c) 2016 LiuBin. All rights reserved.
//

#import "ResConfigLoader.h"

@implementation ConfigLoader

- (NSDictionary *)getConfig
{
    return nil;
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appVersion
 * @HOVERRIDE : YES
 * @HNOTES:  应用程序版本
 * @HEND
 */
- (NSString *)appVersion
{
    NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSArray *versionArray = [version componentsSeparatedByString:@"."];
    if (versionArray.count <= 1)
    {
        return [NSString stringWithFormat:@"%@.0.0",version];
    }
    else if (versionArray.count == 2)
    {
        return [NSString stringWithFormat:@"%@.0",version];
    }
    else
    {
        return version;
    }
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appVersionBuild
 * @HOVERRIDE : YES
 * @HNOTES:  应用程序build 版本号
 * @HEND
 */
- (NSString *)appVersionBuild
{
    return [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appVersionMaster
 * @HOVERRIDE : YES
 * @HNOTES:  应用程序主版本（第一位版本号）
 * @HEND
 */
- (int)appVersionMaster
{
    NSString *version = [self appVersion];
    NSArray *versionArray = [version componentsSeparatedByString:@"."];
    if (versionArray.count <= 1)
    {
        return [version intValue];
    }
    else
    {
        return [[versionArray objectAtIndex:0]intValue];
    }
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appVersionMinor
 * @HOVERRIDE : YES
 * @HNOTES: 应用程序小版本（第二位版本号）
 * @HEND
 */
- (int)appVersionMinor
{
    NSString *version = [self appVersion];
    NSArray *versionArray = [version componentsSeparatedByString:@"."];
    if (versionArray.count <= 1)
    {
        return 0;
    }
    else
    {
        return [[versionArray objectAtIndex:1]intValue];
    }
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appVersionMicro
 * @HOVERRIDE : YES
 * @HNOTES: 应用程序小版本（第三位版本号）
 * @HEND
 */
- (int)appVersionMicro
{
    NSString *version = [self appVersion];
    NSArray *versionArray = [version componentsSeparatedByString:@"."];
    if (versionArray.count <= 2)
    {
        return 0;
    }
    else
    {
        return [[versionArray objectAtIndex:2]intValue];
    }
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appDisplayName
 * @HOVERRIDE : YES
 * @HNOTES:应用程序显示名字
 * @HEND
 */
- (NSString *)appDisplayName
{
    return [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appDisplayNameAndVersion
 * @HOVERRIDE : YES
 * @HNOTES:应用程序显示名字及版本号 （关于中显示的名称--例如：新乡中心医院 V1.2.2 ）
 * @HEND
 */
- (NSString *)appDisplayNameAndVersion
{
    return  [NSString stringWithFormat:@"%@ V%@",[self String:@"Version_NAME"],[self  appVersion]];
}

/* @HBEGIN
 * @HCLASS: ConfigLoader
 * @HFUNC: appScheme
 * @HOVERRIDE : YES
 * @HNOTES:获取应用程序scheme  咱们程序比较特殊， scheme 就是bundleIdentifier 去掉 .co
 * @HEND
 */
- (NSString *)appScheme
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier rangeOfString:@".co.dev"].length > 0)
    {
        return [identifier substringToIndex:identifier.length - 7];
    }
    if ([identifier rangeOfString:@".co"].length > 0 && identifier.length > 3)
    {
        return [identifier substringToIndex:identifier.length -3 ];
    }
    return identifier;
}

- (BOOL)isAppstoreVersion
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier hasSuffix:@".co"] || [identifier containsString:@".co.dev"])
    {
        // 判定是否debug模式，debug设置不存在或为NO，返回YES，如果设置为YES，返回NO
        return ![[ResConfigLoader sharedInstance]Bool:@"DEBUG_SETTING_SWITCH"];
        
        return NO;
    }
    else
    {
        return YES;
    }
}

- (UIColor *)Color:(NSString *)key
{
    NSDictionary *config = [self getConfig];
    if(!config)
    {
        return [UIColor whiteColor];
    }
    
    NSString *value = [config objectForKey:key];
    if(value)
    {
        return [UIColor colorWithHexString:value];
    }
    else
    {
        return [UIColor whiteColor];
    }
}

- (UIImage *)Image:(NSString *)key
{
    //TGLog(@"Running %@ '%@' Param:%@",self.class,NSStringFromSelector(_cmd),key);
    NSDictionary *config = [self getConfig];
    if(!config)
    {
        return nil;
    }
    
    NSString *value = [config objectForKey:key];
    if(value)
    {
        return [self ImageName:value];
    }
    else return nil;
}

- (UIFont *)Font:(NSString *)key
{
    NSDictionary *config = [self getConfig];
    if(!config)
    {
        return [UIFont systemFontOfSize:14.0f];
    }
    NSString *value = [config objectForKey:key];
    NSArray *aTest = [value componentsSeparatedByString:@","];
    
    if(aTest.count == 2)
    {
        return [UIFont fontWithName:aTest[0] size:[aTest[1] floatValue]];
    }
    else return [UIFont systemFontOfSize:14.0f];
}

- (BOOL)Bool:(NSString *)key
{
    NSDictionary *config = [self getConfig];
    if(!config)
    {
        return NO;
    }
    return [[config objectForKey:key] boolValue];
}

- (NSString *)String:(NSString *)key
{
    if(key.length == 0)
    {
        return @"";
    }
    
    NSDictionary *config = [self getConfig];
    if(!config)
    {
        return @"";
    }
    return [config objectForKey:key];
}

- (int)Int:(NSString *)key
{
    NSDictionary *config = [self getConfig];
    if(!config)
    {
        return -1;
    }
    return [[config objectForKey:key]intValue];
}

- (NSArray *)array:(NSString *)key
{
    NSDictionary *config = [self getConfig];
    if (!config)
    {
        return nil;
    }
    return [config objectForKey:key];
}

- (NSDictionary *)dictionary:(NSString *)key
{
    NSDictionary *config = [self getConfig];
    if (!config)
    {
        return nil;
    }
    return [config objectForKey:key];
}

- (UIImage *)ImageName:(NSString *)value
{
    if(value.length == 0)
    {
        return nil;
    }
    
    NSArray *imageName = [value componentsSeparatedByString:@"."];
    NSString *name = nil;
    NSString *ext = nil;
    if(imageName.count == 2)
    {
        name = [NSString stringWithFormat:@"%@@2x",imageName[0]];
        ext = imageName[1];
    }
    else if(imageName.count == 1)
    {
        name = [NSString stringWithFormat:@"%@@2x",imageName[0]];
        ext = @"png";
    }
    
    NSString *filePath = nil;
    if(name.length > 0 && ext.length > 0)
    {
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:ext inDirectory:@"Resource"];
    }
    
    if(filePath)
    {
        return [UIImage imageWithContentsOfFile:filePath];
    }
    else
    {
        UIImage *projectImage = [UIImage imageNamed:value];
        
        if(!projectImage)
        {
            NSLog(@"####### IMAGE NOT FOUND : %@", value);
        }
        
        return projectImage;
    }
}

- (BOOL)ImageInFolder:(NSString *)value
{
    if(value.length == 0)
    {
        return NO;
    }
    
    NSArray *imageName = [value componentsSeparatedByString:@"."];
    NSString *name = nil;
    NSString *ext = nil;
    if(imageName.count == 2)
    {
        name = [NSString stringWithFormat:@"%@@2x",imageName[0]];
        ext = imageName[1];
    }
    else if(imageName.count == 1)
    {
        name = [NSString stringWithFormat:@"%@@2x",imageName[0]];
        ext = @"png";
    }
    
    NSString *filePath = nil;
    if(name.length > 0 && ext.length > 0)
    {
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:ext inDirectory:@"Resource"];
    }
    
    return (filePath.length > 0);
}

- (BOOL)ImageInBundle:(NSString *)value
{
    UIImage *projectImage = [UIImage imageNamed:value];
    return (projectImage!=nil);
}

@end

#pragma mark - ResConfigLoader

@interface ResConfigLoader ()

@property (nonatomic, retain) NSDictionary *mConfig;

@end

@implementation ResConfigLoader

+ (ResConfigLoader *)sharedInstance
{
    static ResConfigLoader *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ResConfigLoader alloc] init];
    });
    return _sharedInstance;
}

- (NSDictionary *)getConfig
{
    return self.mConfig;
}

- (void)set:(NSDictionary*)config
{
    self.mConfig = config;
}

- (NSArray *)allImages
{
    NSMutableArray *images = [NSMutableArray array];
    NSArray *allValues = [self.mConfig allValues];
    [allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSString class]])
        {
            NSString *value = (NSString *)obj;
            if([value hasSuffix:@".png"])
            {
                [images addObject:value];
            }
        }
    }];
    return images;
}

@end

#pragma mark - DefConfigLoader Def

@interface DefConfigLoader ()

{
    NSMutableDictionary *config;
}

@end

@implementation DefConfigLoader

+ (DefConfigLoader *)item
{
    return [[DefConfigLoader alloc]initWithFile:nil];
}

+ (DefConfigLoader *)item:(NSString *)configFile
{
    return [[DefConfigLoader alloc]initWithFile:configFile];
}

+ (DefConfigLoader *)itemWithConfig:(NSDictionary *)config
{
    DefConfigLoader *loader = [[DefConfigLoader alloc] init];
    [loader set:[config mutableCopy]];
    return loader;
}

- (DefConfigLoader *)itemCopy
{
    DefConfigLoader *loader = [[DefConfigLoader alloc] init];
    [loader set:[self get]];
    
    return loader;
}

- (id)initWithOther:(DefConfigLoader *)oth
{
    self = [super init];
    if(self)
    {
        [self loadDefaultWithOther:oth];
    }
    return self;
}

- (id)initWithFile:(NSString *)file
{
    self = [super init];
    if(self)
    {
        [self loadDefaultWith:file];
    }
    return self;
}

- (void)loadDefaultWith:(NSString *)file
{
    NSString *filePath = file;
    
    if(filePath.length == 0)
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"ResConfig" ofType:@"plist"];
    }
    
    if (filePath)
    {
        config = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
//        NSString *str = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath]
//                                                 encoding:NSUTF8StringEncoding
//                                                    error:NULL];
//        if (str)
//        {
//            NSString *desStr = [DES decryptString:str];
//            if(desStr)
//            {
//                NSData *desData = [desStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSString *error;
//                config = [[NSPropertyListSerialization propertyListWithData:desData options:0 format:nil error:&error] deepMutableCopy];
//            }
//        }
    }
    
    if(config.count == 0)
    {
        NSLog(@"Config file read error");
    }
}

- (void)loadDefaultWithOther:(DefConfigLoader *)oth
{
    config = [[oth get] mutableCopy];
}

- (void)use
{
    [[ResConfigLoader sharedInstance] set:config];
}

- (NSDictionary *)get
{
    return [config mutableCopy];
}

- (void)set:(NSMutableDictionary *)data
{
    config = [data mutableCopy];
}

- (void)replaceLayout:(NSMutableDictionary *)layout
{
    if(!layout)
    {
        return;
    }
    
    if([config hasObjectForkey:@"Layout"])
    {
        [config removeObjectForKey:@"Layout"];
    }
 
    [config setObject:layout forKey:@"Layout"];
}

- (void)replaceProcess:(NSMutableArray *)process
{
    if(!process)
    {
        return;
    }
    
    if([config hasObjectForkey:@"Process"])
    {
        [config removeObjectForKey:@"Process"];
    }
    
    [config setObject:process forKey:@"Process"];
}

- (void)addProcess:(NSString *)processName
{
    if(processName.length == 0)
    {
        return;
    }
    
    if(![config hasObjectForkey:@"Process"])
    {
        [config setObject:[NSMutableArray array] forKey:@"Process"];
    }
    
    NSMutableArray *process = [config objectForKey:@"Process"];
    if(![process containsObject:processName])
    {
        [process addObject:processName];
    }
}

- (NSMutableDictionary *)layout
{
    if([config hasObjectForkey:@"Layout"])
    {
        return [config objectForKey:@"Layout"];
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableArray *)process
{
    if([config hasObjectForkey:@"Process"])
    {
        return [config objectForKey:@"Process"];
    }
    
    return [NSMutableArray array];
}

- (NSString *)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSData *)data
{
    if(!config)
    {
        return nil;
    }
    
    NSString *tmpDir = [NSTemporaryDirectory() stringByAppendingString:@"/t"];
    [config writeToFile:tmpDir atomically:YES];
    
    return [NSData dataWithContentsOfFile:tmpDir];
    
//    NSString *jsonString = [self DataTOjsonString:config];
//    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
