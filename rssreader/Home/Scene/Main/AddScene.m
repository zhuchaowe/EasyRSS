//
//  AddScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "AddScene.h"
#import "FeedSceneModel.h"
#import "CenterNav.h"
#import "AddFeedSceneModel.h"
#import "RssListScene.h"

@interface AddScene ()
@property (strong, nonatomic) SceneScrollView *scrollerView;
@property (nonatomic,strong) AddFeedSceneModel *sceneModel;
@end

@implementation AddScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sceneModel = [AddFeedSceneModel SceneModel];
    self.title = @"添加订阅";
    self.scrollerView = [[SceneScrollView alloc]initAutoLayoutAddToView:self.view];
    self.scrollerView.backgroundColor = [UIColor whiteColor];

    _textView = [[UITextField alloc]init];
    _textView.delegate = self;
    _textView.placeholder = @"Feed or Site URL...";
    _textView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textView.returnKeyType = UIReturnKeyGo;
    [self.scrollerView.contentView addSubview:_textView];
    
    [_textView alignTop:@"20" leading:@"20" bottom:nil trailing:@"20" toView:_textView.superview];
    [_textView constrainHeight:@"30"];
    [self.scrollerView endWithView:_textView];
    
    
    UIButton *leftbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_chevron_left" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_LEFT button:leftbutton];
    
    UIButton *rightbutton = [IconFont buttonWithIcon:[IconFont icon:@"fa_check" fromFont:fontAwesome] fontName:fontAwesome size:24.0f color:[UIColor whiteColor]];
    [self showBarButton:NAV_RIGHT button:rightbutton];

    if (self.openUrl !=nil) {
        _textView.text = self.openUrl;
        [self rightButtonTouch];
    }

    [_textView becomeFirstResponder];
    [self loadHudInKeyWindow];
    
    @weakify(self);
    [[RACObserve(self.sceneModel, feed)
      filter:^BOOL(FeedEntity* value) {
          return value !=nil;
      }]
     subscribeNext:^(FeedEntity *value) {
         @strongify(self);
         [self hideHud];
         RssListScene *scene =  [[RssListScene alloc]init];
         scene.feed = value;
         [self.navigationController pushViewController:scene animated:YES];
     }];
    
    [[RACObserve(self.sceneModel.request, state)
      filter:^BOOL(NSNumber *state) {
          @strongify(self);
          return self.sceneModel.request.failed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [self hideHudFailed:self.sceneModel.request.message];
     }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftButtonTouch{
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  导航条右按钮点击事件
 */
-(void)rightButtonTouch{
    if([NSURL URLWithString:_textView.text].scheme == nil){
        _textView.text = [NSString stringWithFormat:@"http://%@",_textView.text];
    }
    if([NSURL URLWithString:_textView.text].host != nil){
        [self showHudIndeterminate:@"加载中..."];
        _sceneModel.request.feedUrl = _textView.text;
        _sceneModel.request.requestNeedActive = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self rightButtonTouch];
    return YES;
}


@end
