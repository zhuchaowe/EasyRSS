//
//  Aspect-appearance.m
//  mcapp
//
//  Created by zhuchao on 14/12/16.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>


#define AtAspect  Font

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    [IconFont loadFontList];
    [IconFont registerFontWithDict:@{@"ttf":@"XinGothic.otf"}];

    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect