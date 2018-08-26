//
//  HTTPRequest.h
//  GitHubInspector
//
//  Created by Sanja Biletić on 24/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequest : NSObject

+ (id)sharedInstance;

- (void)getRequest:(NSString*)request successHandler:(void (^)(id response))successHandler failureHandler:(void (^)(id error))failureHandler;

@end
