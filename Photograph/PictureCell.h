//
//  PictureCell.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureCellData.h"

typedef enum {LIKED, NOT_LIKED} LikeState;

@interface PictureCell : UITableViewCell {
    UIImage *likedImage;
    UIImage *notLikedImage;
    NSInteger currentLikes;
}

@property (nonatomic, strong) UIImageView *mainImage;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *likesImage;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic, strong) UILabel *captionLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) PictureCellData *pictureData;
@property (nonatomic, assign) LikeState likeState;

/**
 Returns an instance of PictureCell initialized with the picture data passed to the method.
 @param pdata contains the relevant data needed to display the picture and its information
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(PictureCellData *)pdata;

@end
