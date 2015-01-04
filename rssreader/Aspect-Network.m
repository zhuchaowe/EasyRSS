//
//  Aspect-appearance.m
//  mcapp
//
//  Created by zhuchao on 14/12/16.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "DataCenter.h"
#define AtAspect  Network

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    [[$ rac_didNetworkChanges]
     subscribeNext:^(NSNumber *status) {
         AFNetworkReachabilityStatus networkStatus = [status intValue];
         switch (networkStatus) {
             case AFNetworkReachabilityStatusUnknown:
             case AFNetworkReachabilityStatusNotReachable:
                 [DataCenter sharedInstance].isWifi = NO;
                 [[DialogUtil sharedInstance] showDlg:self.window textOnly:@"网络连接不给力"];
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 [DataCenter sharedInstance].isWifi = NO;
                 [[DialogUtil sharedInstance] showDlg:self.window textOnly:@"当前使用移动数据网络"];
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 [DataCenter sharedInstance].isWifi = YES;
                 break;
         }
     }];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect