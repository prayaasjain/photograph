//
//  Image.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject

@property (nonatomic, strong) NSString *type;           //map value of parent dictionary key - "low_resolution", etc.
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;

- (id)initWithDictionary:(NSDictionary *)dict andType:(NSString *)type;

@end
