//
//  MGCollectionViewCellVC.m
//  MGExcelView
//
//  Created by mige on 2018/4/4.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "MGCollectionViewCellVC.h"
#import "ComCollectionViewExcelCell.h"

@interface MGCollectionViewCellVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isExpand;

@end

@implementation MGCollectionViewCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"展开" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ComCollectionViewExcelCell" bundle:nil] forCellReuseIdentifier:@"ComCollectionViewExcelCell"];
    [self.tableView reloadData];
}

- (void)onRightBarItemClick:(UIBarButtonItem *)barButtonItem{
    BOOL isExpand = self.isExpand ? NO : YES;
    self.isExpand = isExpand;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComCollectionViewExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComCollectionViewExcelCell" forIndexPath:indexPath];
    cell.currentIndexPath = indexPath;
    [self setupExcelViewWithCell:cell];
    return cell;
}

/**
 设置表格视图
 */
- (void)setupExcelViewWithCell:(ComCollectionViewExcelCell *)cell{
    cell.collectionView.hidden = YES;
    cell.excelViewHeightC.constant = 0;
    cell.excelViewBottomC.constant = 0;
    if (self.isExpand == YES) {
        cell.collectionView.hidden = NO;
        CGFloat excelHeight = cell.collectionView.contentSize.height;
        cell.excelViewHeightC.constant = excelHeight;
        cell.excelViewBottomC.constant = 7;
        NSLog(@"---->> %g", excelHeight);
    }
    [cell refreshData];
}


#pragma mark - UITableViewDelegate
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
