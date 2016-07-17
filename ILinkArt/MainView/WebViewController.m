//
//  WebViewController.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/18.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

- (instancetype) initWithURL:(NSURL*)URL{
    if(!(self=[super init])) return nil;
    self.URL = URL;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.URL) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(self.navigationController && (navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeLinkClicked)){
        //WebViewController *vc = [[[self class] alloc] initWithURLRequest:request];
        //[self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    return YES;
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
