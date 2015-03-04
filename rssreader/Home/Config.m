//
//  Config.m
//  rssreader
//
//  Created by zhuchao on 15/2/18.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Config.h"

@implementation Config

DEF_SINGLETON(Config)

-(instancetype)init{
    self = [super init];
    if(self){
        [$ touchPath:$.libPrePath];
        NSString *configPath = [$.libPrePath stringByAppendingPathComponent:@"config.plist"];
        [$ touchFile:configPath];
        NSMutableDictionary *config = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
        if(!config.isNotEmpty){
            config = [NSMutableDictionary dictionary];
            [config setValue:[NSNumber numberWithBool:NO] forKey:@"noImageMode"];
            [config setValue:[NSNumber numberWithBool:NO] forKey:@"nightMode"];
            [config writeToFile:configPath atomically:YES];
        }
    }
    return self;
}

-(void)setNoImageMode:(NSNumber *)noImageMode{
    [self saveValue:noImageMode forKey:@"noImageMode"];
}

-(NSNumber *)noImageMode{
    return [self getValueForKey:@"noImageMode"];
}

-(void)setNightMode:(NSNumber *)nightMode{
    [self saveValue:nightMode forKey:@"nightMode"];
}

-(NSNumber *)nightMode{
    return [self getValueForKey:@"nightMode"];
}

-(void)saveValue:(id)value forKey:(NSString *)key{
    NSString *configPath = [$.libPrePath stringByAppendingPathComponent:@"config.plist"];
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    [config setValue:value forKey:key];
    [config writeToFile:configPath atomically:YES];
}

-(id)getValueForKey:(NSString *)key{
    NSString *configPath = [$.libPrePath stringByAppendingPathComponent:@"config.plist"];
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    return [config objectForKey:key];
}
@end
