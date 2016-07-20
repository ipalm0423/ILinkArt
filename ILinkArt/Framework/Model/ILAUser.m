//
//  ILAUser.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "ILAUser.h"
#import "ILACategory.h"

@implementation ILAUser


-(instancetype)init{
    if (self = [super init]) {
        self.categoriesDic = [NSMutableDictionary new];
        self.kartCount = 0;
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [self init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.imageiConData = [aDecoder decodeObjectForKey:@"imageiConData"];
        self.logInRequest = [aDecoder decodeObjectForKey:@"logInRequest"];
        self.fbLogInRequest = [aDecoder decodeObjectForKey:@"fbLogInRequest"];
        self.weChatLogInRequest = [aDecoder decodeObjectForKey:@"weChatLogInRequest"];
        self.categoriesDic = [aDecoder decodeObjectForKey:@"categoriesDic"];
        self.kartCount = [[aDecoder decodeObjectForKey:@"kartCount"]integerValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.imageiConData forKey:@"imageiConData"];
    [aCoder encodeObject:self.logInRequest forKey:@"logInRequest"];
    [aCoder encodeObject:self.fbLogInRequest forKey:@"fbLogInRequest"];
    [aCoder encodeObject:self.weChatLogInRequest forKey:@"weChatLogInRequest"];
    [aCoder encodeObject:self.categoriesDic forKey:@"categoriesDic"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.kartCount] forKey:@"kartCount"];
}





@end
