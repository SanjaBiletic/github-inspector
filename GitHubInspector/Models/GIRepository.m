//
//  GIRepository.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 24/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "GIRepository.h"
#import "GIUser.h"

@implementation GIRepository

+ (NSString *)primaryKey
{
    return @"repositoryID";
}

+ (GIRepository*)repositoryWithDictionary:(NSDictionary*)dictionary{
    
    GIRepository *repository = [GIRepository new];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    repository.repositoryID = [GIRepository getFromDictionary:dictionary[@"id"]];
    repository.repositoryName = [GIRepository getFromDictionary:dictionary[@"name"]];
    repository.user = [GIUser userWithDictionary:[GIRepository getFromDictionary:dictionary[@"owner"]]];
    repository.watchers = [GIRepository getFromDictionary:dictionary[@"watchers"]];
    repository.forks = [GIRepository getFromDictionary:dictionary[@"forks"]];
    repository.openIssues = [GIRepository getFromDictionary:dictionary[@"open_issues"]];
    repository.language = [GIRepository getFromDictionary:dictionary[@"language"]];
    repository.createdDate = [GIRepository getFromDictionary:[dateFormatter dateFromString:dictionary[@"created_at"]]];
    repository.updatedDate = [GIRepository getFromDictionary:[dateFormatter dateFromString:dictionary[@"updated_at"]]];
    repository.htmlURL = [GIRepository getFromDictionary:dictionary[@"html_url"]];
    
    return repository;
}

+ (id)getFromDictionary:(id)object{
    
    if (object == [NSNull null]) {
        return nil;
    }
    
    return object;
}

@end
