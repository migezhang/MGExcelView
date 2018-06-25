//
//  ComCollectionViewExcelCell.h
//  MGExcelView
//
//  Created by mige on 2018/4/4.
//  Copyright © 2018年 mige. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComCollectionViewExcelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *excelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excelViewHeightC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excelViewBottomC;

@property (nonatomic, strong) UICollectionView *collectionView; //网格视图

@property (nonatomic, strong) NSIndexPath *currentIndexPath; //当前索引

- (void)refreshData;

@end
