//
//  TimeLineView.m
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "TimeLineView.h"

@interface TimeLineView ()


@end

@implementation TimeLineView

- (id)initWithStartYear:(NSInteger)startYear endYear:(NSInteger)endYear skip:(NSRange)skip width:(CGFloat)width
{
    self = [super init];
    if (self)
    {
        _startYear = startYear;
        _endYear = endYear;
        _skip = skip;
        self.frame  = CGRectMake(0.0, 0.0, width, TIME_LINE_HEIGHT);
        [self initIntervalSize];
        [self buildTimeLine];
        
    }
    return self;
}


- (void)initIntervalSize
{
    NSInteger normalizedNumberOfYears = self.endYear - self.startYear - self.skip.length + 1;
    _intervalSize = self.bounds.size.width/normalizedNumberOfYears;
    
    NSLog(@"DEBUG | %s | Interval size: %f", __func__, self.intervalSize);
}

- (void)buildTimeLine
{
    self.backgroundColor = [UIColor blackColor];
    
    //NSInteger numberOfYears = _endYear - _startYear;
    for (int i = self.startYear-1; i < self.endYear + 2; i++)
    {
        UILabel *currentYearLabel;
        
        // Dont add a year for the first and the last part of the time line
        if (i != self.startYear-1 && i != self.endYear+1)
        {
//            NSInteger factorX = i > self.skip.location ? i - self.startYear - self.skip.length + 1 :i - self.startYear + 1 ;
            NSInteger factorX = i > self.skip.location ? i - self.startYear - self.skip.length :i - self.startYear ;
            CGFloat x = self.intervalSize * factorX;
            CGFloat y = 0.0;
            CGFloat width = self.intervalSize;
            CGFloat height = self.bounds.size.height;
            currentYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
            
            NSString *yearString;
            if (i == self.skip.location)
            {
                yearString = @"...";
                i += self.skip.length;
            }
            else
            {
                yearString = [NSString stringWithFormat:@"%d", i];
            }
            currentYearLabel.text = yearString;
            currentYearLabel.textColor = [UIColor whiteColor];
            currentYearLabel.textAlignment = NSTextAlignmentCenter;
            
            
            [self addSubview:currentYearLabel];
        }
    }
}


@end
