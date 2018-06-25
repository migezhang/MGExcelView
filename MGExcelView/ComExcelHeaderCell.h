//
//  ComExcelHeaderCell.h
//  HBB_BuyerProject
//
//  Created by mige on 2018/2/9.
//  Copyright © 2018年 CHENG DE LUO. All rights reserved.
//
/**
 *  通用表格首列cell
 *
 *  @author mige
 */
#import <UIKit/UIKit.h>

@interface ComExcelHeaderCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel; //子标题
@property (weak, nonatomic) IBOutlet UIImageView *imageView; //图片视图

@end
