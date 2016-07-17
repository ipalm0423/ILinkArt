//
//  CategoryLabelTableViewCell.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILACategory.h"

@interface CategoryLabelTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *labelItem;

@property (strong, nonatomic) ILACategory *ilaCategory;

@end
