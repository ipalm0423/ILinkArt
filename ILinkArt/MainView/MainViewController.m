//
//  MainViewController.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "MainViewController.h"
#import "ILAAPI.h"
#import "AccountListViewController.h"
#import "CategoryListViewController.h"

@interface MainViewController ()<UIWebViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@end

@implementation MainViewController{
    ILAService *iLAService;
    NSInteger tapIndex;
    NSMutableArray *urlHistoryByIndex;
    UINavigationController *testVC;
    CategoryListViewController *categoryListVC;
    AccountListViewController *accountListVC;
    
    NSString *searchType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    iLAService = [ILAService sharedController];
    
    self.searchBar.delegate = self;
    
    searchType = @"product";
    
    //view
    [self setupSearchBarView];
    [self setupTapBar];
    [self setupWebView];
    
    //LOAD
    
    NSURLRequest *loginRequest = [iLAService getAutoLogInRequest];
    if (loginRequest) {
        NSLog(@"have auto log in, start log in");
        [self loadWebRequest:loginRequest];
    }else{
        NSLog(@"no auto log in");
        [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLHomepage]]];
    }
    
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotificationLoadWebUrl:) name:NOTIFICATIONLoadWebUrl object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view setup
-(void)setupWebView{
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    
    urlHistoryByIndex = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObject:URLHomepage],[NSMutableArray arrayWithObject:@"categoryVC"],[NSMutableArray arrayWithObject:URLArtist],[NSMutableArray arrayWithObject:URLMessage],[NSMutableArray arrayWithObject:@"accountVC"], nil];
    [self selectOnTabBarButton:0];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //back
    [self.webView setBackgroundColor:COLORBackground];
    [self.webView setOpaque:NO];
    //...
}
-(void)setupSearchBarView{
    //hide black separator
    CGRect rect = self.searchBar.frame;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-2,rect.size.width, 2)];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,rect.size.width, 2)];
    lineView.backgroundColor = COLORBackground;
    lineView2.backgroundColor = COLORBackground;
    [self.searchBar addSubview:lineView];
    [self.searchBar addSubview:lineView2];
    
    self.buttonNaviLeft.tag = 0;
    [self.buttonNaviLeft setImage:[UIImage imageNamed:@"iconStar"] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.subviewSearch];
}

-(void)setupTapBar{
    tapIndex = 0;
    [self setupTapButton:self.buttonTapHomepage];
    [self setupTapButton:self.buttonTapCategory];
    [self setupTapButton:self.buttonTapArtist];
    [self setupTapButton:self.buttonTapProfile];
    [self setupTapButton:self.buttonTapMessage];
    
}

-(void)setupTapButton:(UIButton*)button{
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.frame.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = button.titleLabel.frame.size;
    button.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}



#pragma mark - load web
-(void)loadWebURL:(NSString*)url{
    if(url && url.length > 0){
        NSURL *newURL = [NSURL URLWithString:url];
        [self addWebHistory:url];
        [self.webView loadRequest:[NSURLRequest requestWithURL:newURL]];
        [self reloadLeftNaviButtonImage];
        
    }
}

-(void)loadWebRequest:(NSURLRequest*)request{
    if(request){
        [self.webView loadRequest:request];
    }
}

-(void)addWebHistory:(NSString*)url {
    if (![url isEqualToString:@"http://www.ilinkart.com/user/mobileNav"]) {
        NSMutableArray *urlHistory = [urlHistoryByIndex objectAtIndex:tapIndex];
        [urlHistory addObject:url];
    }
    
}

#pragma mark UIWebviewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView{
    
    [self.indicatorWeb startAnimating];
    self.indicatorWeb.alpha = 1;
    webView.alpha = 0;
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webView did finished load:%@", webView.request.URL.absoluteString);
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.indicatorWeb stopAnimating];
    self.indicatorWeb.alpha = 0;
    webView.alpha = 1;
    
    if ([webView.request.URL.absoluteString isEqualToString:URLAccount] || [webView.request.URL.absoluteString isEqualToString:URLMyOrder]) {
        [[ILAService sharedController]updateNameAndIconFromWeb:webView];
        [[ILAService sharedController]updateKartCountAndLogIn:webView];
    }
    //load homepage
    if ([webView.request.URL.absoluteString isEqualToString:URLHomepage]) {
        [[ILAService sharedController]updateCategoryFromWeb:webView];
        
    }
    if ([webView.request.URL.absoluteString isEqualToString:URLLogout]) {
        NSLog(@"log out");
        //clear history
        urlHistoryByIndex = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObject:URLHomepage],[NSMutableArray arrayWithObject:@"categoryVC"],[NSMutableArray arrayWithObject:URLArtist],[NSMutableArray arrayWithObject:URLMessage],[NSMutableArray arrayWithObject:@"accountVC"], nil];
    }
    
    
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView.alpha = 1;
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.indicatorWeb stopAnimating];
    self.indicatorWeb.alpha = 0;
}
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    
    //auto login
    if(navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeLinkClicked){
        NSLog(@"/////////////// tap on webview");
        
        //save history
        [self addWebHistory:request.URL.absoluteString];
        
        //check auto login
        [iLAService checkAutoLogIn:request];
    }else{
        if ([request.URL.absoluteString isEqualToString:@"http://www.ilinkart.com/artist/welcome"] && [iLAService checkIfUserLogIn]) {
            
            [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLHomepage]]];
        }
        
    }
    
    //reload left navi button
    [self reloadLeftNaviButtonImage];
    
    return YES;
}


