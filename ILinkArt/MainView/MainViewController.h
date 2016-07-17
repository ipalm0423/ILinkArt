//
//  MainViewController.h
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController


//UI

//SEARCH BAR
@property (strong, nonatomic) IBOutlet UIView *subviewSearch;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *ButtonSearchItem;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintSearchBarHeight;

//NAVI
@property (strong, nonatomic) IBOutlet UIView *subviewNaviBar;

@property (strong, nonatomic) IBOutlet UIButton *buttonNaviLeft;
@property (strong, nonatomic) IBOutlet UIButton *buttonNaviRight;

//WEB
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorWeb;


//TAB
@property (strong, nonatomic) IBOutlet UIView *subviewTabBar;
@property (strong, nonatomic) IBOutlet UIButton *buttonTapHomepage;
@property (strong, nonatomic) IBOutlet UIButton *buttonTapCategory;
@property (strong, nonatomic) IBOutlet UIButton *buttonTapArtist;
@property (strong, nonatomic) IBOutlet UIButton *buttonTapMessage;
@property (strong, nonatomic) IBOutlet UIButton *buttonTapProfile;




@end
