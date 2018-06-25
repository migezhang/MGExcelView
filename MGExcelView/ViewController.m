//
//  ViewController.m
//  MGExcelView
//
//  Created by mige on 2018/3/29.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "ViewController.h"
#import "MGExcelViewVC.h"
#import "MGExcelViewCellVC.h"
#import "MGCollectionViewCellVC.h"

#define M_reusableCell @"reusableCell"

#define M_Title_MGExcelViewDemo @"MGExcelViewDemo"
#define M_Title_ExcelViewCellDemo @"ExcelViewCellDemo"
#define M_Title_CollectionViewCellDemo @"CollectionViewCellDemo"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = @[M_Title_MGExcelViewDemo, M_Title_ExcelViewCellDemo, M_Title_CollectionViewCellDemo];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:M_reusableCell];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:M_reusableCell forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    if ([title isEqualToString:M_Title_MGExcelViewDemo]) {
        MGExcelViewVC *excelViewVC = [[MGExcelViewVC alloc] initWithNibName:@"MGExcelViewVC" bundle:nil];
        [self.navigationController pushViewController:excelViewVC animated:YES];
        
    } else if ([title isEqualToString:M_Title_ExcelViewCellDemo]) {
        MGExcelViewCellVC *excelViewCellVC = [[MGExcelViewCellVC alloc] initWithNibName:@"MGExcelViewCellVC" bundle:nil];
        [self.navigationController pushViewController:excelViewCellVC animated:YES];
        
    } else if ([title isEqualToString:M_Title_CollectionViewCellDemo]) {
        MGCollectionViewCellVC *collectionViewCellVC = [[MGCollectionViewCellVC alloc] initWithNibName:@"MGCollectionViewCellVC" bundle:nil];
        [self.navigationController pushViewController:collectionViewCellVC animated:YES];
        
    }
}


@end
