//
//  QuestionView.m
//  WWDC14
//
//  Created by Nikolas Burk on 07/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "QuestionView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "math.h"

#define TRIES_LEFT_LABEL_TAG 42

@interface QuestionView ()

@property (nonatomic, strong) UIView *categoryTopView;
@property (nonatomic, assign) UIView *questionViewFrame;

@end

@implementation QuestionView

- (id)initWithFrame:(CGRect)frame question:(Question *)question puzzlePiece:(PuzzlePiece *)puzzlePiece
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _question = question;
        _categoryOnTop = YES;
        _puzzlePiece = puzzlePiece;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = puzzlePiece;
        [self addSubview:imageView];
//        self.backgroundColor = [UIColor redColor];
        
        if (!self.question.answered)
        {
            self.categoryTopView = [self categoryTopViewForCurrentQuestion];
            [self addSubview:self.categoryTopView];
        }

        
        [self buildFrameView];
    }
    return self;
}

- (void)flip
{
    _categoryOnTop = !_categoryOnTop;
    
    if (_categoryOnTop)
    {
        
    }
    else
    {
        [UIView animateWithDuration:1.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.categoryTopView.layer.transform = CATransform3DMakeRotation(M_PI_2,1.0,0.0,0.0); //flip halfway
        } completion:^(BOOL finished){
            [self.categoryTopView removeFromSuperview];
        }];
    }
    

}

- (void)updateTriesLeft
{
    if (_categoryOnTop)
    {
        NSLog(@"DEBUG | %s | Question: %@", __func__, self.question);
        UILabel *triesLeftLabel;
        for (UIView *subiew in self.categoryTopView.subviews)
        {
            if (subiew.tag == TRIES_LEFT_LABEL_TAG)
            {
                triesLeftLabel = (UILabel *)subiew;
                break;
            }
        }
        triesLeftLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Tries left: %d", nil), self.question.triesLeft];
    }
}

- (void)buildFrameView
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 1.0)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height-1.0, self.bounds.size.width, 1.0)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, self.bounds.size.height)];
    leftLine.backgroundColor = [UIColor lightGrayColor];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width-1.0, 0.0, 1.0, self.bounds.size.height)];
    rightLine.backgroundColor = [UIColor lightGrayColor];
    
    UIView *frameView = [[UIView alloc] initWithFrame:self.bounds];
    frameView.backgroundColor = [UIColor clearColor];
    [frameView addSubview:topLine];
    [frameView addSubview:bottomLine];
    [frameView addSubview:leftLine];
    [frameView addSubview:rightLine];
    
    [self addSubview:frameView];
}

- (UIView *)categoryTopViewForCurrentQuestion
{
    UIView *categoryTopView = [[UIView alloc] initWithFrame:self.bounds];
    categoryTopView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height / 2.0)];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:50.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self.question questionCategoryString];
    [categoryTopView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height / 2.0, self.bounds.size.width, self.bounds.size.height / 2.0)];
    label.tag = TRIES_LEFT_LABEL_TAG;
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:35.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:NSLocalizedString(@"Tries left: %d", nil), self.question.triesLeft];
    [categoryTopView addSubview:label];
    
    return categoryTopView;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"%@ | Category on top: %@ | Puzzle index: %d | %@", [super description], self.categoryOnTop ? @"YES" : @"NO", self.puzzlePiece.originalIndex, self.question];
    return description;
}

@end
