//
//  TimeLineView.h
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TIME_LINE_HEIGHT 75.0

@interface TimeLineView : UIView

@property (nonatomic, assign, readonly) NSInteger startYear;
@property (nonatomic, assign, readonly) NSInteger endYear;
@property (nonatomic, assign, readonly) NSRange skip; // gives the opportunity to skip a certain range
@property (nonatomic, assign, readonly) CGFloat intervalSize; // width for each step


- (id)initWithStartYear:(NSInteger)startYear endYear:(NSInteger)endYear skip:(NSRange)skip width:(CGFloat)width;

@end
