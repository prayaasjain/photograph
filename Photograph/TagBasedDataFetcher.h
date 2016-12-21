//
//  TagBasedDataFetcher.h
//  Photograph
//
//  Created by Prayaas Jain on 10/24/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedData.h"

@interface TagBasedDataFetcher : NSObject {
    NSData *responseData;
}

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *searchTag;

- (id)initWithToken:(NSString *)token andTag:(NSString *)tag;
- (void)fetchData;

@end
