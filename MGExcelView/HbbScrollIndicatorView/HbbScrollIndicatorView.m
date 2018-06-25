//
//  HbbScrollIndicatorView.m
//  HBB_BuyerProject
//
//  Created by mige on 16/10/8.
//  Copyright © 2016年 CHENG DE LUO. All rights reserved.
//

#import "HbbScrollIndicatorView.h"

#define kHbb_IndicatorWith  8  //指示视图宽
#define kHbb_IndicatoHeight 5  //指示视图高

@interface HbbScrollIndicatorView () <UIScrollViewDelegate>

@property (nonatomic, strong) CAShapeLayer *topIndicator; //顶部指示视图
@property (nonatomic, strong) CAShapeLayer *bottomIndicator;//底部指示视图
@property (nonatomic, strong) CAShapeLayer *leftIndicator;//左侧指示视图
@property (nonatomic, strong) CAShapeLayer *rightIndicator;//右侧指示视图

@end

@implementation HbbScrollIndicatorView{
    BOOL isSetTopInditorCenter;
    BOOL isSetBottomInditorCenter;
    BOOL isSetLeftInditorCenter;
    BOOL isSetRightInditorCenter;
}

#pragma mark - initialization
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView{
    self = [self initWithFrame:frame];
    if (self) {
        self.scrollView = scrollView;
    }
    return self;
}

#pragma mark - 显示指示器视图
- (void)showIndicatorAtContentSize:(CGSize)contentSize withContentOffset:(CGPoint)contentOffset{
    CGSize scrollSize = self.frame.size;
    [self updateIndicatorStateWithContentSize:contentSize withContentOffset:contentOffset withScrollSize:scrollSize];
}

- (void)showIndicator{
    CGSize scrollSize = self.scrollView.frame.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGPoint contentOffset = self.scrollView.contentOffset;
    [self updateIndicatorStateWithContentSize:contentSize withContentOffset:contentOffset withScrollSize:scrollSize];
}

/**
 更新指示器视图

 @param contentSize 可滑动区域
 @param contentOffset 当前滑动位置
 @param scrollSize 滑动可视区域
 */
- (void)updateIndicatorStateWithContentSize:(CGSize)contentSize withContentOffset:(CGPoint)contentOffset withScrollSize:(CGSize)scrollSize{
    //左右滑动
    CGFloat moveX = contentOffset.x;
    if (moveX <= 0) {
        //滑动到左侧
        self.leftIndicator.hidden = YES;
        self.rightIndicator.hidden = YES;
        if (contentSize.width > scrollSize.width) {
            self.rightIndicator.hidden = NO;
        }
    }else if (contentSize.width <= scrollSize.width + moveX) {
        //滑动到右侧
        self.rightIndicator.hidden = YES;
        self.leftIndicator.hidden = YES;
        if (contentSize.width > scrollSize.width) {
            self.leftIndicator.hidden = NO;
        }
    }else{
        //滑动到中间
        self.leftIndicator.hidden = NO;
        self.rightIndicator.hidden = NO;
    }
    
    
    //上下滑动
    CGFloat moveY = contentOffset.y;
    if (moveY <= 0) {
        //滑动到顶部
        self.topIndicator.hidden = YES;
        self.bottomIndicator.hidden = YES;
        if (contentSize.height > scrollSize.height) {
            self.bottomIndicator.hidden = NO;
        }
    }else if (contentSize.height <= scrollSize.height + moveY) {
        //滑动到底部
        self.bottomIndicator.hidden = YES;
        self.topIndicator.hidden = YES;
        if (contentSize.height > scrollSize.height) {
            self.topIndicator.hidden = NO;
        }
    }else{
        //滑动到中间
        self.topIndicator.hidden = NO;
        self.bottomIndicator.hidden = NO;
    }
}

