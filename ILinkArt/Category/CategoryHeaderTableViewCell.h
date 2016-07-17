//
//  CategoryHeaderTableViewCell.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryHeaderTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *labelHeader;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewHeader;

@property (strong, nonatomic) NSString* itemName;
@property (nonatomic) BOOL isOpen;

@property (strong, nonatomic) IBOutlet UIButton *buttonHeader;


@end
