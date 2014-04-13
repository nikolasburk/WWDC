//
//  QuestionViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "QuestionViewController.h"
#import "ReplyReader.h"
#import "Colors.h"

#define HELP_SHAKE_NIBNAME_SUFFIX @"Questions"

@interface QuestionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *triesLeftLabel;

- (IBAction)cancelButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)helpShakeButtonPressed;

@end

@implementation QuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil question:(Question *)question delegate:(id<QuestionViewControllerDelegate>)delegate bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _question = question;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.categoryLabel.text = [self.question questionCategoryString];
    self.categoryLabel.backgroundColor = [self.question categoryColor];
    self.categoryLabel.textColor = [UIColor whiteColor];
    
    self.questionTextView.text = self.question.questionString;
    
    self.triesLeftLabel.layer.cornerRadius = 2.5;
    [self updateTriesLeft];
    
    self.backButton.layer.cornerRadius = 5.0;
    self.backButton.backgroundColor = [UIColor darkGrayColor];

    self.view.backgroundColor = SNOW_2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.instructionsTextView.text = [self.question instructionTextString];
}

- (void)submitAnswer:(id)answer
{
    NSLog(@"DEBUG | %s | Answer: %@", __func__, answer);
    BOOL answerCorrect = [self.question answer:answer];
    [self updateTriesLeft];
    if (self.question.triesLeft == 0)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(questionViewControllerGameOver:)])
            {
                [self.delegate questionViewControllerGameOver:self];
            }
        }];
    }
    else
    {
        [self questionWasAnsweredCorrectly:answerCorrect];

    }
}

- (void)questionWasAnsweredCorrectly:(BOOL)questionWasAnsweredCorrectly
{
    NSString *instructionMessage = [[ReplyReader replyReaderSharedInstance] randomReply:questionWasAnsweredCorrectly];
    [self setInstructionMessage:instructionMessage answerCorrect:questionWasAnsweredCorrectly];
}

- (IBAction)cancelButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"DEBUG | %s | Question: %@", __func__, self.question);
    if ([self.delegate respondsToSelector:@selector(questionViewController:answerWasCorrect:)])
    {
        [self.delegate questionViewController:self answerWasCorrect:self.question.answered];
    }
}

- (void)updateTriesLeft
{
    self.triesLeftLabel.text = [NSString stringWithFormat:@"%d", self.question.triesLeft];
    self.triesLeftLabel.backgroundColor = [self.question currentStatusColor];
}

- (void)setInstructionMessage:(NSString *)instructionMessage
{
    self.instructionsTextView.text = instructionMessage;
    self.instructionsTextView.font = [UIFont systemFontOfSize:18.0];
    self.instructionsTextView.textAlignment = NSTextAlignmentCenter;
}

- (void)setInstructionMessage:(NSString *)instructionMessage answerCorrect:(BOOL)answerCorrect
{
    self.instructionsTextView.hidden = YES;
    
    UIColor *textColor = answerCorrect ? DARK_GREEN : FIREBRICK;
    CGFloat duration = answerCorrect ? 1.0 : 2.5;
    
    self.instructionsTextView.textColor = textColor;
    [self setInstructionMessage:instructionMessage];
    
    [UIView animateWithDuration:duration animations:^{
        self.instructionsTextView.hidden = NO;
    } completion:nil];
}


#pragma mark - Help shake

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"DEBUG | %s | Got shaked", __func__);
        [HelpShakeViewController openHelpShakeViewControllerWithViewController:self];
    }
}

- (NSString *)nibNameSuffix
{
    return HELP_SHAKE_NIBNAME_SUFFIX;
}

- (IBAction)helpShakeButtonPressed
{
    [HelpShakeViewController showHelpShakeInfo];
}
@end
