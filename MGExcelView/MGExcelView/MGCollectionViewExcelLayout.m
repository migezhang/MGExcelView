//
//  MGCollectionViewExcelLayout.m
//  HBB_BuyerProject
//
//  Created by mige on 2018/1/4.
//  Copyright © 2018年 CHENG DE LUO. All rights reserved.
//

#import "MGCollectionViewExcelLayout.h"

@interface MGCollectionViewExcelLayout ()

@property (nonatomic, assign) NSInteger lockColumns; //锁定列数
@property (nonatomic, strong) NSArray *columnWidthArray; //列宽数组
@property (nonatomic, strong) NSArray *rowHeightArray; //行高数组

@property (nonatomic, strong) NSMutableArray *itemSizeArray; //记录每个item的宽高
@property (nonatomic, strong) NSMutableArray *itemAttrArray; //记录item的布局
@property (nonatomic, assign) CGSize contentSize; //实际内容大小

@end

@implementation MGCollectionViewExcelLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isFillWidth = YES;
        self.lockColumns = 0;
        self.columnWidthArray = [NSArray array];
        self.rowHeightArray = [NSArray array];
    }
    return self;
}

/**
 刷新布局
 */
- (void)refreshLayout{
    //清空数据
    [self.itemAttrArray removeAllObjects];
    [self.itemSizeArray removeAllObjects];
    self.columnWidthArray = [NSArray array];
    self.rowHeightArray = [NSArray array];
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y) animated:NO];

    //初始化数据
    [self initData];

    //重新生成数据
    if (self.isFillWidth == YES) {
        [self recalculateColumnWidth];
    }
    [self generateItemSizeArray];
    [self calculateContentSize];
}

#pragma mark - 数据相关
/**
 初始化数据
 */
- (void)initData{
    //锁定列数
    if (self.delegate && [self.delegate respondsToSelector:@selector(lockColumnsInExcelLayout:)]) {
        self.lockColumns = [self.delegate lockColumnsInExcelLayout:self];
    }

    //行数
    CGFloat rowCount = self.collectionView.numberOfSections;

    //列数
    CGFloat columnCount = 0;
    if (rowCount > 0) {
        columnCount = [self.collectionView numberOfItemsInSection:0];
    }

    //行高数组
    NSMutableArray *rowHeightArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger row = 0; row < rowCount; row++) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(excelLayout:rowHeightForItemAtRow:)]) {
            CGFloat rowHeight = [self.delegate excelLayout:self rowHeightForItemAtRow:row];
            [rowHeightArr addObject:[NSNumber numberWithFloat:rowHeight]];
        }
    }
    self.rowHeightArray = rowHeightArr;

    //列宽数组
    NSMutableArray *columnWidthArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger column = 0; column < columnCount; column++) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(excelLayout:columnWidthForItemAtColumn:)]) {
            CGFloat columnWidth = [self.delegate excelLayout:self columnWidthForItemAtColumn:column];
            [columnWidthArr addObject:[NSNumber numberWithFloat:columnWidth]];
        }
    }
    self.columnWidthArray = columnWidthArr;
}

/**
 生成item的宽高数组
 */
- (void)generateItemSizeArray{
    self.itemSizeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger row = 0; row < self.rowHeightArray.count; row++) {
        NSMutableArray *sizeArr = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger column = 0; column < self.columnWidthArray.count; column++) {
            CGFloat width = [self.columnWidthArray[column] floatValue];
            CGFloat height = [self.rowHeightArray[row] floatValue];
            CGSize size = CGSizeMake(width, height);
            NSValue *sizeValue = [NSValue valueWithCGSize:size];
            [sizeArr addObject:sizeValue];
        }
        [self.itemSizeArray addObject:sizeArr];
    }
}

#pragma mark - 计算相关
/**
 重算列宽
 */
- (void)recalculateColumnWidth{
    CGFloat maxWidth = self.collectionView.frame.size.width;
    CGFloat contentWidth = 0;
    for (NSInteger column = 0; column < self.columnWidthArray.count; column++) {
        CGFloat width = [self.columnWidthArray[column] floatValue];
        contentWidth += width;
    }
    
    //如果collectionView宽度大于表格总宽度，按比例分配差额宽度到每一列
    if (maxWidth > contentWidth && contentWidth != 0) {
        CGFloat offset = maxWidth - contentWidth;
        NSMutableArray *columnWidthArr = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger column = 0; column < self.columnWidthArray.count; column++) {
            CGFloat columnWidth = [self.columnWidthArray[column] floatValue];
            CGFloat interval = offset * (columnWidth / contentWidth);
            CGFloat width = columnWidth + interval;
            [columnWidthArr addObject:[NSNumber numberWithFloat:width]];
        }
        self.columnWidthArray = columnWidthArr;
    }

}

