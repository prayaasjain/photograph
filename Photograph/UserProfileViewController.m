//
//  UserProfileViewController.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ImageDownloader.h"
#import "DataManager.h"

@interface UserProfileViewController () <ProfileRefreshDelegate> {
    UIImageView *profileImageView;
    UIImage *profileImage;
    UILabel *nameLabel;
    UILabel *bioLabel;
    UITextView *websiteLink;
    UILabel *postCountLabel;
    UILabel *postLabel;
    UILabel *followersCountLabel;
    UILabel *followersLabel;
    UILabel *followingCountLabel;
    UILabel *followingLabel;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[DataManager getInstance] setProfileDelegate:self];

    if(self.user == nil) {
        self.user = [[DataManager getInstance] getFetchedUserProfileData];
    }

    [self setupProfileView];
}

- (void)setupProfileView {
    profileImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    profileImageView.image = [UIImage imageNamed:@"catProfile"];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.translatesAutoresizingMaskIntoConstraints = NO;

    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setTextColor:[UIColor grayColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Semibold size:16]];
    [nameLabel setNumberOfLines:0];
    [nameLabel sizeToFit];
    nameLabel.text = @"Loading profile...";
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.adjustsFontSizeToFitWidth = NO;

    bioLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [bioLabel setTextColor:[UIColor blackColor]];
    [bioLabel setTextAlignment:NSTextAlignmentCenter];
    [bioLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:16]];
    [bioLabel setNumberOfLines:0];
    [bioLabel sizeToFit];
    bioLabel.hidden = YES;
    bioLabel.translatesAutoresizingMaskIntoConstraints = NO;
    bioLabel.adjustsFontSizeToFitWidth = NO;

    websiteLink = [[UITextView alloc] initWithFrame:CGRectZero];
    [websiteLink setTextColor:[UIColor blackColor]];
    [websiteLink setTextAlignment:NSTextAlignmentCenter];
    [websiteLink setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:16]];
    [websiteLink sizeToFit];
    websiteLink.editable = NO;
    websiteLink.dataDetectorTypes = UIDataDetectorTypeAll;
    websiteLink.hidden = YES;
    websiteLink.translatesAutoresizingMaskIntoConstraints = NO;

    postCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [postCountLabel setTextColor:[UIColor blackColor]];
    [postCountLabel setTextAlignment:NSTextAlignmentCenter];
    [postCountLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Semibold size:16]];
    [postCountLabel setNumberOfLines:0];
    [postCountLabel sizeToFit];
    postCountLabel.hidden = YES;
    postCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    postCountLabel.adjustsFontSizeToFitWidth = NO;

    postLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [postLabel setTextColor:[UIColor grayColor]];
    [postLabel setTextAlignment:NSTextAlignmentCenter];
    [postLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:12]];
    [postLabel setNumberOfLines:0];
    [postLabel sizeToFit];
    postLabel.text = @"posts";
    postLabel.hidden = YES;
    postLabel.translatesAutoresizingMaskIntoConstraints = NO;
    postLabel.adjustsFontSizeToFitWidth = NO;

    followersCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [followersCountLabel setTextColor:[UIColor blackColor]];
    [followersCountLabel setTextAlignment:NSTextAlignmentCenter];
    [followersCountLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Semibold size:16]];
    [followersCountLabel setNumberOfLines:0];
    [followersCountLabel sizeToFit];
    followersCountLabel.hidden = YES;
    followersCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    followersCountLabel.adjustsFontSizeToFitWidth = NO;

    followersLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [followersLabel setTextColor:[UIColor grayColor]];
    [followersLabel setTextAlignment:NSTextAlignmentCenter];
    [followersLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:12]];
    [followersLabel setNumberOfLines:0];
    [followersLabel sizeToFit];
    followersLabel.text = @"followers";
    followersLabel.hidden = YES;
    followersLabel.translatesAutoresizingMaskIntoConstraints = NO;
    followersLabel.adjustsFontSizeToFitWidth = NO;

    followingCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [followingCountLabel setTextColor:[UIColor blackColor]];
    [followingCountLabel setTextAlignment:NSTextAlignmentCenter];
    [followingCountLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Semibold size:16]];
    [followingCountLabel setNumberOfLines:0];
    [followingCountLabel sizeToFit];
    followingCountLabel.hidden = YES;
    followingCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    followingCountLabel.adjustsFontSizeToFitWidth = NO;

    followingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [followingLabel setTextColor:[UIColor grayColor]];
    [followingLabel setTextAlignment:NSTextAlignmentCenter];
    [followingLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:12]];
    [followingLabel setNumberOfLines:0];
    [followingLabel sizeToFit];
    followingLabel.text = @"following";
    followingLabel.hidden = YES;
    followingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    followingLabel.adjustsFontSizeToFitWidth = NO;

    [self.view addSubview:nameLabel];
    [self.view addSubview:bioLabel];
    [self.view addSubview:websiteLink];
    [self.view addSubview:postCountLabel];
    [self.view addSubview:postLabel];
    [self.view addSubview:followersCountLabel];
    [self.view addSubview:followersLabel];
    [self.view addSubview:followingCountLabel];
    [self.view addSubview:followingLabel];
    [self.view addSubview:profileImageView];

    [self setupConstraintsForProfileView];
}

