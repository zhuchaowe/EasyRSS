//
//  AddScene.m
//  rssreader
//
//  Created by 朱潮 on 14-8-18.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "AddScene.h"
#import "FeedSceneModel.h"
#import "RssListScene.h"
#import "WeChatListScene.h"
#import "ActionSceneModel.h"
#import "AddFeedRequest.h"
@interface AddScene ()
@property (strong, nonatomic) SceneScrollView *scrollerView;
@property (nonatomic,strong) UISegmentedControl *segmented;
@end

@implementation AddScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmented = [[UISegmentedControl alloc]initWithItems:@[@"RSS",@"微信",@"话题"]];
    [_segmented setFrame:CGRectMake(0, 0, 200, 32)];
    [_segmented setTintColor:[UIColor whiteColor]];
    _segmented.selectedSegmentIndex = 0;
    [self setTitleView:_segmented];
    
    self.scrollerView = [[SceneScrollView alloc]init];
    self.scrollerView.backgroundColor = [UIColor whiteColor];
    [self addSubView:self.scrollerView extend:EXTEND_TOP];
    [self.scrollerView addContentView];

    _textView = [[UITextField alloc]init];
    _textView.delegate = self;
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

    [_textView becomeFirstResponder];
    [self loadHudInKeyWindow];
    
    @weakify(self);

    [RACObserve(self.segmented, selectedSegmentIndex)
     subscribeNext:^(NSNumber *index) {
         @strongify(self);
         if(index.integerValue == 0){
             self.textView.placeholder = @"请输入RSS源地址";
         }else if(index.integerValue == 1){
             self.textView.placeholder = @"查询微信公众账号";
         }else{
             self.textView.placeholder = @"搜索相关话题";
         }
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
    if(self.segmented.selectedSegmentIndex == 0){
        if([NSURL URLWithString:_textView.text].scheme == nil){
            _textView.text = [NSString stringWithFormat:@"http://%@",_textView.text];
        }
        if([NSURL URLWithString:_textView.text].host != nil){
            AddFeedRequest *req = [AddFeedRequest Request];
            req.feedUrl = _textView.text;
            [self showHudIndeterminate:@"加载中..."];
            [[ActionSceneModel sharedInstance] sendRequest:req success:^{
                [self hideHud];
                FeedEntity *feed =  [[FeedEntity alloc]initWithDictionary:req.output error:nil];
                UIViewController *scene =  [UIViewController initFromString:feed.openUrl];
                [self.navigationController pushViewController:scene animated:YES];
            } error:^{
                [self hideHudFailed:req.message];
            }];
        }
    }else if(self.segmented.selectedSegmentIndex == 1){
        WeChatListScene *scene = [[WeChatListScene alloc]init];
        scene.title = self.textView.text;
        [self.navigationController pushViewController:scene animated:YES];
    }else{
        NSString *string = [NSString stringWithFormat:@"easyrss://topic?title=%@",self.textView.text.urlencode];
        UIViewController *vc = [UIViewController initFromString:string];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self rightButtonTouch];
    return YES;
}


@end
