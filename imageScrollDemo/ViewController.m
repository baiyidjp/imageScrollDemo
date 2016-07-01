//
//  ViewController.m
//  imageScrollDemo
//
//  Created by tztddong on 16/7/1.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ViewController.h"
#import "ImageScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width*2/5.0);
    
    NSArray *imageUrls = @[@"http://res.mall.10010.cn/mall/res/uploader/index/20160630161105-1299776480.jpg",
                           @"http://res.mall.10010.cn/mall/res/uploader/index/201606151007031255234080.jpg",
                           @"http://res.mall.10010.cn/mall/res/uploader/index/20160531171624180588272.jpg",
                           @"http://res.mall.10010.cn/mall/res/uploader/index/20160623105436903078816.jpg",
                           @"http://res.mall.10010.cn/mall/res/uploader/index/20160624095103-1093280944.jpg",
                           @"http://res.mall.10010.cn/mall/res/uploader/index/20160624155413-87207984.jpg"];
    
    ImageScrollView *scrollView = [ImageScrollView returnImageScrollViewWithFrame:frame imageUrl:imageUrls isAutoScroll:YES block:^(NSInteger index) {
        
        NSLog(@"点击第几张图片-->%zd",index);
        
    }];
    [self.view addSubview:scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
