//
//  UIView+Decoration.m
//  WWDC14
//
//  Created by Nikolas Burk on 12/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "UIView+Decoration.h"

@implementation UIView (Decoration)

- (void)addDecorativeFrameWithWidth:(CGFloat)frameWidth color:(UIColor *)frameColor
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, frameWidth)];
    topLine.backgroundColor = frameColor;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height-frameWidth, self.bounds.size.width, frameWidth)];
    bottomLine.backgroundColor = frameColor;
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, self.bounds.size.height)];
    leftLine.backgroundColor = frameColor;
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width-frameWidth, 0.0, frameWidth, self.bounds.size.height)];
    rightLine.backgroundColor = frameColor;
    
    UIView *frameView = [[UIView alloc] initWithFrame:self.bounds];
    frameView.backgroundColor = [UIColor clearColor];
    [frameView addSubview:topLine];
    [frameView addSubview:bottomLine];
    [frameView addSubview:leftLine];
    [frameView addSubview:rightLine];
    
    [self addSubview:frameView];
}

@end
