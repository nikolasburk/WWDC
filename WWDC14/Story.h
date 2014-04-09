//
//  Story.h
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kStoryID @"storyID"
#define kTitle @"title"
#define kParagraphs @"paragraphs"
#define kImages @"images"
#define kTime @"time"
#define kYear @"year"
#define kMonth @"month"

#define MAX_PARAGRAPHS 3
#define MAX_IMAGES 3

@interface Story : NSObject

@property (nonatomic, strong, readonly) NSString *storyID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSArray *paragraphs;
@property (nonatomic, strong, readonly) NSArray *images;
@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;


- (id)initWithTitle:(NSString *)title paragraphs:(NSArray *)paragraphs images:(NSArray *)images time:(NSDictionary *)time;
- (id)initWithStoryInfo:(NSDictionary *)storyInfo;

- (NSString *)monthName;

@end
