//
//  MGExcelView.m
//  MGExcelViewDemo
//
//  Created by mige on 2018/2/12.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "MGExcelView.h"
#import "MGSectionHeaderView.h"

@interface MGExcelView () <UITableViewDelegate, UITableViewDataSource, MGExcelTableViewCellDataSource, MGExcelTableViewCellDelegate, MGSectionHeaderViewDelegate>

@property (nonatomic, assign) NSInteger columns; //列数
@property (nonatomic, assign) NSInteger lockColumns; //固定的列数
@property (nonatomic, assign) NSInteger sections; //分区数

@property (nonatomic, assign) CGFloat excelHeaderViewHeight; //表头视图高度
@property (nonatomic, assign) CGSize excelViewContentSize; //表格视图内容区域大小

@property (nonatomic, assign) CGFloat scrollX; //表格横向滑动记录

@end

@implementation MGExcelView

@synthesize headerCell = _headerCell;
@synthesize contentOffset = _contentOffset;

#pragma mark - override
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //更新表头布局
    [self layoutHeaderViewWithOffSetY:self.tableView.contentOffset.y];
    
    //更新视图frame
    [self updateViewsFrame];
}

#pragma mark - public methods
/**
 转换路径
 */
- (NSIndexPath *)indexPathWithExcelIndexColumn:(NSInteger)column{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:column inSection:0];
    return indexPath;
}

/**
 刷新数据
 */
- (void)refreshData{
    //初始化数据
    [self initData];
    
    self.headerCell.isFillWidth = self.isFillWidth;
    [self.headerCell refreshData];
    [self.tableView reloadData];
}

#pragma mark - getter && setter
- (CGSize)contentSize{
    return self.excelViewContentSize;
}

- (void)setContentOffset:(CGPoint)contentOffset{
    _contentOffset = contentOffset;
    self.scrollX = contentOffset.x;
    self.tableView.contentOffset = CGPointMake(0, contentOffset.y);
    [self scrollAllCells];
}

- (CGPoint)contentOffset{
    CGPoint contentOffset = CGPointMake(self.scrollX, self.tableView.contentOffset.y);
    return contentOffset;
}

#pragma mark - 初始化视图
/**
 初始化视图
 */
- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    
    self.isFillWidth = YES;
    
    //表格视图
    [self setupExcelTableView];
    
    //表头视图
    [self setupExcelHeaderView];
}

/**
 设置表头视图
 */
- (void)setupExcelHeaderView{
    _headerCell = [[MGExcelTableViewCell alloc] init];
    self.headerCell.frame = CGRectMake(0, 0, self.frame.size.width, self.excelHeaderViewHeight);
    self.headerCell.dataSource = self;
    self.headerCell.delegate = self;
    [self addSubview:self.headerCell];
}

/**
 设置表格视图
 */
- (void)setupExcelTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MGExcelTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MGExcelTableViewCell class])];
    [self.tableView registerClass:[MGSectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MGSectionHeaderView class])];
    [self addSubview:self.tableView];
}

#pragma mark - 数据相关
/**
 初始化数据
 */
- (void)initData{
    self.sections = [self getSections];
    self.columns = [self getColumns];
    self.lockColumns = [self getLockColumns];
    self.excelHeaderViewHeight = [self getExcelHeaderViewHeight];
    self.excelViewContentSize = [self setupExcelViewContentSize];
}

/**
 设置ContentSize
 */
- (CGSize)setupExcelViewContentSize{
    CGFloat width = [self getExcelTotalWidth];
    CGFloat height = [self getExcelTotalHeight];
    CGSize contentSize = CGSizeMake(width, height);
    return contentSize;
}

#pragma mark - UITableViewDataSource
//返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = [self getRowsInSection:section];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MGExcelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MGExcelTableViewCell class]) forIndexPath:indexPath];
    cell.dataSource = self;
    cell.delegate = self;
    cell.isFillWidth = self.isFillWidth;
    [cell refreshData];
    return cell;
}

