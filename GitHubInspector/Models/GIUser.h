//
//  GIUser.h
//  GitHubInspector
//
//  Created by Sanja Biletić on 25/08/2018.
//  Copyright © 2018 Sanja Biletić. All rights reserved.
//

#import "RLMObject.h"

@interface GIUser : RLMObject

@property NSNumber<RLMInt> *userID;
@property NSString *userLogin;
@property NSString *userName;
@property NSString *userImage;
@property NSString *htmlURL;
@property NSString *company;
@property NSDate *createdDate;
@property NSDate *updatedDate;
@property NSString *location;

+ (GIUser*)userWithDictionary:(NSDictionary*)dictionary;

@end