#pragma mark - scroll view
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float max = self.webView.scrollView.contentSize.height - self.webView.bounds.size.height;
    if (self.webView.scrollView.contentOffset.y > max) {
        [self.webView.scrollView setContentOffset: CGPointMake(0.0f, max)];
    }
    if (self.webView.scrollView.contentOffset.y < 0) {
        [self.webView.scrollView setContentOffset: CGPointMake(0.0f, 0.0f)];
    }
    
    
    
}

#pragma mark - Animate
-(void)animatePageForward{
    
    
}
-(void)animatePageBack{
    NSMutableArray *urlHistory = [urlHistoryByIndex objectAtIndex:tapIndex];
    if (urlHistory.count == 0) {
        
    }else{
        
    }
}


-(void)reloadLeftNaviButtonImage{
    NSMutableArray *history = [urlHistoryByIndex objectAtIndex:tapIndex];
    if (history.count > 1) {
        self.buttonNaviLeft.tag = 1;
        [self.buttonNaviLeft setImage:[UIImage imageNamed:@"iconBack"] forState:UIControlStateNormal];
    }else{
        self.buttonNaviLeft.tag = 0;
        [self.buttonNaviLeft setImage:[UIImage imageNamed:@"iconStar"] forState:UIControlStateNormal];
    }
}

-(void)animateTabBarButtonImageForIndex:(NSInteger)index{
    
    [self.buttonTapHomepage setImage:index == 0 ?[UIImage imageNamed:@"iconHome_p"]:[UIImage imageNamed:@"iconHome"] forState:UIControlStateNormal];
    [self.buttonTapCategory setImage:index == 1 ?[UIImage imageNamed:@"iconProduct_p"]:[UIImage imageNamed:@"iconProduct"] forState:UIControlStateNormal];
    [self.buttonTapArtist setImage:index == 2 ?[UIImage imageNamed:@"iconPen_p"]:[UIImage imageNamed:@"iconPen"] forState:UIControlStateNormal];
    [self.buttonTapMessage setImage:index == 3 ?[UIImage imageNamed:@"iconInfo_p"]:[UIImage imageNamed:@"iconInfo"] forState:UIControlStateNormal];
    [self.buttonTapProfile setImage:index == 4 ?[UIImage imageNamed:@"iconProfile_p"]:[UIImage imageNamed:@"iconProfile"] forState:UIControlStateNormal];
}




#pragma mark - tab bar
-(void)selectOnTabBarButton:(NSInteger)index{
    //double tap
    if (index == tapIndex) {
        [self clearHistoryList:index];
        
    }
    
    tapIndex = index;
    [self animateTabBarButtonImageForIndex:index];
    [self reloadLeftNaviButtonImage];
    NSString *lastURL = [[urlHistoryByIndex objectAtIndex:tapIndex] lastObject];
    
    
    //cate view
    if (index != 1) {
        [categoryListVC.view removeFromSuperview];
    }
    if (index != 4) {
        [accountListVC.view removeFromSuperview];
    }
    if (index == 0 || index == 1) {
        [self.subviewSearch needsUpdateConstraints];
        self.subviewSearch.alpha = 1;
        self.constraintSearchBarHeight.constant = 44;
    }else{
        [self.subviewSearch needsUpdateConstraints];
        self.subviewSearch.alpha = 0;
        self.constraintSearchBarHeight.constant = 0;
        
    }
    
    if (index == 0) {
        //artist
        [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lastURL]]];
        
    }else if (index == 1){
        if (!categoryListVC) {
            categoryListVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CategoryListViewController"];
            [categoryListVC.view setFrame:CGRectMake(0, self.subviewSearch.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height - self.subviewNaviBar.frame.size.height  - self.subviewTabBar.frame.size.height)];
            
        }
        if ([lastURL isEqualToString:@"categoryVC"]) {
            [self.view addSubview:categoryListVC.view];
        }else{
            [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lastURL]]];
        }
        
    }else if (index == 2){
        //artist
        [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lastURL]]];
        
    }else if (index == 3){
        //blog
        [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lastURL]]];
    }else if (index == 4){
        //account view
        if (!accountListVC) {
            accountListVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AccountListViewController"];
            [accountListVC.view setFrame:CGRectMake(0, self.subviewSearch.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height - self.subviewNaviBar.frame.size.height  - self.subviewTabBar.frame.size.height)];
            
        }
        if ([lastURL isEqualToString:@"accountVC"]) {
            [self.view addSubview:accountListVC.view];
        }else{
            [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lastURL]]];
        }
    }
}

