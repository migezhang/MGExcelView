//
//  MGExcelTableViewCell.h
//  MGExcelViewDemo
//
//  Created by mige on 2018/2/12.
//  Copyright © 2018年 mige. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGExcelTableViewCell;

@protocol MGExcelTableViewCellDataSource <NSObject>

@required
//返回列数
- (NSInteger)numbersOfColumnAtExcelTableViewCell:(MGExcelTableViewCell *)cell;

//注册CollectionView重用Cell
- (void)excelTableViewCell:(MGExcelTableViewCell *)cell registerCellWithCollectionView:(UICollectionView *)collectionView;

//返回每列样式
- (UICollectionViewCell *)excelTableViewCell:(MGExcelTableViewCell *)cell cellForItemAtColumn:(NSInteger)column withCollectionView:(UICollectionView *)collectionView;

@optional
//设置锁定的列数
- (NSInteger)numbersOfLockColumnAtExcelTableViewCell:(MGExcelTableViewCell *)cell;

@end


@protocol MGExcelTableViewCellDelegate <NSObject>

@required
//返回列宽
- (CGFloat)excelTableViewCell:(MGExcelTableViewCell *)cell columnWidthForItemAtColumn:(NSInteger)column;

@optional
//点击列
- (void)excelTableViewCell:(MGExcelTableViewCell *)cell didSelectItemAtColumn:(NSInteger)column;

//滑动行
- (void)excelTableViewCell:(MGExcelTableViewCell *)cell scrollViewDidScroll:(UIScrollView *)scrollView;

@end


@interface MGExcelTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MGExcelTableViewCellDataSource> dataSource;
@property (nonatomic, weak) id<MGExcelTableViewCellDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView; //网格视图

@property (nonatomic, assign) BOOL isFillWidth; //是否填充宽度

/**
 刷新数据
 */
- (void)refreshData;

@end
