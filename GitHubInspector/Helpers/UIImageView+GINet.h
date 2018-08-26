//
//  UIImageView+GINet.h
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import <UIKit/UIKit.h>

static char const * const taskKey = "TaskKey";

@interface UIImageView (GINet)

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder;

- (void)cancelDownload;


@end
