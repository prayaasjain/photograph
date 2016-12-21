//
//  Caption.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Caption : NSObject

@property (nonatomic, strong) User *user;               //map key "from" to user
@property (nonatomic, strong) NSString *caption_id;     //map key "id" to caption_id
@property (nonatomic, strong) NSString *created_time;
@property (nonatomic, strong) NSString *text;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
