//
//  GIUser.m
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "GIUser.h"

@implementation GIUser

+ (NSString *)primaryKey
{
    return @"userID";
}

+ (GIUser*)userWithDictionary:(NSDictionary *)dictionary{
    
    GIUser *user = [GIUser new];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    user.userID = [GIUser getFromDictionary:dictionary[@"id"]];
    user.userLogin = [GIUser getFromDictionary:dictionary[@"login"]];
    user.userName = [GIUser getFromDictionary:dictionary[@"name"]];
    user.userImage = [GIUser getFromDictionary:dictionary[@"avatar_url"]];
    user.htmlURL = [GIUser getFromDictionary:dictionary[@"html_url"]];
    user.company = [GIUser getFromDictionary:dictionary[@"company"]];
    user.location = [GIUser getFromDictionary:dictionary[@"location"]];
    user.createdDate = [GIUser getFromDictionary:[dateFormatter dateFromString:dictionary[@"created_at"]]];
    user.updatedDate = [GIUser getFromDictionary:[dateFormatter dateFromString:dictionary[@"updated_at"]]];
    
    return user;

}

+ (id)getFromDictionary:(id)object{
    
    if (object == [NSNull null]) {
        return nil;
    }
    
    return object;
}

@end
