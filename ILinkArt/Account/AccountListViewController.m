//
//  AccountListViewController.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/18.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "AccountListViewController.h"
#import "ILAAPI.h"
#import "AccountProfileTableViewCell.h"
#import "AccountLabelTableViewCell.h"

@interface AccountListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AccountListViewController{
    
    ILAService *ilaService;
    
    NSMutableArray *nameList;
    NSMutableArray *iconList;
    NSMutableArray *urlList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ilaService = [ILAService sharedController];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self setupDataArray];
    
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotification:) name:NOTIFICATIONUpdateUserInfo object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupDataArray];
    [self.tableView reloadData];
}

-(void)setupDataArray{
    if (![[ILAService sharedController]checkIfUserLogIn]) {
        //未登入
        
        iconList = [NSMutableArray arrayWithObjects:@"iconHelp", @"iconPhone", @"iconAbout", @"iconBecome", @"iconFee", @"iconVersion", @"iconPrivacy", @"iconService", nil];
        nameList = [NSMutableArray arrayWithObjects:@"帮助", @"客服资讯", @"关于世创连结", @"成为创作者", @"关于版权费", @"版本资讯", @"隐私条款", @"服务条款", nil];
        urlList = [NSMutableArray arrayWithObjects:URLHelp, URLContact, URLAbout, URLBecome, URLCopyRight,URLVersion, URLPrivacy, URLTerms, nil];
        
    }else{
        iconList = [NSMutableArray arrayWithObjects:@"iconHelp", @"iconPhone", @"iconAbout", @"iconBecome", @"iconFee", @"iconVersion", @"iconPrivacy", @"iconService", @"iconLogout", nil];
        nameList = [NSMutableArray arrayWithObjects:@"帮助", @"客服资讯", @"关于世创连结", @"成为创作者", @"关于版权费", @"版本资讯", @"隐私条款", @"服务条款", @"登出", nil];
        urlList = [NSMutableArray arrayWithObjects:URLHelp, URLContact, URLAbout, URLBecome, URLCopyRight,URLVersion, URLPrivacy, URLTerms,URLLogout, nil];
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return nameList.count;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AccountProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccountProfile" forIndexPath:indexPath];
        if ([[ILAService sharedController]checkIfUserLogIn]) {
            [cell.buttonOrders setTitle:@"订单纪录" forState:UIControlStateNormal];
            cell.labelName.text = ilaService.iLAUser.name;
        }else{
            [cell.buttonOrders setTitle:@"登 入" forState:UIControlStateNormal];
            cell.labelName.text = @"尚未登入";
        }
        
        
        return cell;
    }else{
        AccountLabelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccountLabel" forIndexPath:indexPath];
        cell.labelName.text = [nameList objectAtIndex:indexPath.row];
        cell.imageIcon.image = [UIImage imageNamed:[iconList objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tap on section:%li row:%li", indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        [self postNotification:URLAccount];
        [self.view removeFromSuperview];
    }else{
        NSString *url = [urlList objectAtIndex:indexPath.row];
        
        if(url && url.length > 0){
            [self postNotification:url];
            [self.view removeFromSuperview];
        }
    }
    
    
    
}

- (IBAction)buttonOrderListTouch:(UIButton *)sender {
    
    [self postNotification:URLMyOrder];
    [self.view removeFromSuperview];
}

#pragma mark notify
-(void)getNotification:(NSNotification*)notify{
    NSLog(@"get notification:%@, update categories table", notify.name);
    
    [self.tableView reloadData];
}

#pragma mark - send notify
-(void)postNotification:(NSString*)stringUrl{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONLoadWebUrl object:nil userInfo:@{
                                                                                                           @"index":@4,
                                                                                                           @"url":stringUrl}];
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
