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
#import "UIView+Decoration.h"
#import "CategoryView.h"

#define TRIES_LEFT_LABEL_TAG 42

@interface QuestionView ()

@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *triesLeftLabel;

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
        self.triesLeftLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d", nil), self.question.triesLeft];
        self.triesLeftLabel.backgroundColor = [self.question currentStatusColor];
    }
}

- (void)buildFrameView
{
    [self addDecorativeFrameWithWidth:1.0 color:[UIColor blackColor]];
}

- (UIView *)categoryTopViewForCurrentQuestion
{
    UIView *categoryTopView = [[UIView alloc] initWithFrame:self.bounds];
    categoryTopView.backgroundColor = [UIColor whiteColor];
    
    CGFloat half = self.frame.size.width / 2.0;
    
    CGFloat xCutPortion = 10.0;
    CGFloat yCutPortion = 10.0;

    CGFloat x = self.bounds.size.width / xCutPortion;
    CGFloat y = self.frame.size.height / yCutPortion;
    CGFloat height = half - y;
    CGFloat width = self.bounds.size.width - 2.0 * x;
    
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.categoryLabel.adjustsFontSizeToFitWidth = YES;
    self.categoryLabel.font = [UIFont systemFontOfSize:50.0];
    self.categoryLabel.textColor = [UIColor whiteColor];
    self.categoryLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryLabel.text = [self.question questionCategoryString];
    self.categoryLabel.backgroundColor = [self.question categoryColor];
    [categoryTopView addSubview:self.categoryLabel];
    
    self.categoryLabel.layer.cornerRadius = 5.0;
    self.categoryLabel.layer.masksToBounds = YES;

    yCutPortion = 2.5;
    
    x = 0.0;
    y = half + self.frame.size.height / yCutPortion;
    height = half - 2.0 * self.frame.size.height / yCutPortion;
    width = height;

    self.triesLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.triesLeftLabel.center = CGPointMake(self.bounds.size.width / 2.0, self.triesLeftLabel.center.y);
    self.triesLeftLabel.adjustsFontSizeToFitWidth = YES;
    self.triesLeftLabel.tag = TRIES_LEFT_LABEL_TAG;
    self.triesLeftLabel.backgroundColor = [self.question currentStatusColor];
    self.triesLeftLabel.font = [UIFont boldSystemFontOfSize:50.0];
    self.triesLeftLabel.textAlignment = NSTextAlignmentCenter;
    self.triesLeftLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d", nil), self.question.triesLeft];
    self.triesLeftLabel.textColor = [UIColor whiteColor];
    [categoryTopView addSubview:self.triesLeftLabel];
    
    self.triesLeftLabel.layer.cornerRadius = 5.0;
    self.triesLeftLabel.layer.masksToBounds = YES;
    
    return categoryTopView;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"%@ | Category on top: %@ | Puzzle index: %d | %@", [super description], self.categoryOnTop ? @"YES" : @"NO", self.puzzlePiece.originalIndex, self.question];
    return description;
}

@end
