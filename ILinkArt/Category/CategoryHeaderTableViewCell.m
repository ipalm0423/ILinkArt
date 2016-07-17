//
//  CategoryHeaderTableViewCell.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "CategoryHeaderTableViewCell.h"
#import "ILAColor.h"

@implementation CategoryHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItemName:(NSString *)itemName{
    _itemName = itemName;
    
    self.labelHeader.text = _itemName;
    self.contentView.backgroundColor = COLORBackground;
}

-(void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    
    if (_isOpen) {
        self.imageViewHeader.image = [UIImage imageNamed:@"iconUp"];
    }else{
        self.imageViewHeader.image = [UIImage imageNamed:@"iconDown"];
    }
}

@end
