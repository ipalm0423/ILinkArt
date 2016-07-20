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



//log in
-(NSURLRequest*)getAutoLogInRequest;
-(void)checkAutoLogIn:(NSURLRequest*)request;
-(BOOL)checkIfUserLogIn;

#pragma MARK - PARSER
-(void)updateNameAndIconFromWeb:(UIWebView*)webView;
-(void)updateCategoryFromWeb:(UIWebView*)webView;
-(void)updateKartCountAndLogIn:(UIWebView*)webView;
@end
