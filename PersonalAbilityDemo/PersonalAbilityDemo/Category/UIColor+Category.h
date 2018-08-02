//
//  UIColor+Category.h
//  IMDemo
//
//  Created by Ethan on 14-4-3.
//  Copyright (c) 2014年 mac iko. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef RGB
#undef RGB
#endif
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.0f]

@interface UIColor (Category)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
