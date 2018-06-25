//
//  MGExcelViewCellVC.m
//  MGExcelView
//
//  Created by mige on 2018/3/31.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "MGExcelViewCellVC.h"
#import "ComExcelViewCell.h"

@interface MGExcelViewCellVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isExpand;

@end

@implementation MGExcelViewCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"展开" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 44.0f;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"ComExcelViewCell" bundle:nil] forCellReuseIdentifier:@"ComExcelViewCell"];
    [self.tableView reloadData];
}

- (void)onRightBarItemClick:(UIBarButtonItem *)barButtonItem{
    BOOL isExpand = self.isExpand ? NO : YES;
    self.isExpand = isExpand;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComExcelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComExcelViewCell" forIndexPath:indexPath];
//    ComExcelViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ComExcelViewCell" owner:self options:nil] firstObject];
    cell.currentIndexPath = indexPath;
    [self setupExcelViewWithCell:cell];
    return cell;
}

/**
 设置表格视图
 */
- (void)setupExcelViewWithCell:(ComExcelViewCell *)cell{
    cell.excelView.hidden = YES;
    cell.excelView.tableView.scrollEnabled = NO;
    cell.excelViewHeightC.constant = 0;
    cell.excelViewBottomC.constant = 0;
//    cell.excelView.contentOffset = CGPointZero;
    if (self.isExpand == YES) {
        cell.excelView.hidden = NO;
        CGFloat excelHeight = cell.excelView.contentSize.height;
        cell.excelViewHeightC.constant = excelHeight;
        cell.excelViewBottomC.constant = 7;
        NSLog(@"---->> %g", excelHeight);
    }
    [cell.excelView refreshData];
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ComExcelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComExcelViewCell"];
//    [self setupExcelViewWithCell:cell];
//    CGFloat excelHeight = cell.excelView.contentSize.height;
//    NSLog(@"---->> %g", excelHeight);
//    CGFloat cellHeight = 60;
//    if (self.isExpand == YES) {
//        cellHeight = 60 + excelHeight + 7;
//    }
//    return cellHeight;
//}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    ComExcelViewCell *excelCell = (ComExcelViewCell *)cell;
//    [excelCell initExcelView];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
