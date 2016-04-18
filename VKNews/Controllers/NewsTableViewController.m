//
//  NewsTableViewController.m
//  VKNews
//
//  Created by Alyona Belyaeva on 13.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "NewsTableViewController.h"
#import "MainModel.h"
#import "PostTableViewCell.h"
#import "DetailViewController.h"

@interface NewsTableViewController (){
    BOOL loadMorePosts;
}

@property (nonatomic, strong) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *downRefreshActivity;

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tableData = @[];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestPosts)
                  forControlEvents:UIControlEventValueChanged];
    loadMorePosts = YES;
    self.tableView.tableFooterView.hidden = YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"LoadPosts" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoadPosts" object:nil];
}


-(void)reloadTable{
    self.tableData = [[MainModel sharedInstance] posts];
    [self.refreshControl endRefreshing];
    loadMorePosts = NO;
    self.tableView.tableFooterView.hidden = YES;
    [self.downRefreshActivity stopAnimating];
    [self.tableView reloadData];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    CGFloat deltaOffset = maximumOffset - currentOffset;
    if (deltaOffset <= 0){
        [self loadMore];
    }
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"PostCell";
    static PostTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    });
    CGFloat height = [sizingCell calculateHeightWithContent:[self.tableData objectAtIndex:indexPath.row] forWidth:tableView.frame.size.width];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PostCell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    VKPost * post = [self.tableData objectAtIndex:indexPath.row];
    [cell showPostInfo: post];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VKPost * post = [self.tableData objectAtIndex:indexPath.row];
    PostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowPostInDetail" sender:@[post,cell.avatarImageView.image]];    
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPostInDetail"]) {
        DetailViewController *detailsVC;
        detailsVC = ((DetailViewController *)segue.destinationViewController);
        detailsVC.post = sender[0];
        detailsVC.avatarImage = sender[1];
    }
}

#pragma mark VK Action

-(void)getLatestPosts{
    [[MainModel sharedInstance] downloadNewPosts];
}


-(void)loadMore{
    if(!loadMorePosts){
        loadMorePosts = YES;
        self.tableView.tableFooterView.hidden = NO;
        [self.downRefreshActivity startAnimating];
        [[MainModel sharedInstance] downloadPostsOlder];
        NSLog(@"???");
    }
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    [[MainModel sharedInstance] logout];
}

@end
