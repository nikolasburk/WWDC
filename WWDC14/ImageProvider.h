//
//  ImageProvider.h
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Split.h"

#define NUMBER_OF_MEMES 16


@interface ImageProvider : NSObject

@property (nonatomic, strong) NSArray *memes;

+ (ImageProvider *)imageProviderSharedInstance;

- (NSArray *)randomMemeImages:(NSInteger)numberOfRandomImages;
- (UIImage *)randomImage;

@end