/**
 计算内容宽高
 */
- (void)calculateContentSize{
    CGFloat contentWidth = 0;
    CGFloat contentHeigt = 0;
    
    //计算总宽度
    for (NSInteger column = 0; column < self.columnWidthArray.count; column++) {
        CGFloat width = [self.columnWidthArray[column] floatValue];
        contentWidth += width;
    }
    
    //计算总高度
    for (NSInteger row = 0; row < self.rowHeightArray.count; row++) {
        CGFloat height = [self.rowHeightArray[row] floatValue];
        contentHeigt += height;
    }
    
    self.contentSize = CGSizeMake(contentWidth, contentHeigt);
}

#pragma mark - 布局相关
/**
 生成初始化布局信息数组
 */
- (void)generateLayoutAttributesArray{
    NSInteger column = 0;//列
    CGFloat xOffset = 0.0;//X方向的偏移量
    CGFloat yOffset = 0.0;//Y方向的偏移量
    self.itemAttrArray = [NSMutableArray arrayWithCapacity:0];
    CGFloat rowCount = self.rowHeightArray.count; //总行数
    CGFloat columnCount = self.columnWidthArray.count; //总列数
    for (NSInteger section = 0; section < rowCount; section++) {
        NSMutableArray *sectionAttrArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger row = 0; row < columnCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            //设置frame
            CGSize itemSize = [self.itemSizeArray[section][row] CGSizeValue];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            
            //设置列的X坐标
            if (row < self.lockColumns) {
                CGRect frame = attributes.frame;
                CGFloat offsetX = 0;
                if (index > 0) {
                    for (int i = 0; i < row; i++) {
                        offsetX += [self.columnWidthArray[i] floatValue];
                    }
                }
                frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                attributes.frame = frame;
            }
            
            //固定行列的滚动
            if (section == 0 && row < self.lockColumns) {
                attributes.zIndex = NSIntegerMax;
            } else if (section == 0 || row < self.lockColumns) {
                attributes.zIndex = NSIntegerMax - 1;
            }
            
            //保存布局信息
            [sectionAttrArray addObject:attributes];
            
            //坐标计算
            column ++;
            xOffset += itemSize.width;
            
            if (column == columnCount) {
                column = 0;
                xOffset = 0;
                yOffset += itemSize.height;
            }
        }
        
        //保存布局信息
        [self.itemAttrArray addObject:sectionAttrArray];
    }
}

/**
 刷新布局信息
 */
- (void)refreshLayoutAttributes{
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row++) {
            if (section != 0 && row >= self.lockColumns) {
                continue;
            }
            
            UICollectionViewLayoutAttributes *attributes = self.itemAttrArray[section][row];
            
            //固定第一行的Y坐标
            if (section == 0) {
                CGRect frame = attributes.frame;
                frame.origin.y = self.collectionView.contentOffset.y;
                attributes.frame = frame;
            }
            
            //设置列的X坐标
            if (row < self.lockColumns) {
                CGRect frame = attributes.frame;
                CGFloat offsetX = 0;
                if (index > 0) {
                    for (int i = 0; i < row; i++) {
                        offsetX += [self.columnWidthArray[i] floatValue];
                    }
                }
                frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                attributes.frame = frame;
            }
        }
    }
}

#pragma mark - override
/**
 计算布局
 */
-(void)prepareLayout{
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.bounces = NO;
    
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    if (self.itemAttrArray.count == 0) {
        //生成初始化布局信息数组
        [self generateLayoutAttributesArray];
        
    } else {
        //刷新布局信息
        [self refreshLayoutAttributes];
    }
}

/**
 返回collectionView内容区的宽度和高度
 */
-(CGSize)collectionViewContentSize{
    return self.contentSize;
}

/**
 返回指定indexPath Cell的布局信息
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemAttrArray[indexPath.section][indexPath.row];
}

/**
 返回该区域内所有元素的布局信息
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:0];
    for (NSArray *section in self.itemAttrArray) {
        NSArray *filterArr = [section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            CGRect frame = [evaluatedObject frame];
            return CGRectIntersectsRect(rect, frame);
        }]];
        [attributes addObjectsFromArray:filterArr];
    }
    return attributes;
}

/**
 决定是否需要更新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end

