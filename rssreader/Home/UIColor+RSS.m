//
//  UIColor+RSS.m
//  rssreader
//
//  Created by zhuchao on 15/2/11.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "UIColor+RSS.h"

@implementation UIColor (RSS)
+(UIColor *)colorAtIndex:(NSUInteger)index{
    NSArray *colors = @[@"#DD544E",@"#FF98A7",@"#72B4D1",@"#4681CF",@"#FFBA4D",
                        @"#72B4D1",@"#DD544E",@"#FF6F49",@"#535F8B",@"#DF5B56",
                        @"#FFBA4D",@"#EF5282",@"#DD544E",@"#54C5B4",@"#535F8B"];
    return [UIColor colorWithString:[colors objectAtIndex:index%15]];
}
@end
