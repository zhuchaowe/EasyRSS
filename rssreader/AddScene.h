//
//  AddScene.h
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "RootScene.h"

@interface AddScene : Scene<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *textView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollerView;

@end
