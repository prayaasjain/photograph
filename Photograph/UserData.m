//
//  UserData.m
//  Photograph
//
//  Created by Prayaas Jain on 10/27/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "UserData.h"

@implementation UserData

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"meta"]) {
        self.code = [value objectForKey:@"code"];
    }
    else if ([key isEqualToString:@"data"]) {
        self.user = [[User alloc] initWithDictionary:value];
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Found undefined key: %@", key);
}
@end
