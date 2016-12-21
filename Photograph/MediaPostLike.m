//
//  MediaPostLike.m
//  Photograph
//
//  Created by Prayaas Jain on 10/26/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "MediaPostLike.h"
#import "DataManager.h"

@implementation MediaPostLike

- (id)initWithMediaID:(NSString *)mediaID {
    if (self = [super init]) {
        media_id = mediaID;
    }
    return self;
}

- (void)commitLike {
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", media_id, [[DataManager getInstance] getAccessToken]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];

    NSURLSessionDataTask *postDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error != nil) {
            // TODO: Handle error from API call
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }
        else {
            // successfully committed like
            NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseData);
        }
    }];
    [postDataTask resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
