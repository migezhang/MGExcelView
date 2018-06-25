//
//  ComExcelDetailCell.h
//  HBB_BuyerProject
//
//  Created by mige on 2018/2/9.
//  Copyright © 2018年 CHENG DE LUO. All rights reserved.
//
/**
 *  通用表格详情列cell
 *
 *  @author mige
 */
#import <UIKit/UIKit.h>

@interface ComExcelDetailCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLabel; //详情
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelLeadingC; //详情左侧约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelTrailingC; //详情右侧约束

@end