#pragma mark - UITableViewDelegate
//返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = [self getRowHeightInSection:indexPath.section atRow:indexPath.row];
    return rowHeight;
}

//返回表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = [self getHeaderViewHeightInSection:section];
    return headerHeight;
}

//设置表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MGSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MGSectionHeaderView class])];
    sectionHeaderView.headerView = [self getHeaderViewInSection:section];
    sectionHeaderView.contentWidth = self.excelViewContentSize.width;
    sectionHeaderView.delegate = self;
    sectionHeaderView.scrollView.contentOffset = CGPointMake(self.scrollX, 0);
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MGExcelTableViewCell *excelCell = (MGExcelTableViewCell *)cell;
    excelCell.collectionView.contentOffset = CGPointMake(self.scrollX, 0);
}

#pragma mark - MGExcelTableViewCellDataSource
//返回列数
- (NSInteger)numbersOfColumnAtExcelTableViewCell:(MGExcelTableViewCell *)cell{
    return self.columns;
}

//注册CollectionView重用Cell
- (void)excelTableViewCell:(MGExcelTableViewCell *)cell registerCellWithCollectionView:(UICollectionView *)collectionView{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(excelView:registerCellWithCollectionView:)]) {
        [self.dataSource excelView:self registerCellWithCollectionView:collectionView];
    }
}

//返回表格样式
- (UICollectionViewCell *)excelTableViewCell:(MGExcelTableViewCell *)cell cellForItemAtColumn:(NSInteger)column withCollectionView:(UICollectionView *)collectionView{
    UICollectionViewCell *clCell = nil;
    if (cell == self.headerCell) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(excelView:cellForExcelHeaderViewAtColumn:withCollectionView:)]) {
            clCell = [self.dataSource excelView:self cellForExcelHeaderViewAtColumn:column withCollectionView:collectionView];
        }
    } else {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(excelView:cellForExcelAtIndex:withCollectionView:)]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            MGExcelIndexPath *index = [MGExcelIndexPath indexWithSection:indexPath.section Row:indexPath.row column:column];
            clCell = [self.dataSource excelView:self cellForExcelAtIndex:index withCollectionView:collectionView];
        }
    }
    return clCell;
}

//设置锁定的列数
- (NSInteger)numbersOfLockColumnAtExcelTableViewCell:(MGExcelTableViewCell *)cell{
    return self.lockColumns;
}

#pragma mark - MGExcelTableViewCellDelegate
//返回列宽
- (CGFloat)excelTableViewCell:(MGExcelTableViewCell *)cell columnWidthForItemAtColumn:(NSInteger)column{
    CGFloat columnWidth = [self getColumnWidthWithColumn:column];
    return columnWidth;
}

//点击列
- (void)excelTableViewCell:(MGExcelTableViewCell *)cell didSelectItemAtColumn:(NSInteger)column{
    if (cell == self.headerCell) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(excelView:didSelectHeaderItemAtColumn:)]) {
            [self.delegate excelView:self didSelectHeaderItemAtColumn:column];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(excelView:didSelectItemAtIndex:)]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            MGExcelIndexPath *index = [MGExcelIndexPath indexWithSection:indexPath.section Row:indexPath.row column:column];
            [self.delegate excelView:self didSelectItemAtIndex:index];
        }
    }
}

//滑动行
- (void)excelTableViewCell:(MGExcelTableViewCell *)cell scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.scrollX = [self getCurrentScrollXWithOffsetX:offsetX];
    [self scrollAllCells];
    
    //设置代理
    CGPoint offset = CGPointMake(self.scrollX, self.tableView.contentOffset.y);
    [self setupScrollDelegateWithOffset:offset];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    [self layoutHeaderViewWithOffSetY:offsetY];
    
    //设置代理
    CGPoint offset = CGPointMake(self.scrollX, offsetY);
    [self setupScrollDelegateWithOffset:offset];
}

