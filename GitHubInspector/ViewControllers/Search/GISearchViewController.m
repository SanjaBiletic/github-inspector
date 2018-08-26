//
//  GISearchViewController.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 24/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "GISearchViewController.h"
#import "HTTPRequest.h"
#import "GIRepository.h"
#import "GISearchTableViewCell.h"
#import "GIRepositoryDetailsViewController.h"
#import "GIUserDetailsViewController.h"
#import <PureLayout/PureLayout.h>

static NSString *const searchCellIdentifier = @"searchCellIdentifier";
static CGFloat const queryTextFieldHeight = 40.0;
static CGFloat const queryTextFieldTopConstraint = 65.0;
static CGFloat const searchCellHeight = 130.0;
static NSInteger const perPage = 20;

@interface GISearchViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, GISearchTableViewCellDelegate>

@property (strong, nonatomic) UILabel *noDataLabel;
@property (strong, nonatomic) UITextField *queryTextField;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) UITableView *searchResultTableView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSArray<GIRepository*> *repositories;
@property (strong, nonatomic) NSString *sort;

//infinite scroll properties
@property (strong, nonatomic) NSIndexPath *lastCellIndexPath;
@property (nonatomic) NSInteger totalNumberOfItems;
@property (nonatomic) NSInteger currentPage;

@end

@implementation GISearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Search";
    self.repositories = [NSArray array];
    
    self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noDataLabel.text = @"No data :(";
    self.noDataLabel.hidden = YES;
    [self.view addSubview:self.noDataLabel];
    [self.noDataLabel autoCenterInSuperview];
    
    self.queryTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.queryTextField.backgroundColor = self.view.backgroundColor;
    self.queryTextField.placeholder = @"Search Git Hub repositories";
    self.queryTextField.borderStyle = UITextBorderStyleNone;
    self.queryTextField.keyboardType = UIKeyboardTypeDefault;
    [self.queryTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEnd];
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.queryTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:self.queryTextField];
    [self.queryTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:queryTextFieldTopConstraint];
    [self.queryTextField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
    [self.queryTextField.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor];
    [self.queryTextField.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor];
    [self.queryTextField.heightAnchor constraintEqualToConstant:queryTextFieldHeight];
    
    
    self.searchResultTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchResultTableView.hidden = YES;
    [self.view addSubview:self.searchResultTableView];
    [self.searchResultTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.queryTextField];
    [self.searchResultTableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.searchResultTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [self.searchResultTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    UINib *nib = [UINib nibWithNibName:@"GISearchTableViewCell" bundle:nil];
    [self.searchResultTableView registerNib:nib forCellReuseIdentifier:searchCellIdentifier];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.hidden = YES;
    [self.view addSubview:self.spinner];
    [self.spinner autoCenterInSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GIRepository *repository = self.repositories[indexPath.row];
    
    GISearchTableViewCell *cell = (GISearchTableViewCell*)[self.searchResultTableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    cell.repository = repository;
    cell.delegate = self;
    
    if(indexPath.row == (self.currentPage * (perPage - 1)) || indexPath.row == (self.totalNumberOfItems - 1)){
        
        self.lastCellIndexPath = indexPath;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return searchCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GIRepository *repository = self.repositories[indexPath.row];
    
    GIRepositoryDetailsViewController *repositoryDetailsViewController = [[GIRepositoryDetailsViewController alloc] init];
    repositoryDetailsViewController.repository = repository;
    
    [self.navigationController pushViewController:repositoryDetailsViewController animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UITableViewCell *lastCell = [self.searchResultTableView cellForRowAtIndexPath:self.lastCellIndexPath];
    
    if((self.repositories.count > 0 && self.repositories.count < (self.totalNumberOfItems-1)) && lastCell){
        
        lastCell = nil;
        self.lastCellIndexPath = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [self showSpinner:YES hiddeTableView:NO];
        });
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.currentPage++;
            [self fetchGitHubRepositoriesForPage:self.currentPage withQuery:self.query];
        });
    }
}

#pragma mark - GISearchTableViewCellDelegate

- (void)searchTableViewCell:(GISearchTableViewCell *)cell openUserDetailsWithRepository:(GIRepository *)repository{
    
    GIUserDetailsViewController *userDetailsViewController = [[GIUserDetailsViewController alloc] init];
    userDetailsViewController.repository = repository;
    [self.navigationController pushViewController:userDetailsViewController animated:YES];
}

#pragma mrak - Networking

- (void)fetchGitHubRepositoriesForPage:(NSInteger)page withQuery:(NSString*)query{
    
    NSString *request = [NSString stringWithFormat:[repositorySearchUrl stringByAppendingString:@"?q=%@&page=%@&per_page=%@&sort=%@&order=desc"], query, [NSNumber numberWithInteger:page], [NSNumber numberWithInt:20], self.sort];
    
    [[HTTPRequest sharedInstance] getRequest:request successHandler:^(id response) {
        
        if(response){
            
            self.totalNumberOfItems = [response[@"total_count"] integerValue];
            NSArray *itemsArray = response[@"items"];
            __block NSMutableArray<GIRepository*> *repositoriesMutableArray = [NSMutableArray array];
            [itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                GIRepository *repository = [GIRepository repositoryWithDictionary:(NSDictionary*)obj];
                [repositoriesMutableArray addObject:repository];
                
            }];
            
            self.repositories = [self.repositories arrayByAddingObjectsFromArray:repositoriesMutableArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showSpinner:NO hiddeTableView:NO];
                [self.searchResultTableView reloadData];
            });
        }
        
    } failureHandler:^(id error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.spinner.hidden = YES;
            [self.spinner stopAnimating];
            self.searchResultTableView.hidden = YES;
            self.noDataLabel.hidden = NO;
        });
       
    }];

}

#pragma mark - Custom Accessors

- (void)doneButtonPressed:(id)sender{
    
    [self.queryTextField resignFirstResponder];
}

- (void)textFieldDoneEditing:(UITextField*)sender{
    
    self.currentPage = 1;
    self.query = sender.text;
    self.repositories = [NSArray array];
    [self showSpinner:YES hiddeTableView:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sort by"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *forksAction = [UIAlertAction actionWithTitle:@"Forks" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.sort = @"forks";
                                                              [self fetchGitHubRepositoriesForPage:self.currentPage withQuery:self.query];
                                                          }];
    
    UIAlertAction *updatedAction = [UIAlertAction actionWithTitle:@"Updated" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            self.sort = @"updated";
                                                            [self fetchGitHubRepositoriesForPage:self.currentPage withQuery:self.query];
                                                        }];
    
    UIAlertAction *starsAction = [UIAlertAction actionWithTitle:@"Stars" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              self.sort = @"stars";
                                                              [self fetchGitHubRepositoriesForPage:self.currentPage withQuery:self.query];
                                                          }];
    
    [alert addAction:forksAction];
    [alert addAction:updatedAction];
    [alert addAction:starsAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showSpinner:(BOOL)showSpinner hiddeTableView:(BOOL)hiddeTableView{
    
    if(!self.noDataLabel.hidden){
        self.noDataLabel.hidden = YES;
    }
    
    self.spinner.hidden = !showSpinner;
    self.searchResultTableView.hidden = hiddeTableView;
    
    if(!showSpinner){
        [self.spinner stopAnimating];
    }
    else{
        [self.spinner startAnimating];
    }
}
@end
