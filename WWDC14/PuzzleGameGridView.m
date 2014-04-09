//
//  PuzzleGameGridView.m
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "PuzzleGameGridView.h"
#import "QuestionView.h"

@interface PuzzleGameGridView ()

@property (nonatomic, strong) UIImage *puzzleImage;

@end

@implementation PuzzleGameGridView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.puzzleMode = NO;
    }
    return self;
}

- (void)setPuzzleMode:(BOOL)puzzleMode
{
    _puzzleMode = puzzleMode;
    if (_puzzleMode)
    {
        [self enableDragAndDrop];
    }
    else
    {
        [self disableDragAndDrop];
    }
    
    if ([self.puzzleGridViewDelegate respondsToSelector:@selector(puzzleGameGridView:didEnterPuzzleMode:)])
    {
        [self.puzzleGridViewDelegate puzzleGameGridView:self didEnterPuzzleMode:_puzzleMode];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [super handleTap:tapGestureRecognizer];
    NSLog(@"DEBUG | %s | Tapped view at index: %d", __func__, self.selectedViewIndex);
    if ([self.puzzleGridViewDelegate respondsToSelector:@selector(puzzleGameGridView:didSelectViewAtIndex:)])
    {
        [self.puzzleGridViewDelegate puzzleGameGridView:self didSelectViewAtIndex:self.selectedViewIndex];
    }
}

- (void)flipQuestionViewAtIndex:(NSInteger)index
{
    QuestionView *questionView = [self questionViewForIndex:index];
    [questionView flip];
}

- (QuestionView *)questionViewForIndex:(NSInteger)index
{
    QuestionView *questionView = (QuestionView *)[super viewForIndex:index];
    return questionView;
}

- (QuestionView *)questionViewForQuestion:(Question *)question
{
    NSMutableArray *contentViews = [self getContentViews];
    QuestionView *questionView = nil;
    for (QuestionView *currentQuestionView in contentViews)
    {
        if([currentQuestionView.question isEqual:question])
        {
            questionView = currentQuestionView;
            break;
        }
    }
    return questionView;
}

@end
