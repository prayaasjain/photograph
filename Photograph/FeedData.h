//
//  FeedData.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataItem.h"

@interface FeedData : NSObject

@property (nonatomic, strong) NSNumber *code;           //get corresponding single-entry dictionary, extract value for key "code" and map to code
@property (nonatomic, strong) NSArray *dataItems;       //extract dictionary corresponding to key "data" and populate array with DataItem objects
@property (nonatomic, strong) NSDictionary *pagination;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
