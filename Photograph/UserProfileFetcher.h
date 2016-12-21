//
//  UserProfileFetcher.h
//  Photograph
//
//  Created by Prayaas Jain on 10/27/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileFetcher : NSObject {
    NSData *responseData;
}

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *searchTag;

- (id)initWithToken:(NSString *)token;
- (void)fetchData;

@end
