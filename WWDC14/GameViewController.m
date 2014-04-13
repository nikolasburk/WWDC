//
//  GameViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "GameViewController.h"
#import "QuestionReader.h"
#import "QuestionView.h"
#import "UIViewController+Alerts.h"
#import "UIViewController+FrustrationShake.h"
#import <QuartzCore/QuartzCore.h>
#import "Colors.h"

#define HELP_SHAKE_NIBNAME_SUFFIX @"Game"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet PuzzleGameGridView *puzzleGameGridView;
@property (nonatomic, assign) BOOL puzzleMode;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *gridPatternButtons;

@property (weak, nonatomic) IBOutlet UIButton *nextLevelButton;
- (IBAction)nextLevelButtonPressed;

@property (nonatomic, assign) NSInteger currentlySelectedQuestionIndex;

- (IBAction)levelButtonPressed:(id)sender;
- (IBAction)helpShakeButtonPressed;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.puzzleGameGridView.puzzleGridViewDelegate = self;
    [self.puzzleGameGridView setDelegate:self];
    [self newGame];
    
    NSLog(@"DEBUG | %s | View: %@ (bounds: width = %f; height = %f)", __func__, self.view, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)setGame:(Game *)game
{
    _game = game;
}

- (void)levelUp
{
    [self.game incrementLevel];
    NSLog(@"DEBUG | %s | Questions for current level: \n%@", __func__, self.game.questionsForCurrentLevel);
    [self.puzzleGameGridView setPuzzleMode:NO];
    [self updateUIForCurrentLevel];
}

- (void)newGame
{
    [[QuestionReader questionReaderSharedInstance] resetQuestions];
    NSDictionary *questions = [[QuestionReader questionReaderSharedInstance] questionsForNewGame];
    Game *newGame = [[Game alloc] initWithQuestions:questions];
    self.game = newGame;
    [self updateUIForCurrentLevel];
}

//- (void)setupButtons
//{
//    self.startNewGameButton.backgroundColor = SNOW_4;
//    self.startNewGameButton.layer.cornerRadius = 2.5;
//    [self.startNewGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.nextLevelButton.backgroundColor = SNOW_4;
//    self.nextLevelButton.layer.cornerRadius = 2.5;
//    [self.nextLevelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//}

- (void)updateUIForCurrentLevel
{
    [self.puzzleGameGridView clear];
    [self updateGridPattern];
    [self updateLevelButtons];
    [self initQuestionViews];
}

- (void)updateLevelButtons
{
    UIFont *activeLevelFont = [UIFont boldSystemFontOfSize:21.0];
    UIFont *inactiveLevelFont = [UIFont systemFontOfSize:16.0];
    
    for (UIButton *currentGridPatternButton in self.gridPatternButtons)
    {
        currentGridPatternButton.userInteractionEnabled = NO;
        if ((Level)currentGridPatternButton.tag <= self.game.currentLevel)
        {
            [currentGridPatternButton.titleLabel setFont:activeLevelFont];
        }
        else
        {
            [currentGridPatternButton.titleLabel setFont:inactiveLevelFont];
        }
    }
}

- (void)initQuestionViews
{
    NSArray *questionsForCurrentLevel = self.game.questionsForCurrentLevel;
    NSInteger rows = (NSInteger)sqrt((float)[self.puzzleGameGridView getCurrentPattern]);
    NSInteger columns = rows;
    
    CGFloat height = self.puzzleGameGridView.bounds.size.width / rows;
    CGFloat width = height;
    
    NSInteger questionIndex = 0;
    for (int j = 0; j < rows; j++)
    {
        for (int i = 0; i < columns; i++)
        {
            Question *currentQuestion = questionsForCurrentLevel[questionIndex];
            PuzzlePiece *puzzlePiece = self.game.imagePiecesForCurrentLevel[questionIndex];
            questionIndex++;
            QuestionView *questionView = [[QuestionView alloc] initWithFrame:CGRectMake(i*width, j*height, width, height) question:currentQuestion puzzlePiece:puzzlePiece];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.puzzleGameGridView action:@selector(handleTap:)];
            [questionView addGestureRecognizer:tapRecognizer];
            [self.puzzleGameGridView setContentView:questionView atIndex: j*rows + i ];
        }
    }
}

