//
//  GIRepository.h
//  GitHubInspector
//
//  Created by Sanja Biletić on 24/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "RLMObject.h"

@class GIUser;
@interface GIRepository : RLMObject

@property NSNumber<RLMInt> *repositoryID;
@property NSString *repositoryName;
@property GIUser *user;
@property NSNumber<RLMInt> *watchers;
@property NSNumber<RLMInt> *forks;
@property NSNumber<RLMInt> *openIssues;
@property NSString *language;
@property NSDate *createdDate;
@property NSDate *updatedDate;
@property NSString *htmlURL;

+ (GIRepository*)repositoryWithDictionary:(NSDictionary*)dictionary;

@end
