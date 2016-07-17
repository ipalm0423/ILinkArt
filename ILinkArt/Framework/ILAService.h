//
//  ILAService.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILAUser.h"
#import <UIKit/UIKit.h>

@class ILAService;
@interface ILAService : NSObject



@property (strong, atomic) ILAUser *iLAUser;


+ (id)sharedController;
-(void)updateCategoryFromWeb:(UIWebView*)webView;


//log in
-(NSURLRequest*)getAutoLogInRequest;
-(void)checkAutoLogIn:(NSURLRequest*)request;

@end
