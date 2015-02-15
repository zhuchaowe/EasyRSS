//
//  Aspect-Window.m
//  rssreader
//
//  Created by zhuchao on 15/2/14.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "TabBarController.h"
#import "DataCenter.h"

#define AtAspect Window

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

AspectPatch(-, void,application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"URLManage" ofType:@"plist"];
    [[URLManager sharedInstance] loadConfigFromPlist:plistPath];
    
    self.database = [[AppDatabase alloc]initWithMigrations];
    
    [Action actionConfigHost:@"rss.iosx.me" client:@"easyios" codeKey:@"Code" rightCode:0 msgKey:@"Msg"];
    [$ swizzleClassMethod:@selector(objectAtIndex:) with:@selector(safeObjectAtIndex:) in:[NSArray class]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    TabBarController *centerNav = [[TabBarController alloc]init];
    
    self.window.rootViewController = centerNav;
    [self.window makeKeyAndVisible];
    
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
    
    
    XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass

#undef AtAspect
