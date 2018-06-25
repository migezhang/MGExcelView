//
//  MGCollectionViewExcelLayout.h
//  HBB_BuyerProject
//
//  Created by mige on 2018/1/4.
//  Copyright © 2018年 CHENG DE LUO. All rights reserved.
//
/**
 *  UICollectionView表格布局
 *
 *  @author mige
 */
#import <UIKit/UIKit.h>

@class MGCollectionViewExcelLayout;
@protocol MGCollectionViewExcelLayoutDelegate <NSObject>

@required
//返回行高
- (CGFloat)excelLayout:(MGCollectionViewExcelLayout *)excelLayout rowHeightForItemAtRow:(NSInteger)row;

//返回列宽
- (CGFloat)excelLayout:(MGCollectionViewExcelLayout *)excelLayout columnWidthForItemAtColumn:(NSInteger)column;

@optional
//设置锁定的列数
- (NSInteger)lockColumnsInExcelLayout:(MGCollectionViewExcelLayout *)excelLayout;

@end

@interface MGCollectionViewExcelLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MGCollectionViewExcelLayoutDelegate> delegate;

@property (nonatomic, assign) BOOL isFillWidth; //是否填充宽度，即总列宽小于collectionView宽度时，是否让总列宽等于视图宽度，默认YES

/**
 刷新布局
 */
- (void)refreshLayout;

@end
