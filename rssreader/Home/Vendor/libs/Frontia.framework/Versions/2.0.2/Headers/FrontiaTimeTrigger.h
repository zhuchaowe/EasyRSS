/*!
 @header FrontiaTimeTrigger.h
 @abstract 定时器触发类，用于控制推送时间
 @discussion triggerDate定义了消息推送第一次推送的时间，如果指定时间相对当前时间已经过期，则立即发送。
 triggerCrontab定义了消息循环推送的contab样式。
 
 使用示例:
 
 FrontiaTimeTrigger *trigger = [ [FrontiaTimeTrigger alloc] init];
 trigger.triggerDate = someDate; //指定第一次触发时间
 trigger.triggerCrontab = @"0 8 * * *"; //指定crontab格式的周期，表示该计时器在每天早上8点钟都会触发
 
 @version 1.00 2013/07/17 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface FrontiaTimeTrigger : NSObject

/*
 * push message trigger time
 */
@property(strong, nonatomic) NSDate* triggerDate;


/*
 * push message trigger time
 */
@property(strong, nonatomic) NSString* triggerCrontab;

@end
