//
//  Aspect-appearance.m
//  mcapp
//
//  Created by zhuchao on 14/12/16.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "MobClick.h"

#define CHANNEL_ID @"pgyer"
#define UMAppKey @"53f8902ffd98c585ba02a156"
#define AtAspect  UMengConfig

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    
    [MobClick startWithAppkey:UMAppKey reportPolicy:SEND_INTERVAL   channelId:CHANNEL_ID];
    [MobClick checkUpdate];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}

@end
#undef AtAspectOfClass
#undef AtAspect