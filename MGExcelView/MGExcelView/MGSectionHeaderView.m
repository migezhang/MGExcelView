//
//  MGSectionHeaderView.m
//  MGExcelView
//
//  Created by mige on 2018/3/29.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "MGSectionHeaderView.h"

@interface MGSectionHeaderView () <UIScrollViewDelegate>

@end

@implementation MGSectionHeaderView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.contentWidth, self.frame.size.height);
    self.scrollView.frame = self.bounds;
    [self bringSubviewToFront:self.scrollView];
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    self.headerView.frame = CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setHeaderView:(UIView *)headerView{
    _headerView = headerView;
    [self.scrollView removeFromSuperview];
    [self setupView];
}

#pragma mark - 初始化视图
/**
 初始化视图
 */
- (void)setupView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.headerView.frame = self.bounds;
    [self.scrollView addSubview:self.headerView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGRect rect = self.headerView.frame;
    rect.origin.x = offsetX;
    self.headerView.frame = rect;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:scrollViewDidScroll:)]) {
        [self.delegate sectionHeaderView:self scrollViewDidScroll:scrollView];
    }
}

@end

