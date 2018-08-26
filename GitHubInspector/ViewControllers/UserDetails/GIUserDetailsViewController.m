//
//  GIUserDetailsViewController.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "GIUserDetailsViewController.h"
#import "HTTPRequest.h"
#import "GIRepository.h"
#import "GIUser.h"
#import "UIImageView+GINet.h"
#import <PureLayout/PureLayout.h>

static CGFloat const offset = 16.0;
static CGFloat const userImageWidthAndHeight = 200.0;

@interface GIUserDetailsViewController ()

@property (strong, nonnull) GIUser *user;

@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *userLoginLabel;
@property (strong, nonatomic) UILabel *companyLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *createdAtLabel;
@property (strong, nonatomic) UILabel *updatedAtLabel;
@property (strong, nonatomic) UIButton *showMoreButton;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation GIUserDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"User details";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.userImageView.contentMode = UIViewContentModeScaleToFill;
    self.userImageView.backgroundColor = [UIColor lightGrayColor];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = userImageWidthAndHeight/2.0;
    self.userImageView.hidden = YES;
    [self.view addSubview:self.userImageView];
    [self.userImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:80.0];
    [self.userImageView autoSetDimension:ALDimensionWidth toSize:userImageWidthAndHeight];
    [self.userImageView autoSetDimension:ALDimensionHeight toSize:userImageWidthAndHeight];
    [self.userImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.font = [UIFont systemFontOfSize:20.0f];
    self.userNameLabel.textColor = [UIColor blackColor];
    self.userNameLabel.hidden = YES;
    [self.view addSubview:self.userNameLabel];
    [self.userNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageView withOffset:offset];
    [self.userNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.userNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.userNameLabel autoSetDimension:ALDimensionHeight toSize:self.userNameLabel.font.lineHeight];
    
    self.userLoginLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.userLoginLabel.textAlignment = NSTextAlignmentCenter;
    self.userLoginLabel.font = [UIFont systemFontOfSize:20.0f];
    self.userLoginLabel.textColor = [UIColor blackColor];
    self.userLoginLabel.hidden = YES;
    [self.view addSubview:self.userLoginLabel];
    [self.userLoginLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userNameLabel];
    [self.userLoginLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.userLoginLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.userLoginLabel autoSetDimension:ALDimensionHeight toSize:self.userLoginLabel.font.lineHeight];
    
    self.createdAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.createdAtLabel.textAlignment = NSTextAlignmentCenter;
    self.createdAtLabel.font = [UIFont systemFontOfSize:20.0f];
    self.createdAtLabel.textColor = [UIColor blackColor];
    self.createdAtLabel.hidden = YES;
    [self.view addSubview:self.createdAtLabel];
    [self.createdAtLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userLoginLabel];
    [self.createdAtLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.createdAtLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.createdAtLabel autoSetDimension:ALDimensionHeight toSize:self.createdAtLabel.font.lineHeight];
    
    self.updatedAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.updatedAtLabel.textAlignment = NSTextAlignmentCenter;
    self.updatedAtLabel.font = [UIFont systemFontOfSize:20.0f];
    self.updatedAtLabel.textColor = [UIColor blackColor];
    self.updatedAtLabel.hidden = YES;
    [self.view addSubview:self.updatedAtLabel];
    [self.updatedAtLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.createdAtLabel];
    [self.updatedAtLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.updatedAtLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.updatedAtLabel autoSetDimension:ALDimensionHeight toSize:self.updatedAtLabel.font.lineHeight];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    self.locationLabel.font = [UIFont systemFontOfSize:20.0f];
    self.locationLabel.textColor = [UIColor blackColor];
    self.locationLabel.hidden = YES;
    [self.view addSubview:self.locationLabel];
    [self.locationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.updatedAtLabel];
    [self.locationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.locationLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.locationLabel autoSetDimension:ALDimensionHeight toSize:self.locationLabel.font.lineHeight];
    
    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.companyLabel.textAlignment = NSTextAlignmentCenter;
    self.companyLabel.font = [UIFont systemFontOfSize:20.0f];
    self.companyLabel.textColor = [UIColor blackColor];
    self.companyLabel.hidden = YES;
    [self.view addSubview:self.companyLabel];
    [self.companyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.locationLabel];
    [self.companyLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.companyLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [self.companyLabel autoSetDimension:ALDimensionHeight toSize:self.companyLabel.font.lineHeight];
    
    self.showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showMoreButton addTarget:self action:@selector(openBrowser:) forControlEvents:UIControlEventTouchUpInside];
    [self.showMoreButton setTitle:@"Show more" forState:UIControlStateNormal];
    [self.showMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.showMoreButton.layer.masksToBounds = YES;
    self.showMoreButton.layer.cornerRadius = 2.0;
    self.showMoreButton.backgroundColor = [UIColor lightGrayColor];
    self.showMoreButton.layer.borderColor = self.showMoreButton.backgroundColor.CGColor;
    self.showMoreButton.layer.borderWidth = 1.0;
    self.showMoreButton.hidden = YES;
    [self.view addSubview:self.showMoreButton];
    [self.showMoreButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.companyLabel withOffset:3*offset];
    [self.showMoreButton autoSetDimension:ALDimensionWidth toSize:10*offset];
    [self.showMoreButton autoSetDimension:ALDimensionHeight toSize:3*offset];
    [self.showMoreButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.hidden = YES;
    [self.view addSubview:self.spinner];
    [self.spinner autoCenterInSuperview];
    
     [self fetchUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters

- (void)setupViews{
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:_user.userImage] placeholderImage:nil];
    self.userImageView.hidden = NO;
    
    self.userNameLabel.text = [NSString stringWithFormat:@"Name: %@", self.user.userName ? self.user.userName : @"-" ];
    self.userNameLabel.hidden = NO;
    
    self.userLoginLabel.text = [NSString stringWithFormat:@"Login: %@", self.user.userLogin ? self.user.userLogin : @"-" ];
    self.userLoginLabel.hidden = NO;
    
    NSString *createdDate = [self.dateFormatter stringFromDate:_user.createdDate];
    self.createdAtLabel.text = [NSString stringWithFormat:@"Created at: %@", createdDate ? createdDate : @"-"];
    self.createdAtLabel.hidden = NO;
    
    NSString *updatedDate = [self.dateFormatter stringFromDate:_user.updatedDate];
    self.updatedAtLabel.text = [NSString stringWithFormat:@"Updated at: %@", updatedDate ? updatedDate : @"-"];
    self.updatedAtLabel.hidden = NO;
    
    self.locationLabel.text = [NSString stringWithFormat:@"Location: %@", self.user.location ? self.user.location : @"-"];
    self.locationLabel.hidden  = NO;
    
    self.companyLabel.text = [NSString stringWithFormat:@"Company: %@", self.user.company ? self.user.company : @"-"];
    self.companyLabel.hidden = NO;
    
    self.showMoreButton.hidden = NO;
    
}

#pragma mark - Custom Accessors

- (void)openBrowser:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.user.htmlURL] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

#pragma mark - Networking

- (void)fetchUserData{
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    NSString *request = [NSString stringWithFormat:userURL, self.repository.user.userLogin];
    
    [[HTTPRequest sharedInstance] getRequest:request successHandler:^(id response) {
      
        if(response){
            
            self.user = [GIUser userWithDictionary:(NSDictionary*)response];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.spinner stopAnimating];
                self.spinner.hidden = YES;
                
                [self setupViews];
            });
        }
        
    } failureHandler:^(id error) {
        
    }];
}


@end
