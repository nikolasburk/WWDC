//
//  StoryBuilder.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "StoryBuilder.h"
#import "Story.h"

@implementation StoryBuilder

#pragma mark - Singleton

static StoryBuilder *storyBuilderSharedInstance = nil;

- (id)init
{
    self = [super init];
    if (self)
    {
        _stories = [self generateStories];
    }
    return self;
}

+ (StoryBuilder *)storyBuilderSharedInstance
{
    @synchronized(self) {
        if (storyBuilderSharedInstance == nil)
            storyBuilderSharedInstance = [[self alloc] init];
    }
    return storyBuilderSharedInstance;
}

- (NSArray *)generateStories
{
    NSMutableArray *stories = [[NSMutableArray alloc] init];
    
    // Path to the plist (in the application bundle)
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:STORIES_FILE_PATH ofType:SUFFIX_PLIST];
    
    // Build the array from the plist
    NSMutableArray *rawStories = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *storyDictionary in rawStories)
    {
        Story *story = [[Story alloc] initWithStoryInfo:storyDictionary];
        [stories addObject:story];
    }

    return stories;
}

@end
