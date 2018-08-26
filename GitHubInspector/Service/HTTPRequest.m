//
//  HTTPRequest.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 24/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest () <NSURLSessionDelegate>

@end

@implementation HTTPRequest

+ (id)sharedInstance{
    
    static HTTPRequest *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken , ^{
        
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (void)getRequest:(NSString*)request successHandler:(void (^)(id response))successHandler failureHandler:(void (^)(id error))failureHandler{
    
    NSURL *url = [NSURL URLWithString:request];
    NSMutableURLRequest *getRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    getRequest.HTTPMethod = @"GET";
    
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:getRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        if(!error){
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
            NSInteger responseStatusCode = [httpResponse statusCode];
            
            switch (responseStatusCode)
            {
                case 0:
                    NSLog(@"Server not responding");
                    break;
                    
                case 200:
                    if (successHandler){
                        successHandler(json);
                    }
                    break;
                default:
                    if (failureHandler){
                        failureHandler(json);
                    }
                    break;
            }
        }
        else{
            
            if(failureHandler){
                failureHandler(error);
            }
        }
    }];
    
    [dataTask resume];
}



@end
