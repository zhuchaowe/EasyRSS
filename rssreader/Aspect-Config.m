//
//  Aspect-Config.m
//  rssreader
//
//  Created by zhuchao on 15/2/18.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>

#define AtAspect Config

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"URLManage" ofType:@"plist"];
    [URLManager loadConfigFromPlist:plistPath];
    
    return XAMessageForward(application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions);
    
}
@end
#undef AtAspectOfClass

#undef AtAspect
