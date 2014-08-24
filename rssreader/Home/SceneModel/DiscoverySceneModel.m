//
//  DiscoverySceneModel.m
//  rssreader
//
//  Created by 朱潮 on 14-8-24.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "DiscoverySceneModel.h"

@implementation DiscoverySceneModel
-(void)loadSceneModel{
    _storage = [Frontia getStorage];
    
}

-(void)findData:(NSString *)key value:(NSObject *)value{
    //数据查询成功回调
    FrontiaDataQueryCallback result = ^(NSArray *response) {
        
        NSString *json = [NSString new];
        for (FrontiaData *data in response) {
            json = [json stringByAppendingString:[[NSString alloc]
                                                  initWithData:[data.data JSONData]
                                                  encoding:NSUTF8StringEncoding]];
        }
        
        NSString *message = [[NSString alloc] initWithFormat:@"storage query data call back response:%@", json];
        NSLog(@"%@", message);
    };
    
    //数据查询失败回调
    FrontiaStorageFailureCallback fail = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"storage query data fail with error:%d and message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
    };
    
    
    FrontiaQuery* query = [[FrontiaQuery alloc] init];
    [query equals:key value:value];
    
    [_storage findData:query resultListener:result failureListener:fail];

}

-(void)updateData:(NSString *)key replace:(NSObject *)oldValue with:(NSObject *)newValue{
    //更新数据成功的回调
    FrontiaDataModifyCallback result = ^(int modifyNumber) {
        NSString *message = [[NSString alloc] initWithFormat:@"storage update data call back response:%i", modifyNumber];
        NSLog(@"%@", message);
    };
    
    //更新数据失败后的回调
    FrontiaStorageFailureCallback fail = ^(int errorCode, NSString *errorMessage) {
        NSString *message = [[NSString alloc] initWithFormat:@"storage update data fail with error:%d and message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
    };
    
    FrontiaQuery* query = [FrontiaQuery new];
    [query equals:key value:oldValue];

    FrontiaData *data = [FrontiaData new];
    data.data = @{key:newValue};
    
    [_storage updateData:query newData:data resultListener:result failureListener:fail];
}

-(void)deleteData:(NSString *)key value:(NSObject *)value{
    
    //删除数据成功的回调
    FrontiaDataModifyCallback result = ^(int modifyNumber) {
        NSString *message = [[NSString alloc] initWithFormat:@"storage delete data call back response:%i", modifyNumber];
        NSLog(@"%@", message);
    };
    
    //删除数据失败的回调
    FrontiaStorageFailureCallback fail = ^(int errorCode, NSString *errorMessage) {
        
        NSString *message = [[NSString alloc] initWithFormat:@"storage delete data call back response: %d with message:%@", errorCode, errorMessage];
        NSLog(@"%@", message);
    };
    
    //查询条件
    FrontiaQuery* query = [[FrontiaQuery alloc] init];
    [query equals:key value:value];
    
    [_storage deleteData:query resultListener:result
        failureListener:fail];
}

-(void)insertData:(NSString *)key value:(NSObject *)value{
    FrontiaData *data = [[FrontiaData alloc]init];
    [data setData:@{key:value}];
    
    //插入数据成功的回调
    FrontiaDataInsertCallback result = ^(FrontiaData *response) {
        NSString *json = [[NSString alloc] initWithData:[response.data JSONData] encoding:NSUTF8StringEncoding];
        
        NSString *message = [[NSString alloc] initWithFormat:@"storage insert data call back response:%@", json];
        NSLog(@"%@", message);
    };
    
    //插入数据失败的回调
    FrontiaStorageFailureCallback fail = ^(int errorCode, NSString* errorMessage) {
        
        NSString *message = [[NSString alloc] initWithFormat:@"storage insert data call back error code %d response: %@", errorCode, errorMessage];
        NSLog(@"%@", message);
    };
    
    [_storage insertData:data resultListener:result failureListener:fail];
}
@end