- (void)updateProfileViewWithUserData {
    if (profileImage != nil) {
        [self formatProfileImageView];
    }

    nameLabel.text = self.user.full_name;
    nameLabel.textColor = [UIColor blackColor];

    bioLabel.text = self.user.bio;
    bioLabel.hidden = NO;

    websiteLink.text = self.user.website;
    websiteLink.hidden = NO;

    postCountLabel.text = [NSString stringWithFormat:@"%@", self.user.mediaCount];
    postCountLabel.hidden = NO;
    postLabel.hidden = NO;

    followersCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followersCount];
    followersCountLabel.hidden = NO;

    if ([self.user.followersCount intValue] == 1)
        followersLabel.text = @"follower";
    followersLabel.hidden = NO;

    followingCountLabel.text = [NSString stringWithFormat:@"%@", self.user.followingCount];
    followingCountLabel.hidden = NO;
    followingLabel.hidden = NO;
}

- (void)setupConstraintsForProfileView {
    NSLayoutConstraint *profileImageCenterYConstraint = [NSLayoutConstraint
                                                         constraintWithItem:profileImageView attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual toItem:self.view
                                                         attribute:NSLayoutAttributeCenterY multiplier:0.5 constant:0];
    NSLayoutConstraint *profileImageCenterXConstraint  = [NSLayoutConstraint
                                                          constraintWithItem:profileImageView attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

    NSLayoutConstraint *profileImageWidthConstraint  = [NSLayoutConstraint
                                                        constraintWithItem:profileImageView attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual toItem:nil
                                                        attribute:NSLayoutAttributeWidth multiplier:1 constant:140];
    NSLayoutConstraint *profileImageHeightConstraint  = [NSLayoutConstraint
                                                         constraintWithItem:profileImageView attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual toItem:profileImageView
                                                         attribute:NSLayoutAttributeWidth multiplier:1 constant:0];

    NSLayoutConstraint *nameLabelTopConstraint = [NSLayoutConstraint
                                                  constraintWithItem:nameLabel attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:profileImageView
                                                  attribute:NSLayoutAttributeBottom multiplier:1 constant:25];
    NSLayoutConstraint *nameLabelCenterXConstraint  = [NSLayoutConstraint
                                                       constraintWithItem:nameLabel attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual toItem:self.view
                                                       attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

    NSLayoutConstraint *bioLabelTopConstraint = [NSLayoutConstraint
                                                 constraintWithItem:bioLabel attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual toItem:nameLabel
                                                 attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
    NSLayoutConstraint *bioLabelCenterXConstraint  = [NSLayoutConstraint
                                                      constraintWithItem:bioLabel attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual toItem:self.view
                                                      attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

    NSLayoutConstraint *websiteLinkTopConstraint = [NSLayoutConstraint
                                                    constraintWithItem:websiteLink attribute:NSLayoutAttributeTop
                                                    relatedBy:NSLayoutRelationEqual toItem:bioLabel
                                                    attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
    NSLayoutConstraint *websiteLinkCenterXConstraint  = [NSLayoutConstraint
                                                         constraintWithItem:websiteLink attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual toItem:self.view
                                                         attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

    NSLayoutConstraint *websiteLinkWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:websiteLink attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.view
                                                    attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0];
    NSLayoutConstraint *websiteLinkHeightConstraint  = [NSLayoutConstraint
                                                         constraintWithItem:websiteLink attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual toItem:bioLabel
                                                         attribute:NSLayoutAttributeHeight multiplier:1 constant:0];

    NSLayoutConstraint *followersCountLabelTopConstraint = [NSLayoutConstraint
                                                            constraintWithItem:followersCountLabel attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual toItem:websiteLink
                                                            attribute:NSLayoutAttributeBottom multiplier:1 constant:30];
    NSLayoutConstraint *followersCountLabelCenterXConstraint  = [NSLayoutConstraint
                                                                 constraintWithItem:followersCountLabel attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                                                 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

    NSLayoutConstraint *followersLabelTopConstraint = [NSLayoutConstraint
                                                       constraintWithItem:followersLabel attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual toItem:followersCountLabel
                                                       attribute:NSLayoutAttributeBottom multiplier:1 constant:2];
    NSLayoutConstraint *followersLabelCenterXConstraint  = [NSLayoutConstraint
                                                            constraintWithItem:followersLabel attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual toItem:followersCountLabel
                                                            attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

    NSLayoutConstraint *postCountLabelTopConstraint = [NSLayoutConstraint
                                                       constraintWithItem:postCountLabel attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual toItem:followersCountLabel
                                                       attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *postCountLabelCenterXConstraint  = [NSLayoutConstraint
                                                            constraintWithItem:postCountLabel attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual toItem:self.view
                                                            attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0];

    NSLayoutConstraint *postLabelTopConstraint = [NSLayoutConstraint
                                                  constraintWithItem:postLabel attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:postCountLabel
                                                  attribute:NSLayoutAttributeBottom multiplier:1 constant:2];
    NSLayoutConstraint *postLabelCenterXConstraint  = [NSLayoutConstraint
                                                       constraintWithItem:postLabel attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual toItem:postCountLabel
                                                       attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];

    NSLayoutConstraint *followingCountLabelTopConstraint = [NSLayoutConstraint
                                                            constraintWithItem:followingCountLabel attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual toItem:followersCountLabel
                                                            attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *followingCountLabelCenterXConstraint  = [NSLayoutConstraint
                                                                 constraintWithItem:followingCountLabel attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                                                 attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0];

    NSLayoutConstraint *followingLabelTopConstraint = [NSLayoutConstraint
                                                       constraintWithItem:followingLabel attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual toItem:followingCountLabel
                                                       attribute:NSLayoutAttributeBottom multiplier:1 constant:2];
    NSLayoutConstraint *followingLabelCenterXConstraint  = [NSLayoutConstraint
                                                            constraintWithItem:followingLabel attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual toItem:followingCountLabel
                                                            attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];


    [self.view addConstraints:@[profileImageCenterXConstraint,profileImageCenterYConstraint,profileImageWidthConstraint,profileImageHeightConstraint,
                                nameLabelTopConstraint, nameLabelCenterXConstraint,
                                bioLabelTopConstraint, bioLabelCenterXConstraint,
                                websiteLinkTopConstraint, websiteLinkCenterXConstraint, websiteLinkWidthConstraint, websiteLinkHeightConstraint,
                                followersCountLabelTopConstraint, followersCountLabelCenterXConstraint, followersLabelTopConstraint, followersLabelCenterXConstraint,
                                postCountLabelTopConstraint, postCountLabelCenterXConstraint, postLabelTopConstraint, postLabelCenterXConstraint,
                                followingCountLabelTopConstraint, followingCountLabelCenterXConstraint, followingLabelTopConstraint, followingLabelCenterXConstraint]];
}

- (void)formatProfileImageView {
    profileImageView.image = profileImage;
    profileImageView.layer.cornerRadius = 70;
    profileImageView.clipsToBounds = YES;
}

#pragma mark - Download Profile Image
- (void)downloadProfileImage {
    ImageDownloader *imgDownloader = [[ImageDownloader alloc] init];
    [imgDownloader setMaxWidthForImage:210];
    imgDownloader.pictureURL = self.user.profile_picture;
    [imgDownloader setMaxWidthForImage:self.view.frame.size.width];

    [imgDownloader setCompletionHandler:^(UIImage *image){
        // display the newly loaded image
        profileImage = image;
        [self formatProfileImageView];
    }];
    [imgDownloader startDownload];
}

#pragma mark - ProfileRefreshDelegate Methods
- (void)refreshWithUserData:(User *)uData {
    self.user = uData;
    [self downloadProfileImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProfileViewWithUserData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
