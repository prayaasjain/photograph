//
//  UIColor+Utils.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (PhotographColor)

+ (UIColor *)photographUIColorFromRGB:(NSUInteger)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+(id)photographBackgroundColor {
    return [UIColor photographUIColorFromRGB:0xF2F4F5];
}

@end
