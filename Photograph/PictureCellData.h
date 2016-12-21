//
//  PictureCellData.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureCellData : NSObject

@property (nonatomic, strong) NSString *media_id;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, assign) BOOL userLiked;


@end
