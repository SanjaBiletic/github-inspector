//
//  GINet.h
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GINet : NSObject

@property(nonatomic, strong) NSURLSession *imageSession;
@property(nonatomic, strong) NSOperationQueue *netOperationQueue;

+ (id)sharedNBNet;
- (NSURLSessionTask *)imageWithURL:(NSURL *)url
                           success:(void (^)(UIImage *image))success
                           failure:(void (^)(NSError *error))failure;

@end
