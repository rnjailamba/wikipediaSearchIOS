//
//  MainViewController.m
//  iOS Test Obj C
//
//  Created by Deniz Aydemir on 8/24/16.
//  Copyright © 2016 Castle. All rights reserved.
//

#import "MainViewController.h"
#import "TableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic) NSString *currentSearch;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSearchBar];
    [self registerNib];
    self.results = [NSMutableArray new];
    self.currentSearch = @"";
    [self setUpTableViewController];//Which displays the results
    
    
}

-(void)setUpSearchBar{
    self.searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:self.searchBar];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20],
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
                                ]];
    self.searchBar.placeholder = @"I want to learn about...";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];


}

-(void)setUpTableViewController{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"header"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"resultCell"];
    

}

-(void)registerNib{
    
}

#pragma UICollectionViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return [self.results count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        NSArray* subviews = [cell.contentView subviews];
        for (UIView* subview in subviews) {
            [subview removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grayColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width, 20)];
        label.text = @"Results";
        [label setFont:[UIFont  systemFontOfSize:20 weight:UIFontWeightMedium]];
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        return cell;

    }
    else if(indexPath.section == 1){

        TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
        cell.title.text = @"";
        cell.textView.text = @"";
        cell.backgroundColor = [UIColor whiteColor];
        [cell.textView setFont:[UIFont systemFontOfSize:16]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row;


        dispatch_async(dispatch_get_main_queue(), ^(){
          
            if ([self.results count] > indexPath.row) {
                NSDictionary *dict = [self.results objectAtIndex:indexPath.row];
                NSLog(@"dict %@",dict);
                NSString *title = [dict objectForKey:@"title"];
                NSString *subtitle = [dict objectForKey:@"extract"];
                NSDictionary *imageDict = [dict objectForKey:@"thumbnail"];
                if(imageDict != nil){
                    NSString *source = [imageDict objectForKey:@"source"];
                    if(source!= nil){
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:source] placeholderImage:[UIImage imageNamed:@"place"]];
                            [cell setNeedsLayout];

                        });
                        cell.textView.text = source;
                        cell.imageView.hidden = NO;
                        cell.imageWidth.constant = 95;
                    }
                }
                else{
                    cell.imageView.hidden = YES;
                    cell.imageWidth.constant = 0;
                }
                cell.title.text = title;
                cell.textView.text = subtitle;
                cell.textView.editable = NO;
                cell.textView.scrollEnabled = NO;
                [cell.textView setUserInteractionEnabled:NO];

            }
        });

        cell.preservesSuperviewLayoutMargins = false;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
    }
    else{
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        return 60;
    }
    else if(indexPath.section == 1){
        return 160;
    }
    else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        dispatch_async(dispatch_get_main_queue(), ^(){

            DetailViewController *detailVC = [DetailViewController new];
            [self presentViewController:detailVC animated:YES completion:nil];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Searchbardelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self handleViewDismissal];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];

}

-(void)handleViewDismissal{
    [self.searchBar resignFirstResponder];
}





- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    self.currentSearch = searchText;
    NSDictionary *parameters = @{@"format":@"json",
                                 @"action":@"query",
                                 @"generator":@"search",
                                 @"gsrnamespace":@"0",
                                 @"gsrsearch":searchText,
                                 @"gsrlimit":@"10",
                                 @"prop":@"pageimages|extracts",
                                 @"pilimit":@"max",
                                 @"exintro":@"",
                                 @"explaintext":@"",
                                 @"exlimit":@"max",
                                 @"exsentences":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"https://en.wikipedia.org/w/api.php" parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        //            Get data
        if(searchText == self.currentSearch){

            self.results = [NSMutableArray new];

            id obj = [responseObject objectForKey:@"query"];
            id pages = [obj objectForKey:@"pages"];
            for(id val in pages){
                NSDictionary *dict = [pages objectForKey:val];
                [self.results addObject:dict];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];


    
}

@end
