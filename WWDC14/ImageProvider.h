//
//  ImageProvider.h
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Split.h"

#define NUMBER_OF_MEMES 15


@interface ImageProvider : NSObject

@property (nonatomic, strong) NSArray *memes;

+ (UIImage *)cropCenteredSquareFromImage:(UIImage *)image;
+ (ImageProvider *)imageProviderSharedInstance;

- (NSArray *)randomMemeImages:(NSInteger)numberOfRandomImages;
- (UIImage *)randomMemeImage;

@end