-(void)clearHistoryList:(NSInteger)index{
    NSMutableArray *cleanArray = [NSMutableArray arrayWithObject:[[urlHistoryByIndex objectAtIndex:tapIndex] objectAtIndex:0]];
    [urlHistoryByIndex replaceObjectAtIndex:index withObject:cleanArray];
}

#pragma mark - button
- (IBAction)buttonHomepageTouch:(UIButton *)sender {
    NSLog(@"button Homepage Touch");
    [self selectOnTabBarButton:0];
}

- (IBAction)buttonCategoryTouch:(UIButton *)sender {
    NSLog(@"button Category Touch");
    [self selectOnTabBarButton:1];
}

- (IBAction)buttonArtistTouch:(UIButton *)sender {
    NSLog(@"button Artist Touch");
    [self selectOnTabBarButton:2];
}
- (IBAction)buttonMessageTouch:(UIButton *)sender {
    NSLog(@"button Message Touch");
    [self selectOnTabBarButton:3];
}
- (IBAction)buttonTapProfile:(UIButton*)sender {
    NSLog(@"button Profile Touch");
    [self selectOnTabBarButton:4];
}


#pragma mark - NAVI Button
- (IBAction)buttonLeftNaviTouch:(UIButton *)sender {
    if (sender.tag == 0) {//star
        [self loadWebURL:URLFavorite];
        
    }else{//back == 1
        NSMutableArray *urlHistory = [urlHistoryByIndex objectAtIndex:tapIndex];
        if (urlHistory.count > 1) {
            [urlHistory removeLastObject];
            NSString *url = [urlHistory objectAtIndex:urlHistory.count - 1];
            if ([url isEqualToString:@"categoryVC"]) {
                [self.view addSubview:categoryListVC.view];
            }else if ([url isEqualToString:@"accountVC"]){
                [self.view addSubview:accountListVC.view];
            }else{
                [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            }
            
            
            
        }else{//home
            switch (tapIndex) {
                case 0:
                    [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLHomepage]]];
                    break;
                case 1:
                    [self.view addSubview:categoryListVC.view];
                    break;
                case 2:
                    [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLArtist]]];
                    break;
                case 3:
                    [self loadWebRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLMessage]]];
                    break;
                case 4:
                    [self.view addSubview:accountListVC.view];
                    break;
                default:
                    break;
            }
        }
        
    }
    [self reloadLeftNaviButtonImage];
}
- (IBAction)buttonRightNaviTouch:(UIButton *)sender {
    [self loadWebURL:URLShopChart];
}

#pragma mark - Search button
- (IBAction)buttonSearchTypeTouch:(UIButton *)sender {
    NSLog(@"search type button touch");
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"搜 寻" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionProduct = [UIAlertAction actionWithTitle:@"商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.ButtonSearchItem setTitle:@"商品" forState:UIControlStateNormal];
        searchType = @"product";
    }];
    UIAlertAction *actionArticle = [UIAlertAction actionWithTitle:@"作品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.ButtonSearchItem setTitle:@"作品" forState:UIControlStateNormal];
        searchType = @"artwork";
    }];
    UIAlertAction *actionArtist = [UIAlertAction actionWithTitle:@"创作者" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.ButtonSearchItem setTitle:@"创作者" forState:UIControlStateNormal];
        searchType = @"artist";
    }];
    
    [control addAction:actionProduct];
    [control addAction:actionArticle];
    [control addAction:actionArtist];
    
    [self presentViewController:control animated:YES completion:nil];
    
}

#pragma mark - search bar
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search button click");
    NSString *url = [NSString stringWithFormat:@"http://www.ilinkart.com/site/search?search-type=%@&search-keyword=%@",searchType, [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.view endEditing:YES];
    NSLog(@"search for:%@", url);
    
    [self loadWebURL:url];
}

#pragma mark - notify
-(void)getNotificationLoadWebUrl:(NSNotification*)notify{
    NSInteger index = [notify.userInfo[@"index"]integerValue];
    NSString *url = notify.userInfo[@"url"];
    
    
    
    if ([url isEqualToString:URLLogout]) {
        NSLog(@"log out");
        //clear history
        
        [self selectOnTabBarButton:0];
        [self loadWebURL:URLLogout];
    }else{
        
        [self loadWebURL:url];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
