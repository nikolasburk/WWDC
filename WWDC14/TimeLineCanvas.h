//
//  TimeLineCanvas.h
//  WWDC14
//
//  Created by Nikolas Burk on 09/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineView.h"

@interface TimeLineCanvas : UIView

@property (nonatomic, strong) TimeLineView *timeLineView;
@property (nonatomic, strong) NSArray *stories;


- (id)initWithFrame:(CGRect)frame startYear:(NSInteger)startYear endYear:(NSInteger)endYear skip:(NSRange)skip;
- (void)buildTimeLineWithWidth:(CGFloat)width startYear:(NSInteger)startYear endYear:(NSInteger)endYear skip:(NSRange)skip;

@end
