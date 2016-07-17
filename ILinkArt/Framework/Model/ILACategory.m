//
//  ILACategory.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "ILACategory.h"

@implementation ILACategory


-(instancetype)init{
    if (self = [super init]) {
        self.url = @"";
        self.name = @"";
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [self init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.url forKey:@"url"];
}


-(instancetype)initWithName:(NSString*)name url:(NSString*)url{
    if (self = [self init]) {
        self.name = name;
        self.url = url;
    }
    return self;
}

+(ILACategory*)categoryWithName:(NSString*)name url:(NSString*)url{
    return [[ILACategory alloc]initWithName:name url:url];
}


@end
