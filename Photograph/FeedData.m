//
//  FeedData.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "FeedData.h"

@implementation FeedData

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
        NSMutableArray *data = [NSMutableArray new];
        for (NSDictionary *dict in value) {
            [data addObject:[[DataItem alloc] initWithDictionary:dict]];
        }
        self.dataItems = data;
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Found undefined key: %@", key);
}

@end
