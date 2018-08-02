//
//  HNavigationController.m
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

#import "HNavigationController.h"

@interface HNavigationController ()

@end

@implementation HNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(![viewController isKindOfClass:[UIViewController class]])
    {
        return;
    }
    
    if([viewController isKindOfClass:[HViewController class]])
    {
        HViewController *vc = (HViewController*)viewController;
        if([vc blockedByNetError])
        {
            if(![self networkReachable])
            {
                NSLog(@"当前网络不可用");
                return;
            }
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)networkReachable {
//    此处可使用AFN对网络状况进行判断，demo中不做具体处理
    return true;
}

@end
