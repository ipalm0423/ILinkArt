//
//  WebViewController.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/18.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSURL *URL;

@end