#pragma mark - MGSectionHeaderViewDelegate
- (void)sectionHeaderView:(MGSectionHeaderView *)sectionHeaderView scrollViewDidScroll:(UIScrollView *)scrollView{
    self.scrollX = scrollView.contentOffset.x;
    [self scrollAllCells];
    
    //设置代理
    CGPoint offset = CGPointMake(self.scrollX, self.tableView.contentOffset.y);
    [self setupScrollDelegateWithOffset:offset];
}

#pragma mark - Tool Methods
/**
 布局表头视图
 */
- (void)layoutHeaderViewWithOffSetY:(CGFloat)offsetY{
    CGFloat headHeight = self.headerCell.frame.size.height;
    CGRect tableViewRect = self.tableView.frame;
    if (offsetY < 0) {
        tableViewRect.origin.y = 0;
        tableViewRect.size.height = self.frame.size.height;
        self.tableView.tableHeaderView = self.headerCell;
        
    } else if (offsetY > 0) {
        [self.headerCell removeFromSuperview];
        tableViewRect.origin.y = headHeight;
        tableViewRect.size.height = self.frame.size.height - headHeight;
        self.tableView.tableHeaderView = nil;
        [self addSubview:self.headerCell];
    }
    self.tableView.frame = tableViewRect;
}

/**
 更新视图frame
 */
- (void)updateViewsFrame{
    //更新表头视图
    CGRect headerViewRect = self.headerCell.frame;
    headerViewRect.size.height = self.excelHeaderViewHeight;
    headerViewRect.size.width = self.frame.size.width;
    self.headerCell.frame = headerViewRect;
    
    //更新tableView
    CGRect tableViewRect = self.tableView.frame;
    tableViewRect.size.width = self.frame.size.width;
    if (self.tableView.tableHeaderView == nil) {
        tableViewRect.origin.y = self.excelHeaderViewHeight;
        tableViewRect.size.height = self.frame.size.height - self.excelHeaderViewHeight;
    } else {
        tableViewRect.origin.y = 0;
        tableViewRect.size.height = self.frame.size.height;
    }
    self.tableView.frame = tableViewRect;
}

/**
 获取表格总宽度
 */
- (CGFloat)getExcelTotalWidth{
    CGFloat totalWidth = 0;
    for (NSInteger i = 0; i < self.columns; i++) {
        CGFloat columnWidth = [self getColumnWidthWithColumn:i];
        totalWidth += columnWidth;
    }
    
    if (self.isFillWidth == YES && totalWidth < self.frame.size.width) {
        totalWidth = self.frame.size.width;
    }
    return totalWidth;
}

/**
 获取表格总高度
 */
- (CGFloat)getExcelTotalHeight{
    CGFloat totalHeight = 0;
    
    //计算全部行高
    CGFloat allRowHeight = 0;
    for (NSInteger section = 0; section < self.sections; section++) {
        NSInteger rows = [self getRowsInSection:section];
        for (NSInteger row = 0; row < rows; row++) {
            CGFloat rowHeight = [self getRowHeightInSection:section atRow:row];
            allRowHeight += rowHeight;
        }
    }
    
    //计算全部分区表头高度
    CGFloat allHeaderHeight = 0;
    for (NSInteger section = 0; section < self.sections; section++) {
        CGFloat headerHeight = [self getHeaderViewHeightInSection:section];
        allHeaderHeight += headerHeight;
    }
    
    totalHeight = allRowHeight + allHeaderHeight + self.excelHeaderViewHeight;
    
    return totalHeight;
}

/**
 获取当前滑动位置
 */
- (CGFloat)getCurrentScrollXWithOffsetX:(CGFloat)offsetX{
    CGFloat scrollX = self.scrollX;
    CGFloat diffX = self.excelViewContentSize.width - self.frame.size.width;
    CGFloat limitX = 1;
    if (diffX > 5) {
        limitX = 5;
    }
    if (offsetX > 0 && offsetX < limitX) {
        scrollX = 0;
    } else if (offsetX > limitX) {
        scrollX = offsetX;
    }
    return scrollX;
}

