//
//  HollowButton.m
//  Photograph
//
//  Created by Prayaas Jain on 10/24/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "HollowButton.h"

@implementation HollowButton

- (id)init {
    self = [super init];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Display_Regular size:18]];
        [self setAlpha:1.0];
        [[self layer] setCornerRadius:2.0];
        [[self layer] setBorderWidth:1.0f];
        [[self layer] setBorderColor:[UIColor blackColor].CGColor];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if(!enabled) {
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [[self layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    }
    else {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[self layer] setBorderColor:[UIColor blackColor].CGColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if(highlighted) {
        [self setBackgroundColor:[UIColor grayColor]];
         [[self layer] setBorderColor:[UIColor grayColor].CGColor];
    }
    else {
        [self setBackgroundColor:[UIColor clearColor]];
         [[self layer] setBorderColor:[UIColor blackColor].CGColor];
    }
}

@end
