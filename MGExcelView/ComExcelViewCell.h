//
//  ComExcelViewCell.h
//  MGExcelView
//
//  Created by mige on 2018/3/31.
//  Copyright © 2018年 mige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGExcelView.h"

@interface ComExcelViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MGExcelView *excelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excelViewHeightC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *excelViewBottomC;


@property (nonatomic, strong) NSIndexPath *currentIndexPath; //当前索引

@end
