//
//  MGExcelViewVC.m
//  MGExcelView
//
//  Created by mige on 2018/3/29.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "MGExcelViewVC.h"
#import "MGExcelView.h"
#import "MJRefresh.h"
#import "ComExcelHeaderCell.h"
#import "ComExcelDetailCell.h"
#import "HbbScrollIndicatorView.h"

@interface MGExcelViewVC () <MGExcelViewDelegate, MGExcelViewDataSource>

@property (weak, nonatomic) IBOutlet MGExcelView *excelView;
@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger sections;

@property (nonatomic, strong) HbbScrollIndicatorView *scrollIndicatorView; //指示视图

@end

@implementation MGExcelViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rows = 5;
    self.sections = 5;
    self.excelView.delegate = self;
    self.excelView.dataSource = self;
    [self.excelView refreshData];
    
    self.excelView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.excelView.tableView.mj_header endRefreshing];
            self.sections = 5;
            [self.excelView refreshData];
        });
    }];

    self.excelView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.excelView.tableView.mj_footer endRefreshing];
            self.sections += 1;
            [self.excelView refreshData];
        });
    }];
    
    self.scrollIndicatorView = [[HbbScrollIndicatorView alloc] initWithFrame:self.excelView.headerCell.bounds];
    [self.excelView.headerCell addSubview:self.scrollIndicatorView];
}

#pragma mark - MGExcelViewDataSource
//返回列数
- (NSInteger)numbersOfColumnWithExcelView:(MGExcelView *)excelView{
    return 16;
}

//返回行数
- (NSInteger)excelView:(MGExcelView *)excelView numbersOfRowInSection:(NSInteger)section{
    return self.rows;
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
    if (index.column == 0) {
        ComExcelHeaderCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComExcelHeaderCell" forIndexPath:indexPath];
        headerCell.titleLabel.text = [NSString stringWithFormat:@"标题-%ld-%ld-%ld", index.section, index.row, index.column];
        cell = headerCell;
        
    } else {
        ComExcelDetailCell *detailCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComExcelDetailCell" forIndexPath:indexPath];
        detailCell.detailLabel.text = [NSString stringWithFormat:@"详情-%ld-%ld-%ld", index.section, index.row, index.column];
        cell = detailCell;
    }
    
    //设置单元行颜色的间隔的控制
    if (index.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor whiteColor]];
    } else {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return cell;
}

//返回分区数
- (NSInteger)numbersOfSectionWithExcelView:(MGExcelView *)excelView{
    return self.sections;
}

//返回表头视图样式
- (UICollectionViewCell *)excelView:(MGExcelView *)excelView cellForExcelHeaderViewAtColumn:(NSInteger)column withCollectionView:(UICollectionView *)collectionView{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:column inSection:0];
    ComExcelDetailCell *detailCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComExcelDetailCell" forIndexPath:indexPath];
    [detailCell setBackgroundColor:[UIColor whiteColor]];
    detailCell.detailLabel.text = [NSString stringWithFormat:@"表头-%ld", column];
    if (column == 0) {
        detailCell.detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return detailCell;
}

//返回分区头部视图
- (UIView *)excelView:(MGExcelView *)excelView headerViewInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, excelView.frame.size.width, 44)];
    headerView.backgroundColor = [UIColor cyanColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[NSString stringWithFormat:@"Botton-%ld", section] forState:UIControlStateNormal];
    [headerView addSubview:button];
    return headerView;
}

//设置锁定的列数
- (NSInteger)numbersOfLockColumnsWithExcelView:(MGExcelView *)excelView{
    return 1;
}

- (void)onButtonClick:(UIButton *)btn{
    NSLog(@"---->>> %@", btn.currentTitle);
}

#pragma mark - MGExcelViewDelegate
//返回列宽
- (CGFloat)excelView:(MGExcelView *)excelView columnWidthForItemAtColumn:(NSInteger)column{
    CGFloat columnWidth = 60;
    if (column == 0) {
        columnWidth = 80;
    }
    return columnWidth;
}

//返回行高
- (CGFloat)excelView:(MGExcelView *)excelView rowHeightInSection:(NSInteger)section forItemAtRow:(NSInteger)row{
    return 60;
}

//返回表头高度
- (CGFloat)excelHeaderViewHeightWithExcelView:(MGExcelView *)excelView{
    return 35;
}

//返回分区头部视图高度
- (CGFloat)excelView:(MGExcelView *)excelView headerHeightInSection:(NSInteger)section{
    return 44;
}

//点击表格项
- (void)excelView:(MGExcelView *)excelView didSelectItemAtIndex:(MGExcelIndexPath *)index{
    NSLog(@"didSelectItemAtIndex----->>> (%ld, %ld, %ld)", index.section, index.row, index.column);
}

//点击表头表格项
- (void)excelView:(MGExcelView *)excelView didSelectHeaderItemAtColumn:(NSInteger)column{
    NSLog(@"didSelectHeaderItemAtColumn----->>> (column = %ld)", column);
}

//滑动表格
- (void)excelView:(MGExcelView *)excelView didScrollWithContentOffset:(CGPoint)offset{
//    NSLog(@"didScrollWithContentOffset----->>> (%g, %g)", offset.x, offset.y);
    CGSize contentSize = CGSizeMake(excelView.contentSize.width, excelView.headerCell.frame.size.height);
    NSLog(@"didScrollWithContentOffset----->>> (%g, %g, %g)", contentSize.width, offset.y, contentSize.height);
    [self.scrollIndicatorView showIndicatorAtContentSize:contentSize withContentOffset:offset];
}

@end

