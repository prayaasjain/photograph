//
//  PictureCell.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "PictureCell.h"
#import "MediaPostLike.h"
#import "MediaDeleteLike.h"

@implementation PictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(PictureCellData *)pdata {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pictureData = pdata;
        [self setupCellView];
    }
    return self;
}

- (void)setupCellView {
    [self setSeparatorInset:UIEdgeInsetsZero];
    [self setPreservesSuperviewLayoutMargins:NO];
    [self setLayoutMargins:UIEdgeInsetsZero];
    [self setBackgroundColor:[UIColor whiteColor]];

    likedImage = [UIImage imageNamed:@"liked"];
    notLikedImage = [UIImage imageNamed:@"notLiked"];
    currentLikes = [self.pictureData.likes intValue];

    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.usernameLabel setTextColor:[UIColor blackColor]];
    [self.usernameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.usernameLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Semibold size:14]];
    [self.usernameLabel setNumberOfLines:0];
    [self.usernameLabel sizeToFit];
    self.usernameLabel.text = self.pictureData.username;
    self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameLabel.adjustsFontSizeToFitWidth = NO;

    if (self.pictureData.image) {
        self.mainImage = [[UIImageView alloc] initWithImage:self.pictureData.image];
        self.mainImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        self.mainImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageLoading"]];
        self.mainImage.contentMode = UIViewContentModeCenter;
    }
    self.mainImage.backgroundColor = [UIColor photographBackgroundColor];
    self.mainImage.translatesAutoresizingMaskIntoConstraints = NO;

    self.likesImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"likes"]];
    self.likesImage.contentMode = UIViewContentModeScaleAspectFit;
    self.likesImage.translatesAutoresizingMaskIntoConstraints = NO;

    self.likesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.likesLabel setTextColor:[UIColor blackColor]];
    [self.likesLabel setTextAlignment:NSTextAlignmentCenter];
    [self.likesLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:12]];
    [self.likesLabel setNumberOfLines:0];
    [self.likesLabel sizeToFit];
    self.likesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.likesLabel.adjustsFontSizeToFitWidth = NO;

    [self updateLikesLabelWithCount:currentLikes];

    self.captionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.captionLabel setTextColor:[UIColor blackColor]];
    [self.captionLabel setTextAlignment:NSTextAlignmentLeft];
    [self.captionLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:12]];
    [self.captionLabel setNumberOfLines:0];
    [self.captionLabel sizeToFit];
    self.captionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.captionLabel.adjustsFontSizeToFitWidth = NO;

    NSMutableAttributedString *captionString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.pictureData.username, self.pictureData.caption]];
    [captionString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AppFont_SF_UI_Text_Semibold size:12] range:NSMakeRange(0, self.pictureData.username.length)];
    [captionString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AppFont_SF_UI_Text_Regular size:12] range:NSMakeRange(self.pictureData.username.length+1, self.pictureData.caption.length)];

    self.captionLabel.attributedText = captionString;

    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton addTarget:self
                        action:@selector(likeButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    self.likeButton.translatesAutoresizingMaskIntoConstraints = NO;

    if (self.pictureData.userLiked) {
        self.likeState = LIKED;
        [self.likeButton setImage:likedImage forState:UIControlStateNormal];
    }
    else {
        self.likeState = NOT_LIKED;
        [self.likeButton setImage:notLikedImage forState:UIControlStateNormal];
    }

    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.mainImage];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.likesImage];
    [self.contentView addSubview:self.likesLabel];
    [self.contentView addSubview:self.captionLabel];

    [self setupConstraintsForCellView];
}

