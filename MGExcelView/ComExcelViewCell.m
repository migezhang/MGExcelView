//
//  ComExcelViewCell.m
//  MGExcelView
//
//  Created by mige on 2018/3/31.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "ComExcelViewCell.h"
#import "ComExcelDetailCell.h"
#import "HbbScrollIndicatorView.h"

@interface ComExcelViewCell () <MGExcelViewDelegate, MGExcelViewDataSource>

@property (nonatomic, strong) HbbScrollIndicatorView *scrollIndicatorView; //指示视图

@end

@implementation ComExcelViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.excelView.delegate = self;
    self.excelView.dataSource = self;
    [self.excelView refreshData];
    
    self.scrollIndicatorView = [[HbbScrollIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.excelView.frame.size.width, 80)];
    [self.excelView addSubview:self.scrollIndicatorView];
    
    CGSize contentSize = CGSizeMake(self.excelView.contentSize.width, 0);
    [self.scrollIndicatorView showIndicatorAtContentSize:contentSize withContentOffset:CGPointZero];
}


- (void)layoutSubviews{
    [super layoutSubviews];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *cell = [self.excelView.tableView cellForRowAtIndexPath:indexPath];
    CGFloat rowHeight = [self.excelView.delegate excelView:self.excelView rowHeightInSection:0 forItemAtRow:0];
    self.scrollIndicatorView.frame = CGRectMake(0, 0, self.excelView.frame.size.width, rowHeight);
    [self.excelView bringSubviewToFront:self.scrollIndicatorView];
}

#pragma mark - MGExcelViewDataSource
//返回列数
- (NSInteger)numbersOfColumnWithExcelView:(MGExcelView *)excelView{
    return 10;
}

//返回行数
- (NSInteger)excelView:(MGExcelView *)excelView numbersOfRowInSection:(NSInteger)section{
    return 15;
}

//注册CollectionView重用Cell
- (void)excelView:(MGExcelView *)excelView registerCellWithCollectionView:(UICollectionView *)collectionView{
    [collectionView registerNib:[UINib nibWithNibName:@"ComExcelHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"ComExcelHeaderCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"ComExcelDetailCell" bundle:nil] forCellWithReuseIdentifier:@"ComExcelDetailCell"];
}

//返回表格样式
- (UICollectionViewCell *)excelView:(MGExcelView *)excelView cellForExcelAtIndex:(MGExcelIndexPath *)index withCollectionView:(UICollectionView *)collectionView{
    UICollectionViewCell *cell = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index.column inSection:0];
    ComExcelDetailCell *detailCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComExcelDetailCell" forIndexPath:indexPath];
    detailCell.backgroundColor = [UIColor whiteColor];
    detailCell.detailLabel.text = [NSString stringWithFormat:@"详情-%ld-%ld-%ld", self.currentIndexPath.row, index.row, index.column];
    cell = detailCell;
    
//    //设置单元行颜色的间隔的控制
//    if (index.row % 2 == 0) {
//        [cell setBackgroundColor:[UIColor whiteColor]];
//    } else {
//        [cell setBackgroundColor:[UIColor lightGrayColor]];
//    }
    
    return cell;
}

//设置锁定的列数
- (NSInteger)numbersOfLockColumnsWithExcelView:(MGExcelView *)excelView{
    return 1;
}

#pragma mark - MGExcelViewDelegate
//返回列宽
- (CGFloat)excelView:(MGExcelView *)excelView columnWidthForItemAtColumn:(NSInteger)column{
    CGFloat columnWidth = 80;
    return columnWidth;
}

//返回行高
- (CGFloat)excelView:(MGExcelView *)excelView rowHeightInSection:(NSInteger)section forItemAtRow:(NSInteger)row{
    return 80;
}

//点击表格项
- (void)excelView:(MGExcelView *)excelView didSelectItemAtIndex:(MGExcelIndexPath *)index{
    NSLog(@"didSelectItemAtIndex----->>> (%ld, %ld, %ld)", index.section, index.row, index.column);
}

//滑动表格
- (void)excelView:(MGExcelView *)excelView didScrollWithContentOffset:(CGPoint)offset{
    //    NSLog(@"didScrollWithContentOffset----->>> (%g, %g)", offset.x, offset.y);
    CGSize contentSize = CGSizeMake(excelView.contentSize.width, 0);
    [self.scrollIndicatorView showIndicatorAtContentSize:contentSize withContentOffset:offset];
}


@end
