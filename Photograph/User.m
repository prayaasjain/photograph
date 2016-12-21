//
//  User.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.user_id = value;
    }
    else if ([key isEqualToString:@"counts"]) {
        NSDictionary *dict = value;
        for (id key in [dict allKeys]) {
            if ([key isEqualToString:@"media"]) {
                self.mediaCount = (dict)[key];
            }
            if ([key isEqualToString:@"followed_by"]) {
                self.followersCount = (dict)[key];
            }
            if ([key isEqualToString:@"follows"]) {
                self.followingCount = (dict)[key];
            }
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Found undefined key: %@", key);
}

@end
