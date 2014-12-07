//
//  AppDelegate.m
//  rssreader
//
//  Created by 朱潮 on 14-8-12.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftScene.h"
#import "CenterNav.h"
#import "RootScene.h"
#import "MobClick.h"
#import "Rss.h"
#import "FeedSceneModel.h"
#import "PresentRssList.h"
#import "DataCenter.h"
#import "AddScene.h"

#define CHANNEL_ID @"pgyer"
#define UMAppKey @"53f8902ffd98c585ba02a156"
@interface AppDelegate ()
@property(nonatomic,retain)RootScene *rootScene;
@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    
    UILocalNotification * notification=[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notification !=nil && [notification.userInfo objectForKey:@"time"]){
        [DataCenter sharedInstance].time = [notification.userInfo objectForKey:@"time"];
    }
   
    [self setUpAnialytics];
    [self setUpBackGroundReflash];

    self.database = [[AppDatabase alloc]initWithMigrations];
    [$ swizzleClassMethod:@selector(objectAtIndex:) with:@selector(safeObjectAtIndex:) in:[NSArray class]];
    
    if (IOS7_OR_LATER) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor flatDarkOrangeColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }else{
        [[UINavigationBar appearance] setTintColor:[UIColor flatDarkOrangeColor]];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],NSForegroundColorAttributeName,
                                                          [UIFont systemFontOfSize:18],NSFontAttributeName,
                                                          nil]];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    LeftScene *leftScene = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftScene"];
    _rootScene = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootScene"];
    CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:_rootScene];

    ICSDrawerController *drawer = [[ICSDrawerController alloc]
                                   initWithLeftViewController:leftScene
                                   centerViewController:centerNav];
    self.window.rootViewController = drawer;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [Rss setUpNoti];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if([notification.userInfo objectForKey:@"time"]){
        [DataCenter sharedInstance].time = [notification.userInfo objectForKey:@"time"];
        PresentRssList *presentRssListScene =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PresentRssList"];
        CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:presentRssListScene];
        [_rootScene presentViewController:centerNav animated:YES completion:nil];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"%@", [url absoluteString]);
    if ([url.scheme isEqualToString:@"feed"]) {
        AddScene *addScene =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddScene"];
        addScene.openUrl = [url.absoluteString stringByReplacingOccurrencesOfString:@"feed" withString:@"http"];

        CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:addScene];
        [_rootScene presentViewController:centerNav animated:YES completion:nil];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    
    [[$ rac_didNetworkChanges]
     subscribeNext:^(NSNumber *status) {
         AFNetworkReachabilityStatus networkStatus = [status intValue];
         switch (networkStatus) {
             case AFNetworkReachabilityStatusUnknown:
             case AFNetworkReachabilityStatusNotReachable:
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 [DataCenter sharedInstance].isWifi = NO;
                 completionHandler(UIBackgroundFetchResultNoData);
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 [DataCenter sharedInstance].isWifi = YES;
                 [[FeedSceneModel sharedInstance]
                  reflashAllFeed:nil each:nil finish:^{
                      if([Rss notifyNewMessage]){
                          completionHandler(UIBackgroundFetchResultNewData);
                      }else{
                          completionHandler(UIBackgroundFetchResultNoData);
                      }
                  }];
                 break;
         }
     }];
}


-(void)setUpBackGroundReflash{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:1800];
}

-(void)setUpAnialytics{
    [MobClick startWithAppkey:UMAppKey reportPolicy:SEND_INTERVAL   channelId:CHANNEL_ID];
    [MobClick checkUpdate];
}
@end
