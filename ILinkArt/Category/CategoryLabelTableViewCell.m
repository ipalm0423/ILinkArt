//
//  CategoryLabelTableViewCell.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "CategoryLabelTableViewCell.h"

@implementation CategoryLabelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setIlaCategory:(ILACategory *)ilaCategory{
    _ilaCategory = ilaCategory;
    
    self.labelItem.text = _ilaCategory.name;
}

@end