- (void)updateGridPattern
{
    MultiViewPattern targetPattern = (MultiViewPattern)self.game.currentLevel;
    [self.puzzleGameGridView setCurrentPattern:targetPattern];
}

- (UIButton *)gridPatternButtonForLevel:(Level)level
{
    UIButton *gridPatternButton = nil;
    for (UIButton *currentTridPatternButton in self.gridPatternButtons)
    {
        if ((Level)currentTridPatternButton.tag == level)
        {
            gridPatternButton = currentTridPatternButton;
            break;
        }
    }
    return gridPatternButton;
}

- (BOOL)allQuestionsAnsweredForCurrentLevel
{
    BOOL allQuestionsAnsweredForCurrentLevel = YES;
    
    for (Question *question in self.game.questionsForCurrentLevel)
    {
        allQuestionsAnsweredForCurrentLevel = question.answered == NO ? NO : allQuestionsAnsweredForCurrentLevel;
    }
    
    return allQuestionsAnsweredForCurrentLevel;
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


 #pragma mark - Grid view delegate
 
- (void)puzzleGameGridView:(PuzzleGameGridView *)puzzleGameGridView didSelectViewAtIndex:(NSInteger)index
{
    Question *question = self.game.questionsForCurrentLevel[index];
    
    if (!question.answered)
    {
        self.currentlySelectedQuestionIndex = index;
        QuestionViewController *questionViewController = nil;
        
        if ([question isKindOfClass:[LocationQuestion class]])
        {
            questionViewController = [[LocationQuestionViewController alloc] initWithNibName:@"LocationQuestionViewController" question:question delegate:self bundle:nil];
        }
        else if ([question isKindOfClass:[MultipleChoiceQuestion class]])
        {
            questionViewController = [[MultipleChoiceQuestionViewController alloc] initWithNibName:@"MultipleChoiceQuestionViewController" question:question delegate:self bundle:nil];
        }
        
        questionViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:questionViewController animated:YES completion:nil];
    }
}

- (void)didExchangeView:(UIView *)sourceView atIndex:(NSInteger)sourceIndex withView:(UIView *)targetView atIndex:(NSInteger)targetIndex
{
    NSLog(@"DEBUG | %s | Echanged views: %d <--> %d", __func__, sourceIndex, targetIndex);
    
    BOOL puzzleSolved = YES;
    NSArray *contentViews = [self.puzzleGameGridView getContentViews];
    for (int i = 0; i < [contentViews count]; i++)
    {
        QuestionView *questionView = contentViews[i];
        if (questionView.puzzlePiece.originalIndex != i)
        {
            puzzleSolved = NO;
            NSLog(@"DEBUG | %s | The puzzle is not solved yet", __func__);
            break;
        }
    }
    
    if (puzzleSolved && self.game.currentLevel == Level_Two)
    {
        NSString *title = NSLocalizedString(@"Awwwwww yeeaaah!", nil);
        NSString *message = NSLocalizedString(@"The puzzle is solved and you are almost done with the game, but don't party too hard yet, the most difficult level is yet to come!", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"Bring it", nil);
        [self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle];
        self.nextLevelButton.enabled = YES;
    }
    else if (puzzleSolved && self.game.currentLevel == Level_Three)
    {
        NSString *title = NSLocalizedString(@"Congratulations!", nil);
        NSString *message = NSLocalizedString(@"Great job, you solved all three puzzles! Want to start a new game or maybe check out the bonus? :-)", nil);
        NSString *newGameButtonTitle = NSLocalizedString(@"New game", nil);
        NSString *bonusButtonTitle = NSLocalizedString(@"Bonus!", nil);

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:newGameButtonTitle otherButtonTitles:bonusButtonTitle, nil];
        alert.tag = Level_Three;
        [alert show];
    }
}


 #pragma mark - Question view controller delegate
 
