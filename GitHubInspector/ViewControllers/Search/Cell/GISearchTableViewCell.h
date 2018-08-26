//
//  GISearchTableViewCell.h
//  GitHubInspector
//
//  Created by Sanja Biletić on 24/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIRepository, GISearchTableViewCell;
@protocol GISearchTableViewCellDelegate <NSObject>

- (void)searchTableViewCell:(GISearchTableViewCell*)cell  openUserDetailsWithRepository:(GIRepository*)repository;

@end

@interface GISearchTableViewCell : UITableViewCell

@property (weak, nonatomic) id <GISearchTableViewCellDelegate> delegate;
@property (strong, nonatomic) GIRepository *repository;

@end
