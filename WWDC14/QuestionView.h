//
//  QuestionView.h
//  WWDC14
//
//  Created by Nikolas Burk on 07/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import "Question.h"
#import "PuzzlePiece.h"

@interface QuestionView : UIView

@property (nonatomic, strong, readonly) Question *question;
@property (nonatomic, strong, readonly) PuzzlePiece *puzzlePiece;
@property (nonatomic, assign, readonly) BOOL categoryOnTop;

- (id)initWithFrame:(CGRect)frame question:(Question *)question puzzlePiece:(PuzzlePiece *)puzzlePiece;

- (void)flip;
- (void)updateTriesLeft;

@end
