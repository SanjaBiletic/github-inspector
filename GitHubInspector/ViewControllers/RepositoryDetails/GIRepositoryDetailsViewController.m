//
//  GIRepositoryDetailsViewController.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "GIRepositoryDetailsViewController.h"
#import "GIRepository.h"
#import "GIUser.h"
#import "GIUserDetailsViewController.h"
#import <PureLayout/PureLayout.h>

static CGFloat const offset = 16.0;

@interface GIRepositoryDetailsViewController ()

@property (strong, nonatomic) UILabel *repositoryNameLabel;
@property (strong, nonatomic) UILabel *languageLabel;
@property (strong, nonatomic) UILabel *createdDateLabel;
@property (strong, nonatomic) UILabel *updatedDateLabel;
@property (strong, nonatomic) UIButton *authorButton;
@property (strong, nonatomic) UIButton *showMoreButton;

@end

@implementation GIRepositoryDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Repository details";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.repositoryNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.repositoryNameLabel.font = [UIFont systemFontOfSize:20.0f];
    self.repositoryNameLabel.textAlignment = NSTextAlignmentLeft;
    self.repositoryNameLabel.textColor = [UIColor blackColor];
    self.repositoryNameLabel.text = [NSString stringWithFormat:@"Name: %@", self.repository.repositoryName ? self.repository.repositoryName : @"-"];
    self.repositoryNameLabel.numberOfLines = 0;
    self.repositoryNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:self.repositoryNameLabel];
    [self.repositoryNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:80.0];
    [self.repositoryNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:offset];
    [self.repositoryNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-offset];
    CGSize maxLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*16.0, 1000.0);
    CGFloat height = [self.repositoryNameLabel.text boundingRectWithSize:maxLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName: UIColor.blackColor} context:nil].size.height;
    [self.repositoryNameLabel autoSetDimension:ALDimensionHeight toSize:height];
    
    self.languageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.languageLabel.font = [UIFont systemFontOfSize:20.0f];
    self.languageLabel.textAlignment = NSTextAlignmentLeft;
    self.languageLabel.textColor = [UIColor blackColor];
    self.languageLabel.text = [NSString stringWithFormat:@"Language: %@", self.repository.language ? self.repository.language : @"-"];
    [self.view addSubview:self.languageLabel];
    [self.languageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.repositoryNameLabel withOffset:offset/2.0];
    [self.languageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:offset];
    [self.languageLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-offset];
    [self.languageLabel autoSetDimension:ALDimensionHeight toSize:self.languageLabel.font.lineHeight];
    
    self.createdDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.createdDateLabel.font = [UIFont systemFontOfSize:20.0f];
    self.createdDateLabel.textAlignment = NSTextAlignmentLeft;
    self.createdDateLabel.textColor = [UIColor blackColor];
    NSString *createdDate = [dateFormatter stringFromDate:_repository.createdDate];
    self.createdDateLabel.text = [NSString stringWithFormat:@"Created at: %@", createdDate ? createdDate : @"-"];
    [self.view addSubview:self.createdDateLabel];
    [self.createdDateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.languageLabel withOffset:offset/2.0];
    [self.createdDateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:offset];
    [self.createdDateLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-offset];
    [self.createdDateLabel autoSetDimension:ALDimensionHeight toSize:self.createdDateLabel.font.lineHeight];
    
    self.updatedDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.updatedDateLabel.font = [UIFont systemFontOfSize:20.0f];
    self.updatedDateLabel.textAlignment = NSTextAlignmentLeft;
    self.updatedDateLabel.textColor = [UIColor blackColor];
    NSString *updatedDate = [dateFormatter stringFromDate:_repository.updatedDate];
    self.updatedDateLabel.text = [NSString  stringWithFormat:@"Updated at: %@", updatedDate ? updatedDate : @"-"];
    [self.view addSubview:self.updatedDateLabel];
    [self.updatedDateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.createdDateLabel withOffset:offset/2.0];
    [self.updatedDateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:offset];
    [self.updatedDateLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-offset];
    [self.updatedDateLabel autoSetDimension:ALDimensionHeight toSize:self.createdDateLabel.font.lineHeight];
    
    self.authorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.authorButton addTarget:self action:@selector(showUserDetails) forControlEvents:UIControlEventTouchUpInside];
    [self.authorButton setTitle:[NSString stringWithFormat:@"Author: %@", self.repository.user.userLogin ? self.repository.user.userLogin : @"-"] forState:UIControlStateNormal];
    [self.authorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.authorButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.authorButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.authorButton];
    [self.authorButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.updatedDateLabel withOffset:offset];
    [self.authorButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.authorButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.authorButton autoSetDimension:ALDimensionHeight toSize:2*offset];
    
    self.showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showMoreButton addTarget:self action:@selector(openBrowser:) forControlEvents:UIControlEventTouchUpInside];
    [self.showMoreButton setTitle:@"Show more" forState:UIControlStateNormal];
    [self.showMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.showMoreButton.layer.masksToBounds = YES;
    self.showMoreButton.layer.cornerRadius = 2.0;
    self.showMoreButton.backgroundColor = [UIColor lightGrayColor];
    self.showMoreButton.layer.borderColor = self.showMoreButton.backgroundColor.CGColor;
    self.showMoreButton.layer.borderWidth = 1.0;
    [self.view addSubview:self.showMoreButton];
    [self.showMoreButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.authorButton withOffset:3*offset];
    [self.showMoreButton autoSetDimension:ALDimensionWidth toSize:10*offset];
    [self.showMoreButton autoSetDimension:ALDimensionHeight toSize:3*offset];
    [self.showMoreButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (void)showUserDetails{
    
    GIUserDetailsViewController *userDetailsViewController = [[GIUserDetailsViewController alloc] init];
    userDetailsViewController.repository = self.repository;
    [self.navigationController pushViewController:userDetailsViewController animated:YES];
}

- (void)openBrowser:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.repository.htmlURL] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

@end
