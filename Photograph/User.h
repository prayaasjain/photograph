//
//  User.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *user_id;            //map key "id" to user_id
@property (nonatomic, strong) NSString *profile_picture;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSNumber *mediaCount;
@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSNumber *followingCount;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
