//
//  MGSectionHeaderView.h
//  MGExcelView
//
//  Created by mige on 2018/3/29.
//  Copyright © 2018年 mige. All rights reserved.
//
/**
 *  表格分区头部视图
 *
 *  @author mige
 */
#import <UIKit/UIKit.h>

@class MGSectionHeaderView;
@protocol MGSectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(MGSectionHeaderView *)sectionHeaderView scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface MGSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<MGSectionHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIView *headerView; //头部视图
@property (nonatomic, assign) CGFloat contentWidth; //内容宽度

@property (nonatomic, strong, readonly) UIScrollView *scrollView; //滑动视图

@end
