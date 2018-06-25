//
//  MGExcelTableViewCell.m
//  MGExcelViewDemo
//
//  Created by mige on 2018/2/12.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "MGExcelTableViewCell.h"
#import "MGCollectionViewExcelLayout.h"

@interface MGExcelTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, MGCollectionViewExcelLayoutDelegate>

@property (nonatomic, assign) NSInteger columns; //列数
@property (nonatomic, assign) NSInteger lockColumns; //固定的列数

@property (nonatomic, strong) MGCollectionViewExcelLayout *layout; //表格布局

@end

@implementation MGExcelTableViewCell

#pragma mark - override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - 初始化视图
/**
 初始化视图
 */
- (void)setupView{
    self.layout = [[MGCollectionViewExcelLayout alloc] init];
    self.layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:self.layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

#pragma mark - 数据相关
/**
 刷新数据
 */
- (void)refreshData{
    //初始化数据
    [self initData];
    
    //防止刷新时，阻塞主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新数据
        [self.collectionView reloadData];
        
        //刷新布局
        self.layout.isFillWidth = self.isFillWidth;
        [self.layout refreshLayout];
    });
}


/**
 初始化数据
 */
- (void)initData{
    self.columns = [self getColumns];
    self.lockColumns = [self getLockColumns];
    [self registerCollectionViewCell];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回列数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.columns;
}

//表格样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(excelTableViewCell:cellForItemAtColumn:withCollectionView:)]) {
        //如果列数经常变动，会导致当前列大于列数
        NSInteger column = indexPath.row;
        if (column >= self.columns && self.columns > 0) {
            column = self.columns - 1;
        }
        cell = [self.dataSource excelTableViewCell:self cellForItemAtColumn:column withCollectionView:collectionView];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelTableViewCell:didSelectItemAtColumn:)]) {
        [self.delegate excelTableViewCell:self didSelectItemAtColumn:indexPath.row];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelTableViewCell:scrollViewDidScroll:)]) {
        [self.delegate excelTableViewCell:self scrollViewDidScroll:scrollView];
    }
}

#pragma mark - MGExcelCollectionLayoutDelegate
//返回行高
- (CGFloat)excelLayout:(MGCollectionViewExcelLayout *)excelLayout rowHeightForItemAtRow:(NSInteger)row{
    CGFloat rowHeight = self.frame.size.height;
    return rowHeight;
}

//返回列宽
- (CGFloat)excelLayout:(MGCollectionViewExcelLayout *)excelLayout columnWidthForItemAtColumn:(NSInteger)column{
    CGFloat columnWidth = [self getColumnWidthWithColumn:column];
    return columnWidth;
}

//设置锁定的列数
- (NSInteger)lockColumnsInExcelLayout:(MGCollectionViewExcelLayout *)excelLayout{
    return self.lockColumns;
}

#pragma mark - 调用代理方法
/**
 获取列数
 */
- (NSInteger)getColumns{
    NSInteger columns = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numbersOfColumnAtExcelTableViewCell:)]) {
        columns = [self.dataSource numbersOfColumnAtExcelTableViewCell:self];
    }
    return columns;
}

/**
 获取锁定的列数
 */
- (NSInteger)getLockColumns{
    CGFloat lockColumns = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numbersOfLockColumnAtExcelTableViewCell:)]) {
        lockColumns = [self.dataSource numbersOfLockColumnAtExcelTableViewCell:self];
    }
    return lockColumns;
}

/**
 获取列宽
 */
- (CGFloat)getColumnWidthWithColumn:(NSInteger)column{
    CGFloat columnWidth = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelTableViewCell:columnWidthForItemAtColumn:)]) {
        columnWidth = [self.delegate excelTableViewCell:self columnWidthForItemAtColumn:column];
    }
    return columnWidth;
}

/**
 collectionView注册重用
 */
- (void)registerCollectionViewCell{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(excelTableViewCell:registerCellWithCollectionView:)]) {
        [self.dataSource excelTableViewCell:self registerCellWithCollectionView:self.collectionView];
    }
}

@end