/**
 滑动所有视图
 */
- (void)scrollAllCells{
    self.headerCell.collectionView.contentOffset = CGPointMake(self.scrollX, 0);
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        MGExcelTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell != nil) {
            cell.collectionView.contentOffset = CGPointMake(self.scrollX, 0);
        }
        
        MGSectionHeaderView *headerView = (MGSectionHeaderView *)[self.tableView headerViewForSection:indexPath.section];
        if (headerView != nil) {
            headerView.scrollView.contentOffset = CGPointMake(self.scrollX, 0);
        }
    }
}

#pragma mark - 调用代理方法
/**
 获取分区数
 */
- (NSInteger)getSections{
    CGFloat sections = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numbersOfSectionWithExcelView:)]) {
        sections = [self.dataSource numbersOfSectionWithExcelView:self];
    }
    return sections;
}

/**
 获取列数
 */
- (NSInteger)getColumns{
    CGFloat columns = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numbersOfColumnWithExcelView:)]) {
        columns = [self.dataSource numbersOfColumnWithExcelView:self];
    }
    return columns;
}

/**
 获取锁定的列数
 */
- (NSInteger)getLockColumns{
    NSInteger lockColumns = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numbersOfLockColumnsWithExcelView:)]) {
        lockColumns = [self.dataSource numbersOfLockColumnsWithExcelView:self];
    }
    return lockColumns;
}

/**
 获取行数
 */
- (NSInteger)getRowsInSection:(NSInteger)section{
    CGFloat rows = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(excelView:numbersOfRowInSection:)]) {
        rows = [self.dataSource excelView:self numbersOfRowInSection:section];
    }
    return rows;
}

/**
 获取行高
 */
- (CGFloat)getRowHeightInSection:(NSInteger)section atRow:(NSInteger)row{
    CGFloat rowHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelView:rowHeightInSection:forItemAtRow:)]) {
        rowHeight = [self.delegate excelView:self rowHeightInSection:section forItemAtRow:row];
    }
    return rowHeight;
}

/**
 获取列宽
 */
- (CGFloat)getColumnWidthWithColumn:(NSInteger)column{
    CGFloat columnWidth = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelView:columnWidthForItemAtColumn:)]) {
        columnWidth = [self.delegate excelView:self columnWidthForItemAtColumn:column];
    }
    return columnWidth;
}

/**
 获取表头视图高度
 */
- (CGFloat)getExcelHeaderViewHeight{
    CGFloat headerHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelHeaderViewHeightWithExcelView:)]) {
        headerHeight = [self.delegate excelHeaderViewHeightWithExcelView:self];
    }
    return headerHeight;
}

/**
 获取分区表头视图高度
 */
- (CGFloat)getHeaderViewHeightInSection:(NSInteger)section{
    CGFloat headerHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelView:headerHeightInSection:)]) {
        headerHeight = [self.delegate excelView:self headerHeightInSection:section];
    }
    return headerHeight;
}

/**
 获取分区表头视图
 */
- (UIView *)getHeaderViewInSection:(NSInteger)section{
    UIView *headerView = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(excelView:headerViewInSection:)]) {
        headerView = [self.dataSource excelView:self headerViewInSection:section];
    }
    return headerView;
}

/**
 设置表格滑动代理
 */
- (void)setupScrollDelegateWithOffset:(CGPoint)offset{
    if (self.delegate && [self.delegate respondsToSelector:@selector(excelView:didScrollWithContentOffset:)]) {
        [self.delegate excelView:self didScrollWithContentOffset:offset];
    }
}

@end


#pragma mark - 表格索引
@implementation MGExcelIndexPath

+ (instancetype)indexWithSection:(NSInteger)section Row:(NSInteger)row column:(NSInteger)column{
    MGExcelIndexPath *indexPath = [[MGExcelIndexPath alloc] init];
    indexPath.section = section;
    indexPath.row = row;
    indexPath.column = column;
    return indexPath;
}

@end

