//
//  ILAUser.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILAUser : NSObject <NSCoding>

@property NSString* name;
@property NSString* imageUrl;
@property NSData *imageiConData;
@property NSURLRequest *logInRequest;
@property NSURLRequest *fbLogInRequest;
@property NSURLRequest *weChatLogInRequest;
@property NSInteger kartCount;


//cate
@property (strong, atomic) NSMutableDictionary *categoriesDic;





@end
