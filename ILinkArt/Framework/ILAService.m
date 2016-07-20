//
//  ILAService.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "ILAService.h"
#import "AppDelegate.h"
#import "ILAParser.h"
#import "ILACategory.h"
#import "SBJson.h"
#import "ILANotification.h"
#import "ILAUrl.h"

@implementation ILAService{
    NSUserDefaults *userDefaults;
    AppDelegate *appDelegate;
    dispatch_queue_t userDataQueue;
    
    
}


#pragma mark - singleton & init
static ILAService *sharedService = nil;

+ (id)sharedController {
    @synchronized(self) {
        if (sharedService == nil){
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sharedService = [[self alloc] init];//set to default user
                
            });
            
        }
    }
    return sharedService;
}

- (id)init {
    if (self = [super init]) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        userDataQueue = dispatch_queue_create("com.ILA.ILAUser.ProgressQueue", DISPATCH_QUEUE_CONCURRENT);
        
        [self loadDefaultUser];
        
    }
    return self;
}



#pragma mark - save
-(void)loadDefaultUser {
    NSData *encodedObject = [userDefaults objectForKey:@"defaultUser"];
    if (encodedObject != nil && [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject]) {
        
        self.iLAUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        
    }else {
        
        self.iLAUser = [[ILAUser alloc] init];
        
    }
    [self saveAllChange];
}

-(void) saveDefaultUser:(ILAUser*)user {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    [userDefaults setObject:encodedObject forKey:@"defaultUser"];
}

-(void)saveAllChange{
    
    [self saveDefaultUser:_iLAUser];
    [userDefaults synchronize];
}


#pragma mark - Parser
-(void)updateCategoryFromWeb:(UIWebView*)webView{
    NSArray *returnvalue = [[webView stringByEvaluatingJavaScriptFromString:PARSERCategory] JSONValueFromString];
    dispatch_barrier_async(userDataQueue, ^{
        
        //update
        NSMutableDictionary *allCategories = [NSMutableDictionary new];
        for (NSArray* dataArray in returnvalue) {
            NSMutableArray *categories = [NSMutableArray new];
            NSString *keyName = @"";
            for (int i = 0; i < dataArray.count; i++) {
                if (i == 0) {
                    //cate name
                    keyName = [dataArray[0]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }else{
                    
                    ILACategory *newCategory = [ILACategory categoryWithName:[[dataArray[i] objectForKey:@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] url:[dataArray[i] objectForKey:@"url"]];
                    [categories addObject:newCategory];
                    
                }
            }
            [allCategories setObject:categories forKey:keyName];
        }
        //replace
        self.iLAUser.categoriesDic = allCategories;
        [self saveAllChange];
        NSLog(@"update category from webview");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONUpdateCategory object:nil];
        });
    });
    
}

-(void)updateNameAndIconFromWeb:(UIWebView*)webView{
    NSDictionary *returnvalue = [[webView stringByEvaluatingJavaScriptFromString:PARSERNameAndIcon] JSONValueFromString];
    
    if (returnvalue) {
        self.iLAUser.name = [returnvalue objectForKey:@"user_name"];
        self.iLAUser.imageUrl = [returnvalue objectForKey:@"avatar_url"];
        [self saveAllChange];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONUpdateUserInfo object:nil];
        });
    }
}

-(void)updateKartCountAndLogIn:(UIWebView*)webView{
    NSDictionary *returnvalue = [[webView stringByEvaluatingJavaScriptFromString:PARSERKartCount] JSONValueFromString];
    if (returnvalue) {
        BOOL isLogIn = [[returnvalue objectForKey:@"status"]boolValue];
        self.iLAUser.kartCount = isLogIn ? [[returnvalue objectForKey:@"cart_count"]integerValue]:0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONUpdateUserInfo object:nil];
        });
    }
}

#pragma mark - auto log in
-(NSURLRequest*)getAutoLogInRequest{
    if (self.iLAUser.logInRequest) {
        return self.iLAUser.logInRequest;
    }else if (self.iLAUser.fbLogInRequest){
        return self.iLAUser.fbLogInRequest;
    }else if (self.iLAUser.weChatLogInRequest){
        return self.iLAUser.weChatLogInRequest;
    }
    
    return nil;
}

-(BOOL)checkIfUserLogIn{
    if ([self getAutoLogInRequest]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)checkAutoLogIn:(NSURLRequest*)request{
    NSString *refereURL = [request.allHTTPHeaderFields objectForKey:@"Referer"];
    NSLog(@"should start load Request:%@",request.URL.absoluteString);
    NSLog(@"allHTTPHeaderFields: %@", request.allHTTPHeaderFields);
    NSLog(@"HTTPBody: %@", request.HTTPBody);
    NSLog(@"HTTPMethod: %@", request.HTTPMethod);
    
    if ([request.URL.absoluteString isEqualToString:URLLogIn] && [refereURL isEqualToString:URLLogIn]) {
        
        dispatch_barrier_async(userDataQueue, ^{
            self.iLAUser.logInRequest = request;
            [self saveAllChange];
        });
        
        NSLog(@"save requet for log in");
    }
    
    //fb
    if ([request.URL.absoluteString rangeOfString:@"https://www.facebook.com/dialog/oauth?client_id="].location != NSNotFound){
        
        
        //save request
        dispatch_barrier_async(userDataQueue, ^{
            self.iLAUser.logInRequest = request;
            [self saveAllChange];
        });
        
        NSLog(@"save requet for FB log in");
    }
    
    //wechat
}



@end
