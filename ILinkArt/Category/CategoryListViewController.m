//
//  CategoryListViewController.m
//  ILinkArt
//
//  Created by 陳冠宇 on 2016/7/17.
//  Copyright © 2016年 sh-extend. All rights reserved.
//

#import "CategoryListViewController.h"
#import "ILAAPI.h"
#import "CategoryLabelTableViewCell.h"
#import "CategoryHeaderTableViewCell.h"
#import "CategorySpecialSaleTableViewCell.h"


@interface CategoryListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CategoryListViewController{
    ILAService *ilaService;
    
    NSMutableDictionary *categories;
    NSMutableArray *nameList;
    NSMutableArray *openList;
    
    
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
    
    openList = [NSMutableArray new];
    nameList = [NSMutableArray new];
    
    [self setupCategoryData];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotification:) name:NOTIFICATIONUpdateCategory object:nil];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self setupCategoryData];
    [self.tableView reloadData];
}

-(void)setupCategoryData{
    NSMutableArray *newNameList = [NSMutableArray new];
    NSMutableArray *newOpenList = [NSMutableArray new];
    
    categories = ilaService.iLAUser.categoriesDic;
    
    int i = 1;
    for (NSString*key in categories) {
        [newNameList addObject:key];
        if (openList.count > i) {
            [newOpenList addObject:[openList objectAtIndex:i]];
        }else{
            [newOpenList addObject:@0];
        }
        
        i++;
    }
    
    [newOpenList insertObject:@0 atIndex:0];
    [newNameList insertObject:@"限时优惠" atIndex:0];
    
    openList = newOpenList;
    nameList = newNameList;
}

#pragma mark - table 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return categories.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if ([[openList objectAtIndex:section]boolValue]) {
            NSMutableArray *items = categories[nameList[section]];
            return items.count;
        }else{
            return 0;
        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryLabelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CategoryLabel" forIndexPath:indexPath];
    
    ILACategory *cate = [categories[nameList[indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.ilaCategory = cate;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (section == 0) {
        CategorySpecialSaleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CategorySpecialSale"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSpecialSectionHeader:)];
        [cell.contentView addGestureRecognizer:tap];
        return cell.contentView;
    }
    //else
    CategoryHeaderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CategoryHeader"];
    cell.itemName = nameList[section];
    cell.isOpen = [openList[section]boolValue];
    cell.buttonHeader.tag = section;
    
    return cell.contentView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - tap on cell
- (IBAction)buttonHeaderTouch:(UIButton *)sender {
    NSInteger section = sender.tag;
    NSLog(@"tap on section:%li", section);
    
    BOOL isOpen = [openList[section]boolValue];
    [openList replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

-(void)tapOnSpecialSectionHeader:(UITapGestureRecognizer*)tap{
    
    NSLog(@"tap on special section");
    
    [self postNotification:URLPromotion];
    [self.view removeFromSuperview];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tap on section:%li row:%li", indexPath.section, indexPath.row);
    ILACategory *selectCate = [[categories objectForKey:[nameList objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    if(selectCate.url && selectCate.url.length > 0){
        [self postNotification:selectCate.url];
        [self.view removeFromSuperview];
    }
}


#pragma mark notify
-(void)getNotification:(NSNotification*)notify{
    NSLog(@"get notification:%@, update categories table", notify.name);
    [self setupCategoryData];
    [self.tableView reloadData];
}

#pragma mark - send notify
-(void)postNotification:(NSString*)stringUrl{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONLoadWebUrl object:nil userInfo:@{
                                                                                                           @"index":@1,
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
