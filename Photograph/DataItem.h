//
//  DataItem.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Caption.h"
#import "Location.h"
#import "Image.h"

@interface DataItem : NSObject

@property (nonatomic, strong) NSString *data_id;            //map key "id" to data_id
@property (nonatomic, strong) NSNumber *comments;           //get corresponding single-entry dictionary, extract value for key "count" and map to comments
@property (nonatomic, strong) NSString *created_time;
@property (nonatomic, strong) Caption *caption;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSNumber *likes;              //get corresponding single-entry dictionary, extract value for key "count" and map to likes
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *users_in_photo;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *images;              //extract corresponding dictionary and create Image objects for each entry
@property (nonatomic, assign) BOOL user_has_liked;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *attribution;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
