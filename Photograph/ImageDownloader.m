//
//  ImageDownloader.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "ImageDownloader.h"
#import "PictureCellData.h"

@interface ImageDownloader () {
    CGFloat maxWidth;
}

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

@implementation ImageDownloader

- (void)setMaxWidthForImage:(CGFloat)width {
    maxWidth = width;
}

- (void)startDownload {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.pictureURL]];

    // session data task to download the image
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (error != nil) {
                            // TODO: Handle error from API call
                            NSLog(@"ERROR: %@", [error localizedDescription]);
                        }

                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                            // set image and resize if needed
                            UIImage *image = [[UIImage alloc] initWithData:data];

                            // image will be resized to a square and the width defines the limiting dimension
                            if(image.size.width >= maxWidth || image.size.height >= maxWidth) {
                                CGSize imgSize = CGSizeMake(maxWidth, maxWidth);
                                UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0f);
                                CGRect imgRect = CGRectMake(0.0, 0.0, imgSize.width, imgSize.height);
                                [image drawInRect:imgRect];
                                self.downloadedImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                            }
                            else {
                                self.downloadedImage = image;
                            }

                            // call our completion handler to tell our client that our image is ready for display
                            if (self.completionHandler != nil) {
                                self.completionHandler(self.downloadedImage);
                            }
                        }];
                    }];

    [self.sessionTask resume];
}

- (void)cancelDownload {
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end
