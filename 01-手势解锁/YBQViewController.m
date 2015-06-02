//
//  YBQViewController.m
//  01-手势解锁
//
//  Created by 严必庆 on 15-5-30.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "YBQViewController.h"
#import "BQLockView.h"
@interface YBQViewController ()<BQLockViewDelegate>
@property (weak, nonatomic) IBOutlet BQLockView *lockView;
@end
@implementation YBQViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lockView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)lockView:(BQLockView *)lockView didFinishPath:(NSString *)path{
    NSLog(@"用户路径是：%@",path);
}

@end
