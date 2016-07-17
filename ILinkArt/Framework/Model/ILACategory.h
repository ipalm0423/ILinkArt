//
//  ILACategory.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILACategory : NSObject<NSCoding>


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;


-(instancetype)initWithName:(NSString*)name url:(NSString*)url;
+(ILACategory*)categoryWithName:(NSString*)name url:(NSString*)url;

@end
