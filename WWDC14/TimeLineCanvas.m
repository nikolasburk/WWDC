//
//  TimeLineCanvas.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#define DEFAULT_MARGIN 20.0
#define TAB_BAR_HEIGHT 56.0

#define MIN_THUMBNAIL_DISTANCE 8.0

#import "TimeLineCanvas.h"
#import "StoryThumbnail.h"
#import "UIView+FrameModification.h"

@interface TimeLineCanvas ()

@property (nonatomic, strong) NSMutableArray *storyThumbnails;


@end

@implementation TimeLineCanvas

- (id)initWithFrame:(CGRect)frame startYear:(NSInteger)startYear endYear:(NSInteger)endYear skip:(NSRange)skip
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _timeLineView = [[TimeLineView alloc] initWithStartYear:startYear endYear:endYear skip:skip width:self.frame.size.width];
        [self addSubview:self.timeLineView];
    }
    return self;
}

- (void)buildTimeLineWithWidth:(CGFloat)width startYear:(NSInteger)startYear endYear:(NSInteger)endYear skip:(NSRange)skip
{
    self.backgroundColor = [UIColor whiteColor];
    _timeLineView = [[TimeLineView alloc] initWithStartYear:startYear endYear:endYear skip:skip width:self.frame.size.width - 2 * DEFAULT_MARGIN];
    [self.timeLineView setX:DEFAULT_MARGIN];
    [self.timeLineView setY:self.frame.size.height-self.timeLineView.frame.size.height-TAB_BAR_HEIGHT-DEFAULT_MARGIN];
    [self addSubview:self.timeLineView];
    NSLog(@"DEBUG | %s | %@", __func__, self.timeLineView);
}

- (void)addConstraintsToTimeLineView
{
    [self.timeLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLineView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:DEFAULT_MARGIN]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLineView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:DEFAULT_MARGIN]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:DEFAULT_MARGIN]];
}


- (void)setStories:(NSArray *)stories
{
    _stories = stories;
    for (Story *story in _stories)
    {
        [self addStoryThumbnailToCanvasForStory:story];
    }
}

static int counter = 0;

- (void)addStoryThumbnailToCanvasForStory:(Story *)story
{
    CGFloat x = [self xForYear:story.year month:story.month];
    CGFloat y =  [self yForThumbnailWithX:x]; // ERROR with 20th story
    CGRect frame = CGRectMake(x, y, STORY_THUMBNAIL_EDGE, STORY_THUMBNAIL_EDGE);
    StoryThumbnail *storyThumbnail = [[StoryThumbnail alloc] initWithFrame:frame story:story];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storyThumbnailTapped:)];
    [storyThumbnail addGestureRecognizer:tapGestureRecognizer];
    if (!self.storyThumbnails) self.storyThumbnails = [[NSMutableArray alloc] init];
    [self.storyThumbnails addObject:storyThumbnail];
    [self addSubview:storyThumbnail];
    NSLog(@"DEBUG | %s | Added thumbail for story: %@ (%d)", __func__, storyThumbnail.story, counter++);
}

- (void)storyThumbnailTapped:(UITapGestureRecognizer *)tap
{
    StoryThumbnail *storyThumbnail = (StoryThumbnail *)tap.view;
    if ([self.delegate respondsToSelector:@selector(timeLineCanvas:didSelectStoryThumbnail:)])
    {
        [self.delegate timeLineCanvas:self didSelectStoryThumbnail:storyThumbnail];
    }
}


- (CGFloat)xForYear:(NSInteger)year month:(NSInteger)month
{
    if (year < self.timeLineView.startYear || year > self.timeLineView.endYear)
    {
        return 0.0;
    }
    
    CGFloat x = 0.0;
    for (int i = self.timeLineView.startYear-1; i < self.timeLineView.endYear + 2; i++)
    {
        NSInteger factorX = i > self.timeLineView.skip.location ? i - self.timeLineView.startYear - self.timeLineView.skip.length :i - self.timeLineView.startYear ;
        x = self.timeLineView.intervalSize * factorX + self.timeLineView.intervalSize;
        if (i == year)
        {
            x += 1.0 - self.timeLineView.intervalSize/(CGFloat)month; // add the distance for the month
            x -= STORY_THUMBNAIL_EDGE/2.0; // center
            break;
        }
    }
    return x;
}

const CGFloat MIN_DISTANCE_FROM_TOP_FOR_STORYTHUMBNAILS = 0.0;

- (CGFloat)yForThumbnailWithX:(CGFloat)x
{
    const CGFloat yMax = self.timeLineView.frame.origin.y - STORY_THUMBNAIL_EDGE - DEFAULT_MARGIN;
    const CGFloat yMin = MIN_DISTANCE_FROM_TOP_FOR_STORYTHUMBNAILS != 0.0 ? self.frame.size.height / MIN_DISTANCE_FROM_TOP_FOR_STORYTHUMBNAILS : 0.0;
    
    CGFloat y = [self randomCGFloatWithMin:yMin max:yMax];
    while ([self requestedY:y interfersWithExistingThumbnailAtX:x])
    {
        y = [self randomCGFloatWithMin:yMin max:yMax];
    }
    return y;
}

- (BOOL)requestedY:(CGFloat)y interfersWithExistingThumbnailAtX:(CGFloat)x
{
    BOOL requestedYInterfers = NO;
    for (StoryThumbnail *storyThumbnail in self.storyThumbnails)
    {
        CGFloat xMin = storyThumbnail.frame.origin.x;
        CGFloat xMax = storyThumbnail.frame.origin.x + storyThumbnail.frame.size.width;

        if (x + STORY_THUMBNAIL_EDGE + DEFAULT_MARGIN  > xMin && x < xMax)
        {
            // interfers on x, so check y
            CGFloat yMin = storyThumbnail.frame.origin.y;
            CGFloat yMax = storyThumbnail.frame.origin.y + storyThumbnail.frame.size.height;
            
            if (y + STORY_THUMBNAIL_EDGE + DEFAULT_MARGIN > yMin && y < yMax)
            {
                requestedYInterfers = YES;
            }
        }
    }
    
    return requestedYInterfers;
}

- (CGFloat)randomCGFloatWithMin:(CGFloat)min max:(CGFloat)max
{
    CGFloat randomFloat = arc4random_uniform(max);
    if (randomFloat < min)
    {
        return [self randomCGFloatWithMin:min max:max];
    }
    return randomFloat;
}

@end
