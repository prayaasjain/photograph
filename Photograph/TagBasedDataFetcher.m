//
//  TagBasedDataFetcher.m
//  Photograph
//
//  Created by Prayaas Jain on 10/24/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

/*
 Abstract:
 Class to fetch data from one of the Tag Endpoints provided by Instagram
 */

#import "TagBasedDataFetcher.h"
#import "DataManager.h"
#import "HomeFeedViewController.h"

@implementation TagBasedDataFetcher

- (id)initWithToken:(NSString *)token andTag:(NSString *)tag {
    if(self = [super init]) {
        self.accessToken  = token;
        self.searchTag = tag;
    }
    return self;
}

- (void)fetchData {
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@", self.searchTag, self.accessToken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"GET"];

    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error != nil) {
            // TODO: Handle error from API call
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }
        else {
            // successfully retrieved data
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"Received json data: %@", jsonDict);

            FeedData *fData = [[FeedData alloc] initWithDictionary:jsonDict];
            [[DataManager getInstance] setFeedDataAndPopulateModel:fData];
        }
    }];

    [sessionTask resume];

    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