- (void)questionViewController:(QuestionViewController *)questionViewController answerWasCorrect:(BOOL)answerWasCorrect
 {
     QuestionView *questionView = [self.puzzleGameGridView questionViewForQuestion:questionViewController.question];
     if (answerWasCorrect)
     {
         NSLog(@"DEBUG | %s | Flip question view for question: %@ (index: %d)", __func__, questionViewController.question, self.currentlySelectedQuestionIndex);
         [questionView flip];
         
         if ([self allQuestionsAnsweredForCurrentLevel])
         {
             NSString *title = NSLocalizedString(@"Yeah!", nil);
             NSString *message = NSLocalizedString(@"Congratulations, you answered all questions correctly, now you can go and solve the puzzle! Move the puzzle pieces with drag and drop:\nFirst tap and hold a puzzle piece for a moment, then start moving it to the target position in the grid.", nil);
             NSString *cancelButtonTitle = NSLocalizedString(@"Let's go", nil);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self.game.currentLevel == Level_One ? self : nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
             alert.tag = self.game.currentLevel == Level_One ? Level_One : 0;
             [alert show];
             
             if (self.game.currentLevel != Level_One)
             {
                 [self.puzzleGameGridView setPuzzleMode:YES];
             }
         }
         
     }
     else
     {
         [questionView updateTriesLeft];
     }
 }

- (void)questionViewControllerGameOver:(QuestionViewController *)questionViewController
{
    NSString *title = NSLocalizedString(@"Game over", nil);
    NSString *message = NSLocalizedString(@"Well, well, well... looks like someone has to start all over again.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"New game", nil);
    [self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle];
    [self newGame];
}


#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Level_One)
    {
        NSString *title = NSLocalizedString(@"Oh actually....", nil);
        NSString *message = NSLocalizedString(@"Sorry, this was just the first level. There is no puzzle here yet... Just proceed with the next level.", nil);
        self.nextLevelButton.enabled = YES;
        NSString *cancelButtonTitle = NSLocalizedString(@"Yeah, next level!", nil);
        [self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle];
    }
    else if (alertView.tag == Level_Three)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"DEBUG | %s | No bonus", __func__);
            self.nextLevelButton.enabled = NO;
        }
        else
        {
            [self showBonus];
        }
    }
}

#pragma mark - Bonus

- (void)showBonus
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Your WWDC 2014 Ticket"];
        [controller setToRecipients:@[@"nikolas.burk@gmail.com"]];
        [controller setMessageBody:@"...so? :-)" isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        NSString *title = @"Ouch!";
        NSString *message = @"Sorry, you need to be able to send emails to check the bonus!";
        [self showAlertWithTitle:title message:message cancelButtonTitle:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Tab bar controller delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) || UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) //     if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) || self.view.bounds.size.width < self.view.bounds.size.height)
    {
        NSString *title = NSLocalizedString(@"Info", nil);
        NSString *message = NSLocalizedString(@"The time line canvas can only be used in landscape orientation, please turn your device and reopen the canvas again.", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}


#pragma mark - Actions

- (IBAction)newGameButtonPressed
{
    [self newGame];
}

- (IBAction)nextLevelButtonPressed
{
    [self levelUp];
    
    self.nextLevelButton.enabled = NO;
}

- (IBAction)levelButtonPressed:(UIButton *)sender
{
    if (sender.tag < self.game.currentLevel)
    {
        
    }
}

- (IBAction)helpShakeButtonPressed
{
    [HelpShakeViewController showHelpShakeInfo];
}
@end
