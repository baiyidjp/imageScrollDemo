//
//  ImageScrollView.h
//  163NEWS
//
//  Created by dongjiangpeng on 16/2/1.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickImageBlock)(NSInteger index);

@interface ImageScrollView : UIView

/**
 *
 *  @param frame                frame
 *  @param imageUrls            图片地址集合
 *  @param placeholderImageName 展位图片名称
 *  @param isAutoScroll         是否自动轮播
 *  @param scrollTime           自动轮播时间
 *  @param clickImageBlock      图片点击的回调
 *
 *  @return 轮播图
 */
+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls placeholderImageName:(NSString *)placeholderImageName isAutoScroll:(BOOL)isAutoScroll scrollTime:(NSInteger)scrollTime block:(clickImageBlock)clickImageBlock;

/**
 *  默认自动轮播 并且时间为2妙
 *  @param frame                frame
 *  @param imageUrls            图片地址集合
 *  @param placeholderImageName 展位图片名称
 *  @param clickImageBlock      图片点击的回调
 *  @return 轮播图
 */
+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls placeholderImageName:(NSString *)placeholderImageName block:(clickImageBlock)clickImageBlock;

/**
 *  默认展位图 选择是否自动轮播
 *  @param frame                frame
 *  @param imageUrls            图片地址集合
 *  @param isAutoScroll         展是否自动轮播图片
 *  @param clickImageBlock      图片点击的回调
 *  @return 轮播图
 */
+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls isAutoScroll:(BOOL)isAutoScroll block:(clickImageBlock)clickImageBlock;
/**
 *  默认自动轮播 并且时间为2妙 占位图使用默认的
 *  @param frame                frame
 *  @param imageUrls            图片地址集合
 *  @param clickImageBlock      图片点击的回调
 *  @return
 */
+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls block:(clickImageBlock)clickImageBlock;
/**
 *  默认自动轮播 并且时间为2妙 占位图使用默认的
 *  @param frame                frame
 *  @param imageUrls            图片地址集合
 *
 *  @return 默认支持回调
 */
+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls;

/**
 *  图片的路经集合 更新图片Urls使用
 */
@property(nonatomic,strong)NSArray *imageUpdateUrls;
/**
 *  点击图片 block
 */
@property (nonatomic,copy)clickImageBlock clickImageBlock;

//引用示例
/*
 ImageScrollView *scrollView = [ImageScrollView returnImageScrollViewWithFrame:frame imageUrl:imageUrls isAutoScroll:YES];
 [self.view addSubview:scrollView];
 
 [scrollView setClickImageBlock:^(NSInteger index) {
 NSLog(@"点击第%zd张",index);
 }];
 */
@end
