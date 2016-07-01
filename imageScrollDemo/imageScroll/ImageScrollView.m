//
//  ImageScrollView.m
//  163NEWS
//
//  Created by dongjiangpeng on 16/2/1.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIImageView+WebCache.h"

#define PLACEHOLDER_NAME @"D_200-200"
#define ISAUTOSCROLL YES
#define SCROLLTIME 2.0

@interface ImageScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
//上一张图片
@property (nonatomic, strong) UIImageView* preImageView;
//下一张图片
@property (nonatomic, strong) UIImageView* nextImageView;
//当前图片
@property (nonatomic, strong) UIImageView* currentImageView;
//当前图片的索引
@property (nonatomic, assign) NSInteger index;
//计时器
@property (nonatomic, strong) NSTimer* timer;
//是否在滚动
@property(nonatomic,assign)BOOL isDraging;
//page页码
@property(nonatomic,strong)UIPageControl *pageControl;
/**
 *  占位符图片名字 赋值在路径赋值之前
 */
@property(nonatomic,strong)NSString *placeholderImageName;
/**
 *  是否开启自动轮播
 */
@property(nonatomic,assign)BOOL isAutoScroll;
/**
 *  自动轮播的时间(秒)
 */
@property(nonatomic,assign)NSInteger scrollTime;
/**
 *  图片的路经集合
 */
@property(nonatomic,strong)NSArray *imageUrls;
@end

@implementation ImageScrollView
{
    CGFloat viewW;
    CGFloat viewH;
    NSInteger count;
}

+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls placeholderImageName:(NSString *)placeholderImageName isAutoScroll:(BOOL)isAutoScroll scrollTime:(NSInteger)scrollTime block:(clickImageBlock)clickImageBlock{

    return [[[self class]alloc]initWithFrame:frame imageUrl:imageUrls placeholderImageName:placeholderImageName isAutoScroll:isAutoScroll scrollTime:scrollTime block:clickImageBlock];
}

+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls placeholderImageName:(NSString *)placeholderImageName block:(clickImageBlock)clickImageBlock{

    return [[[self class]alloc]initWithFrame:frame imageUrl:imageUrls placeholderImageName:placeholderImageName isAutoScroll:ISAUTOSCROLL scrollTime:SCROLLTIME block:clickImageBlock];
}

+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls isAutoScroll:(BOOL)isAutoScroll block:(clickImageBlock)clickImageBlock{
    
    return [[[self class]alloc]initWithFrame:frame imageUrl:imageUrls placeholderImageName:PLACEHOLDER_NAME isAutoScroll:isAutoScroll scrollTime:SCROLLTIME block:clickImageBlock];
}

+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls block:(clickImageBlock)clickImageBlock{

    return [[[self class]alloc]initWithFrame:frame imageUrl:imageUrls placeholderImageName:PLACEHOLDER_NAME isAutoScroll:ISAUTOSCROLL scrollTime:SCROLLTIME block:clickImageBlock];
}

+ (ImageScrollView *)returnImageScrollViewWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls{
    
    return [[[self class]alloc]initWithFrame:frame imageUrl:imageUrls placeholderImageName:PLACEHOLDER_NAME isAutoScroll:ISAUTOSCROLL scrollTime:SCROLLTIME block:nil];
}

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSArray *)imageUrls placeholderImageName:(NSString *)placeholderImageName isAutoScroll:(BOOL)isAutoScroll scrollTime:(NSInteger)scrollTime block:(clickImageBlock)clickImageBlock{
    
    self = [super init];
    if (self) {
        self.frame = frame;
        self.placeholderImageName = placeholderImageName;
        self.isAutoScroll = isAutoScroll;
        self.scrollTime = scrollTime;
        self.clickImageBlock = clickImageBlock;
        viewW = self.frame.size.width;
        viewH = self.frame.size.height;
        [self creatScrollView];
        
        if (imageUrls.count) {
            self.imageUrls = imageUrls;
            [self creatPageControl];
            [self addImageView];
        }
        if (isAutoScroll) {
            [self addTimeUpDate];
        }
        self.index = 0;
    }
    return self;
}

