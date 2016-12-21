//
//  ImageDownloader.h
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

/*
 Abstract:
 Helper object for managing the downloading of images.
 It uses NSURLSession/NSURLSessionDataTask to download the required images in the background if it does not
 yet exist and works in conjunction with the HomeFeedViewController to manage which PictureCells need their images.

 Class built using Apple's LazyTable project as a reference:
 https://developer.apple.com/library/content/samplecode/LazyTableImages/Listings/LazyTableImages_Classes_LazyTableAppDelegate_m.html#//apple_ref/doc/uid/DTS40009394-LazyTableImages_Classes_LazyTableAppDelegate_m-DontLinkElementID_9
 */

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject

@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) UIImage *downloadedImage;
@property (nonatomic, copy) void (^completionHandler)(UIImage *image);

- (void)setMaxWidthForImage:(CGFloat)width;
- (void)startDownload;
- (void)cancelDownload;

@end
