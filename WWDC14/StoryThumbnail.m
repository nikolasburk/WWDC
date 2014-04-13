//
//  StoryThumbnail.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "StoryThumbnail.h"
#import "UIView+Decoration.h"
#import "Colors.h"

@interface StoryThumbnail ()

@property (nonatomic, strong) UIImageView *background;

@end

@implementation StoryThumbnail

- (id)initWithFrame:(CGRect)frame story:(Story *)story
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _story = story;
        self.background = [[UIImageView alloc] initWithImage:story.images[0]];
        [self.background setFrame:self.bounds];
        [self addSubview:self.background];
        [self buildFrameView];
    }
    return self;
}

- (void)buildFrameView
{
    const CGFloat frameWidth = 2.5;

    [self addDecorativeFrameWithWidth:frameWidth color:DARK_GREEN];
//    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, frameWidth)];
//    topLine.backgroundColor = [UIColor redColor];
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height-frameWidth, self.bounds.size.width, frameWidth)];
//    bottomLine.backgroundColor = [UIColor redColor];
//    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, self.bounds.size.height)];
//    leftLine.backgroundColor = [UIColor redColor];
//    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width-frameWidth, 0.0, frameWidth, self.bounds.size.height)];
//    rightLine.backgroundColor = [UIColor redColor];
//    
//    UIView *frameView = [[UIView alloc] initWithFrame:self.bounds];
//    frameView.backgroundColor = [UIColor clearColor];
//    [frameView addSubview:topLine];
//    [frameView addSubview:bottomLine];
//    [frameView addSubview:leftLine];
//    [frameView addSubview:rightLine];
//    
//    [self addSubview:frameView];
}



@end