#pragma mark - 初始化视图
- (void)initView{
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    //创建顶部指示视图
    UIBezierPath *topPath = [[UIBezierPath alloc]init];
    [topPath moveToPoint:CGPointMake(0, kHbb_IndicatoHeight)];
    [topPath addLineToPoint:CGPointMake(kHbb_IndicatorWith, kHbb_IndicatoHeight)];
    [topPath addLineToPoint:CGPointMake(kHbb_IndicatorWith/2, 0)];
    [topPath closePath];
    self.topIndicator = [self createIndicateWithPath:topPath];
    self.topIndicator.hidden = YES;
    [self.layer addSublayer:self.topIndicator];
    
    //创建底部指示视图
    UIBezierPath *bottomPath = [[UIBezierPath alloc]init];
    [bottomPath moveToPoint:CGPointMake(0, 0)];
    [bottomPath addLineToPoint:CGPointMake(kHbb_IndicatorWith, 0)];
    [bottomPath addLineToPoint:CGPointMake(kHbb_IndicatorWith/2, kHbb_IndicatoHeight)];
    [bottomPath closePath];
    self.bottomIndicator = [self createIndicateWithPath:bottomPath];
    self.bottomIndicator.hidden = YES;
    [self.layer addSublayer:self.bottomIndicator];
    
    //创建左侧指示视图
    UIBezierPath *leftPath = [[UIBezierPath alloc]init];
    [leftPath moveToPoint:CGPointMake(kHbb_IndicatoHeight, 0)];
    [leftPath addLineToPoint:CGPointMake(kHbb_IndicatoHeight, kHbb_IndicatorWith)];
    [leftPath addLineToPoint:CGPointMake(0, kHbb_IndicatorWith/2)];
    [leftPath closePath];
    self.leftIndicator = [self createIndicateWithPath:leftPath];
    self.leftIndicator.hidden = YES;
    [self.layer addSublayer:self.leftIndicator];
    
    //创建右侧指示视图
    UIBezierPath *rightPath = [[UIBezierPath alloc]init];
    [rightPath moveToPoint:CGPointMake(0, 0)];
    [rightPath addLineToPoint:CGPointMake(0, kHbb_IndicatorWith)];
    [rightPath addLineToPoint:CGPointMake(kHbb_IndicatoHeight, kHbb_IndicatorWith/2)];
    [rightPath closePath];
    self.rightIndicator = [self createIndicateWithPath:rightPath];
    self.rightIndicator.hidden = YES;
    [self.layer addSublayer:self.rightIndicator];
}

//创建指示视图
- (CAShapeLayer *)createIndicateWithPath:(UIBezierPath *)path{
    //指示器
    CAShapeLayer *indicator = [[CAShapeLayer alloc]init];
    indicator.path = path.CGPath;
    indicator.lineWidth = 1.0;
    indicator.fillColor = [UIColor colorWithRed:247.0/255 green:77/255.0 blue:97.0/255 alpha:1.0].CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(indicator.path, nil, indicator.lineWidth, kCGLineCapButt, kCGLineJoinMiter, indicator.miterLimit);
    indicator.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    return indicator;
}

//布局指示视图
- (void)layoutIndicator{
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    if (isSetTopInditorCenter == NO) {
        self.topIndicator.position = CGPointMake(viewWidth/2, (kHbb_IndicatoHeight+5)/2);
    }else{
        self.topIndicator.position = self.topInditorCenter;
    }
    
    if (isSetBottomInditorCenter == NO) {
        self.bottomIndicator.position = CGPointMake(viewWidth/2, viewHeight - (kHbb_IndicatoHeight+5)/2);
    }else{
        self.bottomIndicator.position = self.bottomInditorCenter;
    }
    
    if (isSetLeftInditorCenter == NO) {
        self.leftIndicator.position = CGPointMake((kHbb_IndicatoHeight+5)/2, viewHeight/2);
    }else{
        self.leftIndicator.position = self.leftInditorCenter;
    }
    
    if (isSetRightInditorCenter == NO) {
        self.rightIndicator.position = CGPointMake(viewWidth-(kHbb_IndicatoHeight+5)/2, viewHeight/2);
    }else{
        self.rightIndicator.position = self.rightInditorCenter;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //布局指示视图
    [self layoutIndicator];
    
    //设置显示
    if (self.scrollView != nil) {
        [self showIndicator];
    }
}

#pragma mark - setter
- (void)setTopInditorCenter:(CGPoint)topInditorCenter{
    _topInditorCenter = topInditorCenter;
    isSetTopInditorCenter = YES;
    //更新指示视图布局
    [self layoutIndicator];
}

- (void)setBottomInditorCenter:(CGPoint)bottomInditorCenter{
    _bottomInditorCenter = bottomInditorCenter;
    isSetBottomInditorCenter = YES;
    //更新指示视图布局
    [self layoutIndicator];
}

- (void)setLeftInditorCenter:(CGPoint)leftInditorCenter{
    _leftInditorCenter = leftInditorCenter;
    isSetLeftInditorCenter = YES;
    //更新指示视图布局
    [self layoutIndicator];
}

- (void)setRightInditorCenter:(CGPoint)rightInditorCenter{
    _rightInditorCenter = rightInditorCenter;
    isSetRightInditorCenter = YES;
    //更新指示视图布局
    [self layoutIndicator];
}

@end
