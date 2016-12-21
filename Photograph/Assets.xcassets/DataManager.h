//
//  DataItemManager.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedData.h"
#import "UserData.h"
#import "User.h"

@protocol DataRefreshDelegate <NSObject>
@required
- (void)refreshWithData:(NSArray *)data;
@end

@protocol ProfileRefreshDelegate <NSObject>
@required
- (void)refreshWithUserData:(User *)uData;
@end

@interface DataManager : NSObject {
    NSString *accessToken;
}

@property (nonatomic, strong) FeedData *feedData;
@property (nonatomic, strong) UserData *userData;
@property (nonatomic, strong) NSArray *pictureDataItems;
@property (nonatomic, weak) id<DataRefreshDelegate> refreshDelegate;
@property (nonatomic, weak) id<ProfileRefreshDelegate> profileDelegate;

+ (id)getInstance;
- (NSString *)getAccessToken;
- (NSArray *)getFetchedTagBasedDataItems;
- (User *)getFetchedUserProfileData;

- (void)setAccessToken:(NSString *)token;
- (void)setFeedDataAndPopulateModel:(FeedData *)fdata;
- (void)setUserDataAndRefreshProfile:(UserData *)udata;
- (void)fetchTagBasedDataForTag:(NSString *)tag;
- (void)fetchCurrentUserProfile;


@end
