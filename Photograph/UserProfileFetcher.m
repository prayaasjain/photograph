//
//  UserProfileFetcher.m
//  Photograph
//
//  Created by Prayaas Jain on 10/27/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "UserProfileFetcher.h"
#import "DataManager.h"
#import "UserData.h"

@implementation UserProfileFetcher

- (id)initWithToken:(NSString *)token {
    if(self = [super init]) {
        self.accessToken  = token;
    }
    return self;
}

- (void)fetchData {
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/?access_token=%@", self.accessToken]];
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

            UserData *uData = [[UserData alloc] initWithDictionary:jsonDict];
            [[DataManager getInstance] setUserDataAndRefreshProfile:uData];
        }
    }];

    [sessionTask resume];

    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
