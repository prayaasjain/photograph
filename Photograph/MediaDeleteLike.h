//
//  MediaDeleteLike.h
//  Photograph
//
//  Created by Prayaas Jain on 10/26/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaDeleteLike : NSObject {
    NSString *media_id;
}

- (id)initWithMediaID:(NSString *)mediaID;
- (void)uncommitLike;

@end
