//
//  StoryBuilder.h
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#define STORIES_FILE_PATH @"Stories"
#define SUFFIX_PLIST @"plist"


#import <Foundation/Foundation.h>
#import "Story.h"

@interface StoryBuilder : NSObject

@property (nonatomic, strong, readonly) NSArray *stories;

+ (StoryBuilder *)storyBuilderSharedInstance;

@end
