//
//  GINet.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "GINet.h"

@implementation GINet

+ (id)sharedNBNet
{
    static GINet *sharedNBNet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNBNet = [[self alloc] init];
    });
    return sharedNBNet;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.netOperationQueue = [[NSOperationQueue alloc] init];
        self.netOperationQueue.maxConcurrentOperationCount = 3;
        self.netOperationQueue.name = @"Net Operations";
        
        NSURLSessionConfiguration *sessionImageConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionImageConfiguration.timeoutIntervalForResource = 6;
        sessionImageConfiguration.HTTPMaximumConnectionsPerHost = 2;
        sessionImageConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        self.imageSession = [NSURLSession sessionWithConfiguration:sessionImageConfiguration delegate:nil delegateQueue:_netOperationQueue];
    }
    return self;
}

- (NSURLSessionTask *)imageWithURL:(NSURL *)url
                           success:(void (^)(UIImage *image))success
                           failure:(void (^)(NSError *error))failure {
    
    NSURLSessionTask *task = [self.imageSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        return failure(error);
        if (response)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image)
                success(image);
            });
        });
    }];
    
    [task resume];
    return task;
}


@end
