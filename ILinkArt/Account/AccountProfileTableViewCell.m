//
//  AccountProfileTableViewCell.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/18.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "AccountProfileTableViewCell.h"

@implementation AccountProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.buttonOrders.layer.cornerRadius = 10;
    self.buttonOrders.layer.masksToBounds = YES;
    
    self.imageViewIcon.layer.cornerRadius = self.imageViewIcon.frame.size.height/2;
    self.imageViewIcon.layer.masksToBounds = YES;
}
@end
