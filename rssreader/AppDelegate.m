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
#import "UIColor+MLPFlatColors.h"
#import "CacheAction.h"
#import "EasyKit.h"
#import "RootScene.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.database = [[AppDatabase alloc]initWithMigrations];
    [UIImageView setDefaultEngine:[CacheAction sharedInstance]];
    [$ swizzleClassMethod:@selector(objectAtIndex:) with:@selector(safeObjectAtIndex:) in:[NSArray class]];
    
    if (IOS7_OR_LATER) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor flatDarkBlueColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor flatDarkBlueColor]];
    }else{
        [[UINavigationBar appearance] setTintColor:[UIColor flatDarkBlueColor]];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],NSForegroundColorAttributeName,
                                                          [UIFont systemFontOfSize:18],NSFontAttributeName,
                                                          nil]];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    LeftScene *leftScene = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftScene"];
    RootScene *rootScene = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootScene"];
    CenterNav *centerNav = [[CenterNav alloc]initWithRootViewController:rootScene];

    ICSDrawerController *drawer = [[ICSDrawerController alloc]
                                   initWithLeftViewController:leftScene
                                   centerViewController:centerNav];
    self.window.rootViewController = drawer;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
