//
//  Image.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "Image.h"

@implementation Image

- (id)initWithDictionary:(NSDictionary *)dict andType:(NSString *)type {
    if (self = [super init]) {
        self.type = type;
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Found undefined key: %@", key);
}

@end