- (void)setupConstraintsForCellView {
    NSLayoutConstraint *usernameLabelLeftConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.usernameLabel attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual toItem:self.contentView
                                                       attribute:NSLayoutAttributeLeft multiplier:1 constant:10];

    NSLayoutConstraint *usernameLabelTopConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.usernameLabel attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual toItem:self.contentView
                                                      attribute:NSLayoutAttributeTop multiplier:1 constant:15];

    NSLayoutConstraint *mainImageCenterXConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.mainImage attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual toItem:self.contentView
                                                      attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *mainImageTopConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.mainImage attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual toItem:self.usernameLabel
                                                  attribute:NSLayoutAttributeBottom multiplier:1 constant:15];

    NSLayoutConstraint *mainImageWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.mainImage attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual toItem:self.contentView
                                                    attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *mainImageHeightConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.mainImage attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual toItem:self.contentView
                                                     attribute:NSLayoutAttributeWidth multiplier:1 constant:0];

    NSLayoutConstraint *likeButtonLeftConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.likeButton attribute:NSLayoutAttributeLeft
                                                    relatedBy:NSLayoutRelationEqual toItem:self.usernameLabel
                                                    attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *likeButtonTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.likeButton attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual toItem:self.mainImage
                                                   attribute:NSLayoutAttributeBottom multiplier:1 constant:5];

    NSLayoutConstraint *likeButtonWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.likeButton attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:likedImage.size.width];
    NSLayoutConstraint *likeButtonHeightConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.likeButton attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:likedImage.size.height];

    NSLayoutConstraint *likesImageLeftConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.likesImage attribute:NSLayoutAttributeLeft
                                                    relatedBy:NSLayoutRelationEqual toItem:self.usernameLabel
                                                    attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *likesImageTopConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.likesImage attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual toItem:self.likeButton
                                                   attribute:NSLayoutAttributeBottom multiplier:1 constant:5];

    NSLayoutConstraint *likesLabelLeftConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.likesLabel attribute:NSLayoutAttributeLeft
                                                    relatedBy:NSLayoutRelationEqual toItem:self.likesImage
                                                    attribute:NSLayoutAttributeRight multiplier:1 constant:5];
    NSLayoutConstraint *likesLabelCenterYConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.likesLabel attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual toItem:self.likesImage
                                                       attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    NSLayoutConstraint *captionLabelLeftConstraint = [NSLayoutConstraint
                                                      constraintWithItem:self.captionLabel attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual toItem:self.usernameLabel
                                                      attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *captionLabelTopConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.captionLabel attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual toItem:self.likesImage
                                                     attribute:NSLayoutAttributeBottom multiplier:1 constant:5];

    NSLayoutConstraint *captionLabelWidthConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.captionLabel attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView
                                                     attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0];



    [self addConstraints:@[usernameLabelLeftConstraint, usernameLabelTopConstraint,
                           mainImageCenterXConstraint, mainImageTopConstraint, mainImageWidthConstraint, mainImageHeightConstraint,
                           likeButtonLeftConstraint, likeButtonTopConstraint, likeButtonWidthConstraint, likeButtonHeightConstraint,
                           likesImageLeftConstraint, likesImageTopConstraint,
                           likesLabelLeftConstraint, likesLabelCenterYConstraint,
                           captionLabelLeftConstraint, captionLabelTopConstraint, captionLabelWidthConstraint]];
}

- (void)updateLikesLabelWithCount:(NSInteger)likes {
    if (likes == 1) {
        self.likesLabel.text = [NSString stringWithFormat:@"%ld like", likes];
    }
    else {
        self.likesLabel.text = [NSString stringWithFormat:@"%ld likes", likes];
    }
}

- (IBAction)likeButtonPressed:(id)sender {
    switch (self.likeState) {
        case LIKED:
            self.likeState = NOT_LIKED;
            currentLikes--;
            [self.likeButton setImage:notLikedImage forState:UIControlStateNormal];
            [self removeLike];
            break;

        case NOT_LIKED:
            self.likeState = LIKED;
            currentLikes++;
            [self.likeButton setImage:likedImage forState:UIControlStateNormal];
            [self postLike];
            break;

        default:
            break;
    }

    [self updateLikesLabelWithCount:currentLikes];
}

- (void)postLike {
    MediaPostLike *mpl = [[MediaPostLike alloc] initWithMediaID:self.pictureData.media_id];
    [mpl commitLike];
}

- (void)removeLike {
    MediaDeleteLike *mdl = [[MediaDeleteLike alloc] initWithMediaID:self.pictureData.media_id];
    [mdl uncommitLike];
}

@end
