//
//  QuestionViewController.h
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@class QuestionViewController;

@protocol QuestionViewControllerDelegate <NSObject>

- (void)questionViewController:(QuestionViewController *)questionViewController answerWasCorrect:(BOOL)answerWasCorrect;
- (void)questionViewControllerGameOver:(QuestionViewController *)questionViewController;

@end

@interface QuestionViewController : UIViewController

@property (nonatomic, strong, readonly) Question *question;
@property (nonatomic, strong) id<QuestionViewControllerDelegate>delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil question:(Question *)question delegate:(id<QuestionViewControllerDelegate>)delegate bundle:(NSBundle *)nibBundleOrNil;
- (void)setInstructionMessage:(NSString *)instructionMessage answerCorrect:(BOOL)answerCorrect;
- (void)submitAnswer:(id)answer;

//- (void)questionWasAnsweredCorrectly:(BOOL)questionWasAnsweredCorrectly;

@end
