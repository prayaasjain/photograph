//
//  DataItem.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.data_id = value;
    }
    else if ([key isEqualToString:@"comments"]) {
        self.comments = [value objectForKey:@"count"];
    }
    else if ([key isEqualToString:@"caption"]) {
        self.caption = [[Caption alloc] initWithDictionary:value];
    }
    else if ([key isEqualToString:@"likes"]) {
        self.likes = [value objectForKey:@"count"];
    }
    else if ([key isEqualToString:@"location"]) {
        self.location = [[Location alloc] initWithDictionary:value];
    }
    else if ([key isEqualToString:@"images"]) {
        NSDictionary *imgs = [NSDictionary dictionaryWithDictionary:value];
        NSMutableArray *imgArray = [NSMutableArray new];
        for (id key in [imgs allKeys]) {
            [imgArray addObject:[[Image alloc] initWithDictionary:[imgs objectForKey:key] andType:key]];
        }
        self.images = imgArray;
    }
    else if ([key isEqualToString:@"user"]) {
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
