//
//  Location.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSNumber *location_id;            //map key "id" to location_id
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *longitude;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
