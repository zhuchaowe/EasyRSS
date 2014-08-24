//
//  Rss.m
//  rssreader
//
//  Created by 朱潮 on 14-8-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Rss.h"
#import <UIKit/UIKit.h>
#import "swift-bridge.h"
#import "FavSceneModel.h"
@implementation Rss

/**
 *  全部已读
 */
+(void)setReadWhere:(NSDictionary *)map{
    [[GCDQueue globalQueue] queueBlock:^{
        [[[Rss Model] where:map] update:@{@"isRead":@(1)}];
    }];
}

/**
 *  更新已读
 */
-(void)saveRead{
    if(self.savedInDatabase){
        [[GCDQueue globalQueue] queueBlock:^{
            [self resetAll];
            [self update:@{@"isRead":@(self.isRead)}];
        }];
    }
}

-(void)saveFav{
    if(self.savedInDatabase){
        [[GCDQueue globalQueue] queueBlock:^{
            [self resetAll];
            [self update:@{@"isFav":@(self.isFav)}];
            [[FavSceneModel sharedInstance] retData:@(1) pageSize:@10];
        }];
    }
}
/**
 *  beforeSave
 *  保存之前 保证数据字段identifier唯一
 */
-(void)beforeSave{
    [super beforeSave];
    NSArray *list = [Rss findByColumn:@"identifier" value:self.identifier];
    [list enumerateObjectsUsingBlock:^(Rss* objc, NSUInteger idx, BOOL *stop) {
        if(idx == 0){
            self.primaryKey = objc.primaryKey;
            self.savedInDatabase = objc.savedInDatabase;
            self.isRead = objc.isRead;
            self.isDislike = objc.isDislike;
            self.isFav = objc.isFav;
        }else{
            [objc delete];
        }
    }];
}

+(NSArray *)rssListInDb:(NSDictionary *)map page:(NSNumber *)page pageSize:(NSNumber *)pageSize{
    return [[[[[Rss Model] where:map] order:@"`date` DESC"] limit:(page.integerValue -1) * pageSize.integerValue size:pageSize.integerValue] select];
}

+(NSUInteger)totalNotReadedCount{
    NSUInteger numberCount = [[[Rss Model] where:@{@"isRead":@(0)}] getCount];
    [UIApplication sharedApplication].applicationIconBadgeNumber = numberCount;
    return numberCount;
}

+(void)setUpNoti{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:60*60*3];//3小时后通知
        notification.repeatInterval = kCFCalendarUnitDay;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [self totalNotReadedCount]; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，
        //去掉下面2行就不会弹出提示框
        notification.alertBody= [NSString stringWithFormat:@"保持阅读跟上时代，一大波新鲜文章到了，碾碎他们！"] ;//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
@end
