//
//  UIImageView+GINet.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "UIImageView+GINet.h"
#import "GINet.h"
#import <objc/runtime.h>

@interface UIImageView (NBNetProperty)

@property(nonatomic, strong) NSURLSessionTask *task;

@end

@implementation UIImageView (NBNet)

- (NSURLSessionTask *)task
{
    return objc_getAssociatedObject(self,
                                    &taskKey);
}

- (void)setTask:(NSURLSessionTask *)newTask
{
    objc_setAssociatedObject(self,
                             &taskKey,
                             newTask,
                             OBJC_ASSOCIATION_COPY);
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
{
    
    self.image = placeholder;
    GINet *net = [GINet sharedNBNet];
    
    NSURLSessionTask *dTask = [net imageWithURL:url success:^(UIImage *image) {
        self.image = image;
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    self.task = dTask;
}

- (void)cancelDownload
{
    [self.task cancel];
}

@end