- (void)setImageUpdateUrls:(NSArray *)imageUpdateUrls{
    
    _imageUpdateUrls = imageUpdateUrls;
    if (imageUpdateUrls.count) {
        self.imageUrls = imageUpdateUrls;
        [self creatPageControl];
        [self addImageView];
    }
}

- (void)creatScrollView{
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.contentSize = CGSizeMake(3*viewW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentOffset = CGPointMake(viewW, 0);
    scrollView.delegate = self;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
}

- (void)creatPageControl{
    if (self.pageControl) {
        return;
    }
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.numberOfPages = self.imageUrls.count;
    pageControl.frame = CGRectMake(0, viewH - 20, viewW, 20);
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}

//添加图片控件
- (void)addImageView{
    if (self.currentImageView) {
        [self.currentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[0]] placeholderImage:[UIImage imageNamed:self.placeholderImageName]];
        return;
    }
    //上一张
    UIImageView* preImageView = [[UIImageView alloc] init];
    self.preImageView = preImageView;
    preImageView.frame = CGRectMake(0, 0, viewW, viewH);
    [self.scrollView addSubview:preImageView];
    
    //下一张
    UIImageView* nextImageView = [[UIImageView alloc] init];
    self.nextImageView = nextImageView;
    nextImageView.frame = CGRectMake(2*viewW, 0, viewW, viewH);
    [self.scrollView addSubview:nextImageView];
    //当前
    UIImageView* currentImageView = [[UIImageView alloc] init];
    self.currentImageView = currentImageView;
    currentImageView.frame = CGRectMake(viewW, 0, viewW, viewH);
#warning 用到了SDWebImage 若报错 请自行导入
    [currentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[0]] placeholderImage:[UIImage imageNamed:self.placeholderImageName]];
    [self.scrollView addSubview:currentImageView];
    
    UIButton *clickBtn = [[UIButton alloc]initWithFrame:currentImageView.frame];
    [clickBtn addTarget:self action:@selector(clickImage) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:clickBtn];
}

//时间控制
- (void)addTimeUpDate{
    
    if (_isAutoScroll) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
    }else{
        return;
    }
}

- (void)update{
    
    count++;
    if (count % _scrollTime != 0 || self.isDraging){
        return;
    }else{
        [self.scrollView setContentOffset:CGPointMake(2 * viewW, 0) animated:YES];
    }
}

//开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.isDraging = YES;
}
//结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    self.isDraging = NO;
    count = 0;
}
//滚动代理

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    
    NSInteger imageCount = self.imageUrls.count;
    
    if (self.preImageView.image == nil || self.nextImageView.image == nil) {
#warning 用到了SDWebImage 若报错 请自行导入        
        [self.preImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.index == 0 ? imageCount - 1 : self.index - 1]] placeholderImage:[UIImage imageNamed:self.placeholderImageName]];

        [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[self.index == imageCount - 1 ? 0 : self.index + 1]] placeholderImage:[UIImage imageNamed:self.placeholderImageName]];
    }
    
    //判断是向左还是向右
    if (scrollView.contentOffset.x == 2 * viewW) {
        //向右
        if (self.index == imageCount - 1) {
            self.index = 0;
        }
        else {
            self.index += 1;
        }
        self.currentImageView.image = self.nextImageView.image;
        self.nextImageView.image = nil;
        scrollView.contentOffset = CGPointMake(viewW, 0);
    }
    if (scrollView.contentOffset.x == 0) {
        
        //向左
        if (self.index == 0) {
            self.index = imageCount - 1;
        }
        else {
            self.index -= 1;
        }
        
        self.currentImageView.image = self.preImageView.image;
        self.preImageView.image = nil;
        scrollView.contentOffset = CGPointMake(viewW, 0);
    }
    
    self.pageControl.currentPage = self.index;
}

- (void)clickImage{
    
    if (self.clickImageBlock) {
        self.clickImageBlock(self.index);
    }
}

@end
