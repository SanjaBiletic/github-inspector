//
//  GIUserDetailsViewController.h
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIRepository;
@interface GIUserDetailsViewController : UIViewController

@property (strong, nonatomic) GIRepository *repository;

@end
