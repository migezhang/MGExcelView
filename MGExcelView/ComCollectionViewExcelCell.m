//
//  ComCollectionViewExcelCell.m
//  MGExcelView
//
//  Created by mige on 2018/4/4.
//  Copyright © 2018年 mige. All rights reserved.
//

#import "ComCollectionViewExcelCell.h"
#import "MGCollectionViewExcelLayout.h"
#import "HbbScrollIndicatorView.h"
#import "ComExcelDetailCell.h"

@interface ComCollectionViewExcelCell () <UICollectionViewDelegate, UICollectionViewDataSource, MGCollectionViewExcelLayoutDelegate>

@property (nonatomic, strong) MGCollectionViewExcelLayout *layout;
@property (nonatomic, strong) HbbScrollIndicatorView *scrollIndicatorView; //指示视图

@end


@implementation ComCollectionViewExcelCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
    
    [self refreshData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.excelView.bounds;
}

- (void)setupView{
    self.layout = [[MGCollectionViewExcelLayout alloc] init];
    self.layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:self.layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComExcelDetailCell" bundle:nil] forCellWithReuseIdentifier:@"ComExcelDetailCell"];
    [self.excelView addSubview:self.collectionView];
    
    self.scrollIndicatorView = [[HbbScrollIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, 80)];
    [self.collectionView addSubview:self.scrollIndicatorView];
    CGSize contentSize = CGSizeMake(self.collectionView.contentSize.width, 0);
    [self.scrollIndicatorView showIndicatorAtContentSize:contentSize withContentOffset:CGPointZero];
}

- (void)refreshData{
    //防止刷新时，阻塞主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新数据
        [self.collectionView reloadData];

        //刷新布局
        self.layout.isFillWidth = NO;
        [self.layout refreshLayout];
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

//返回列数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

//表格样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ComExcelDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComExcelDetailCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.detailLabel.text = [NSString stringWithFormat:@"详情-%ld-%ld", self.currentIndexPath.row, indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - MGExcelCollectionLayoutDelegate
//返回行高
- (CGFloat)excelLayout:(MGCollectionViewExcelLayout *)excelLayout rowHeightForItemAtRow:(NSInteger)row{
    return 80;
}

//返回列宽
- (CGFloat)excelLayout:(MGCollectionViewExcelLayout *)excelLayout columnWidthForItemAtColumn:(NSInteger)column{
    return 80;
}

//设置锁定的列数
- (NSInteger)lockColumnsInExcelLayout:(MGCollectionViewExcelLayout *)excelLayout{
    return 1;
}


@end
