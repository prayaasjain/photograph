//
//  DataItemManager.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "DataManager.h"
#import "TagBasedDataFetcher.h"
#import "UserProfileFetcher.h"
#import "DataItem.h"
#import "PictureCellData.h"

static DataManager *dataManager;

@implementation DataManager

+ (id)getInstance {
    @synchronized (self) {
        if (dataManager == nil) {
            dataManager = [[self alloc] _init];
        }
        return dataManager;
    }
}

- (id)_init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)setAccessToken:(NSString *)token {
    accessToken = token;
}

- (NSString *)getAccessToken {
    return accessToken;
}

#pragma mark - Fetch Operations
- (void)setFeedDataAndPopulateModel:(FeedData *)fdata {
    self.feedData = fdata;
    [self populatePictureCellData:self.feedData.dataItems];
    [self.refreshDelegate refreshWithData:self.pictureDataItems];
}

- (void)setUserDataAndRefreshProfile:(UserData *)udata {
    self.userData = udata;
    [self.profileDelegate refreshWithUserData:self.userData.user];
}

- (void)fetchTagBasedDataForTag:(NSString *)tag {
    TagBasedDataFetcher *tagFetcher = [[TagBasedDataFetcher alloc] initWithToken:accessToken andTag:tag];
    [tagFetcher fetchData];
}

- (void)fetchCurrentUserProfile {
    UserProfileFetcher *profileFetcher = [[UserProfileFetcher alloc] initWithToken:accessToken];
    [profileFetcher fetchData];
}

- (NSArray *)getFetchedTagBasedDataItems {
    return self.pictureDataItems;
}

- (User *)getFetchedUserProfileData {
    return self.userData.user;
}

- (void)populatePictureCellData:(NSArray *)fetchedDataItems {
    NSMutableArray *array = [NSMutableArray new];
    for (DataItem *di in fetchedDataItems) {
        PictureCellData *pcData = [[PictureCellData alloc] init];
        for (Image *img in di.images) {
            if ([img.type isEqualToString:@"standard_resolution"]) {
                pcData.imageURLString = img.url;
            }
        }
        pcData.media_id = di.data_id;
        pcData.username = di.user.username;
        pcData.likes = di.likes;
        pcData.caption = di.caption.text;
        pcData.userLiked = di.user_has_liked;

        [array addObject:pcData];
    }
    self.pictureDataItems = array;
}

@end
