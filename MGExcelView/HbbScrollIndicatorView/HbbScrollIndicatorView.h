//
//  HbbScrollIndicatorView.h
//  HBB_BuyerProject
//
//  Created by mige on 16/10/8.
//  Copyright © 2016年 CHENG DE LUO. All rights reserved.
//

/**
 滑动指示视图
 
 @author mige
 */
#import <UIKit/UIKit.h>

@interface HbbScrollIndicatorView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

//指示器位置
@property (nonatomic, assign) CGPoint topInditorCenter;
@property (nonatomic, assign) CGPoint bottomInditorCenter;
@property (nonatomic, assign) CGPoint leftInditorCenter;
@property (nonatomic, assign) CGPoint rightInditorCenter;

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView;

/**
 显示指示视图
 */
- (void)showIndicator;

/**
 显示指示视图 (scrollView为空时使用)
 */
- (void)showIndicatorAtContentSize:(CGSize)contentSize withContentOffset:(CGPoint)contentOffset;

@end
