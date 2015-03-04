//
//  SettingScene.m
//  rssreader
//
//  Created by zhuchao on 15/2/18.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "SettingScene.h"
#import "Config.h"

@interface SettingScene ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SceneTableView *tableView;
@property(strong,nonatomic)NSArray *dataArray;
@end

@implementation SettingScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    self.dataArray = @[@[@{@"title":@"清除缓存",@"link":@"cache://"}],
                   @[@{@"title":@"省流量模式",@"link":@"switch://noimage"},
                     @{@"title":@"夜间模式",@"link":@"switch://nightmode"}]];
    
    self.tableView = [[SceneTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithString:@"#EFEFF4"];
    self.tableView.rowHeight = 44.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubView:self.tableView extend:EXTEND_TOP];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [_dataArray objectAtIndexPath:indexPath];
    cell.textLabel.text = [dict objectForKey:@"title"];
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"link"]];
    if([url.scheme isEqualToString:@"cache"]){
        cell.detailTextLabel.text = [self getCacheSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ([url.scheme isEqualToString:@"switch"]){
        UISwitch *sw=[[UISwitch alloc]init];
        if([url.host isEqualToString:@"noimage"]){
            sw.on = [Config sharedInstance].noImageMode.boolValue;
            [sw addTarget:self action:@selector(noimage:) forControlEvents:UIControlEventValueChanged];
        }else if ([url.host isEqualToString:@"nightmode"]){
            sw.on = [Config sharedInstance].nightMode.boolValue;
            [sw addTarget:self action:@selector(nightmode:) forControlEvents:UIControlEventValueChanged];
        }
        cell.accessoryView = sw;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [_dataArray objectAtIndex:section];
    return array.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_dataArray objectAtIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"link"]];
    if([url.scheme isEqualToString:@"cache"]){
        [RMUniversalAlert showAlertInViewController:self withTitle:@"清除缓存" message:@"确认要清除缓存？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert *alert,NSInteger buttonIndex) {
            if (buttonIndex == alert.destructiveButtonIndex) {
                [[[TMCache sharedCache] diskCache] removeAllObjects];
                [[SDImageCache sharedImageCache] clearDisk];
                UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = [self getCacheSize];
                [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"缓存清除成功"];
            }
        }];
    }
}

-(void)noimage:(UISwitch *)sender{
    [Config sharedInstance].noImageMode = [NSNumber numberWithBool: sender.on];
}

-(void)nightmode:(UISwitch *)sender{
    [Config sharedInstance].nightMode = [NSNumber numberWithBool: sender.on];
}

-(NSString *)getCacheSize{
    
    CGFloat num = ([[SDImageCache sharedImageCache] getSize] + [[[TMCache sharedCache] diskCache] byteCount])/1024;
    if (num > 1024) {
        num = num/1024;
        return  [NSString stringWithFormat:@"%.1fMB",num];
    }else{
        return [NSString stringWithFormat:@"%.1fKB",num];
    }
}
@end
