//
//  TimeLineCanvas.h
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineView.h"

@class TimeLineCanvas, StoryThumbnail, Story;

@protocol TimeLineCanvasDelegate <NSObject>

- (void)timeLineCanvas:(TimeLineCanvas *)timeLineCanvas didSelectStoryThumbnail:(StoryThumbnail *)storyThumbnail;

@end


@interface TimeLineCanvas : UIView

@property (nonatomic, strong, readonly) TimeLineView *timeLineView;
@property (nonatomic, strong, readonly) NSArray *stories;
@property (nonatomic, strong) id<TimeLineCanvasDelegate> delegate;

- (void)buildTimeLineWithWidth:(CGFloat)width startYear:(NSInteger)startYear endYear:(NSInteger)endYear skip:(NSRange)skip;
- (void)addStoryThumbnailToCanvasForStory:(Story *)story;

@end
