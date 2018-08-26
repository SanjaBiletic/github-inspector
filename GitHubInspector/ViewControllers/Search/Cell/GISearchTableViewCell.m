//
//  GISearchTableViewCell.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 24/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "GISearchTableViewCell.h"
#import "GIRepository.h"
#import "GIUser.h"
#import "UIImageView+GINet.h"

@interface GISearchTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *repositoryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfWatcherLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfForksLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfIssuesLabel;

@end

@implementation GISearchTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2.0;
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageTapped:)];
    [self.avatarImageView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setters

- (void)setRepository:(GIRepository *)repository{
    
    if(repository){
        
        _repository = repository;
        [self setCellElements];
    }
}

- (void)setCellElements{
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:_repository.user.userImage] placeholderImage:nil];
    self.authorLabel.text = self.repository.user.userLogin ? self.repository.user.userLogin : @"-";
    self.repositoryNameLabel.text = self.repository.repositoryName ? self.repository.repositoryName : @"-";
    self.numberOfForksLabel.text = [self.repository.forks stringValue] ? [self.repository.forks stringValue] : @"-";
    self.numberOfIssuesLabel.text = [self.repository.openIssues stringValue] ? [self.repository.openIssues stringValue] : @"-";
    self.numberOfWatcherLabel.text = [self.repository.watchers stringValue] ? [self.repository.watchers stringValue] : @"-";
}

#pragma mark - Custom Accessors

- (void)avatarImageTapped:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(searchTableViewCell:openUserDetailsWithRepository:)]) {
        [self.delegate searchTableViewCell:self openUserDetailsWithRepository:self.repository];
    }
}
@end
