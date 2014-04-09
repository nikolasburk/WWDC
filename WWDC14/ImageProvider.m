//
//  ImageProvider.m
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "ImageProvider.h"

@implementation ImageProvider

#pragma mark - Singleton

static ImageProvider *imageProviderSharedInstance  = nil;

+ (ImageProvider *)imageProviderSharedInstance{
    {
        @synchronized(self) {
            if (imageProviderSharedInstance == nil)
                imageProviderSharedInstance = [[self alloc] init];
        }
        return imageProviderSharedInstance;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _memes = [self importMemeImages];
    }
    return self;
}

- (NSArray *)importMemeImages
{
    NSMutableArray *memeImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUMBER_OF_MEMES; i++)
    {
        NSString *currentMemeName = [NSString stringWithFormat:@"meme_%d", i];
        UIImage *currentMeme = [UIImage imageNamed:currentMemeName];
        [memeImages addObject:currentMeme];
    }
    return memeImages;
}

- (NSArray *)randomMemeImages:(NSInteger)numberOfRandomImages
{
    NSMutableArray *randomMemeImages=  [[NSMutableArray alloc] init];
    NSMutableArray *allMemeImages = [[NSMutableArray alloc] initWithArray:self.memes];
    for (int i = 0; i < numberOfRandomImages; i++)
    {
        NSUInteger randomIndex = arc4random_uniform([allMemeImages count]);
        UIImage *meme = allMemeImages[randomIndex];
        [randomMemeImages addObject:meme];
        [allMemeImages removeObject:meme];
    }
    return randomMemeImages;
}

- (UIImage *)randomMemeImage
{
    NSUInteger randomIndex = arc4random_uniform([self.memes count]);
    return self.memes[randomIndex];
}

@end
