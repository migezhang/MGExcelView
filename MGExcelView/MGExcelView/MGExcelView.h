//
//  MGExcelView.h
//  MGExcelViewDemo
//
//  Created by mige on 2018/2/12.
//  Copyright © 2018年 mige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGExcelTableViewCell.h"

@class MGExcelIndexPath;
@protocol MGExcelViewDataSource, MGExcelViewDelegate;

/**
 *  分区表格视图
 *
 *  @author mige
 */
@interface MGExcelView : UIView

@property (nonatomic, weak) id<MGExcelViewDataSource> dataSource;
@property (nonatomic, weak) id<MGExcelViewDelegate> delegate;

@property (nonatomic, strong, readonly) UITableView *tableView; //列表视图
@property (nonatomic, strong, readonly) MGExcelTableViewCell *headerCell; //表头视图

@property (nonatomic, assign, readonly) CGSize contentSize; //表格内容区域大小
@property (nonatomic, assign) CGPoint contentOffset; //内容区域偏移

@property (nonatomic, assign) BOOL isFillWidth; //是否填充宽度，即总列宽小于视图宽度时，是否让总列宽等于视图宽度，默认YES

/**
 转换路径
 */
- (NSIndexPath *)indexPathWithExcelIndexColumn:(NSInteger)column;

/**
 刷新数据
 */
- (void)refreshData;

@end


/**
 表格数据源代理
 */
@protocol MGExcelViewDataSource <NSObject>

@required
//返回列数
- (NSInteger)numbersOfColumnWithExcelView:(MGExcelView *)excelView;

//返回行数
- (NSInteger)excelView:(MGExcelView *)excelView numbersOfRowInSection:(NSInteger)section;

//注册CollectionView重用Cell
- (void)excelView:(MGExcelView *)excelView registerCellWithCollectionView:(UICollectionView *)collectionView;

//返回表格样式
- (UICollectionViewCell *)excelView:(MGExcelView *)excelView cellForExcelAtIndex:(MGExcelIndexPath *)index withCollectionView:(UICollectionView *)collectionView;

@optional
//返回分区数
- (NSInteger)numbersOfSectionWithExcelView:(MGExcelView *)excelView;

//返回表头视图样式
- (UICollectionViewCell *)excelView:(MGExcelView *)excelView cellForExcelHeaderViewAtColumn:(NSInteger)column withCollectionView:(UICollectionView *)collectionView;

//返回分区头部视图
- (UIView *)excelView:(MGExcelView *)excelView headerViewInSection:(NSInteger)section;

//设置锁定的列数
- (NSInteger)numbersOfLockColumnsWithExcelView:(MGExcelView *)excelView;

@end

/**
 表格代理
 */
@protocol MGExcelViewDelegate <NSObject>

@required
//返回列宽
- (CGFloat)excelView:(MGExcelView *)excelView columnWidthForItemAtColumn:(NSInteger)column;

//返回行高
- (CGFloat)excelView:(MGExcelView *)excelView rowHeightInSection:(NSInteger)section forItemAtRow:(NSInteger)row;


@optional
//返回表头高度
- (CGFloat)excelHeaderViewHeightWithExcelView:(MGExcelView *)excelView;

//返回分区头部视图高度
- (CGFloat)excelView:(MGExcelView *)excelView headerHeightInSection:(NSInteger)section;

//点击表格项
- (void)excelView:(MGExcelView *)excelView didSelectItemAtIndex:(MGExcelIndexPath *)index;

//点击表头表格项
- (void)excelView:(MGExcelView *)excelView didSelectHeaderItemAtColumn:(NSInteger)column;

//滑动表格
- (void)excelView:(MGExcelView *)excelView didScrollWithContentOffset:(CGPoint)offset;

@end


/**
 表格索引
 */
@interface MGExcelIndexPath : NSObject

@property (nonatomic, assign) NSInteger section; //分区
@property (nonatomic, assign) NSInteger row; //行
@property (nonatomic, assign) NSInteger column; //列

+ (instancetype)indexWithSection:(NSInteger)section Row:(NSInteger)row column:(NSInteger)column;

@end

