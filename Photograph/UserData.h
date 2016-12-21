//
//  UserData.h
//  Photograph
//
//  Created by Prayaas Jain on 10/27/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserData : NSObject

@property (nonatomic, strong) NSNumber *code;           //get corresponding single-entry dictionary, extract value for key "code" and map to code
@property (nonatomic, strong) User *user;       //extract dictionary corresponding to key "data" and populate User object

- (id)initWithDictionary:(NSDictionary *)dict;

@end
