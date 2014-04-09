//
//  MultipleChoiceQuestionViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "MultipleChoiceQuestionViewController.h"
#import "NSArray+Util.h"

#define TAG_A 0
#define TAG_B 1
#define TAG_C 2
#define TAG_D 3


@interface MultipleChoiceQuestionViewController ()

- (IBAction)answerButtonPressed:(id)sender;

@property (nonatomic, strong) NSArray *answerOptions;

@property (weak, nonatomic) IBOutlet UILabel *firstAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdAnswerLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthAnswerLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;


@end

@implementation MultipleChoiceQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil question:(Question *)question delegate:(id<QuestionViewControllerDelegate>)delegate bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil question:question delegate:delegate bundle:nibBundleOrNil];
    if (self)
    {
        self.answerOptions = ((MultipleChoiceQuestion *)question).options;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.answerOptions = [self generateAnswerOptions];
    self.firstAnswerLabel.text = self.answerOptions[TAG_A];
    self.secondAnswerLabel.text = self.answerOptions[TAG_B];
    self.thirdAnswerLabel.text = self.answerOptions[TAG_C];
    self.fourthAnswerLabel.text = self.answerOptions[TAG_D];
}

- (NSInteger)tagIndexForButton:(UIButton *)button
{
    NSInteger tag = -1;
    NSString *option = button.titleLabel.text;
    if ([option isEqualToString:@"A"])
    {
        tag = TAG_A;
    }
    else if ([option isEqualToString:@"B"])
    {
        tag = TAG_B;
    }
    else if ([option isEqualToString:@"C"])
    {
        tag = TAG_C;
    }
    else if ([option isEqualToString:@"D"])
    {
        tag = TAG_D;
    }
    return tag;
}

- (IBAction)answerButtonPressed:(UIButton *)sender
{
    NSInteger index = [self tagIndexForButton:sender];
    NSString *answer = self.answerOptions[index];
    [self submitAnswer:answer];
    
    if (self.question.answered)
    {
        switch (index)
        {
            case TAG_A:
                self.firstAnswerLabel.textColor = [UIColor whiteColor];
                self.firstAnswerLabel.backgroundColor = [UIColor greenColor];
                break;
            case TAG_B:
                self.secondAnswerLabel.textColor = [UIColor whiteColor];
                self.secondAnswerLabel.backgroundColor = [UIColor greenColor];
                break;
            case TAG_C:
                self.thirdAnswerLabel.textColor = [UIColor whiteColor];
                self.thirdAnswerLabel.backgroundColor = [UIColor greenColor];
                break;
            case TAG_D:
                self.fourthAnswerLabel.textColor = [UIColor whiteColor];
                self.fourthAnswerLabel.backgroundColor = [UIColor greenColor];
                break;
                
            default:
                break;
        }
        
        for (UIButton *button in self.answerButtons)
        {
            button.userInteractionEnabled = NO;
        }
        
    }
}

- (NSArray *)generateAnswerOptions
{
    NSMutableArray *mutableAnswerOptions = [[NSMutableArray alloc] init];
    mutableAnswerOptions = [[NSMutableArray alloc] initWithArray:self.answerOptions];
    NSArray *answerOptions = [mutableAnswerOptions randomObjects:NUMBER_OF_ANSWER_OTIONS-1];
    mutableAnswerOptions = [[NSMutableArray alloc] initWithArray:answerOptions];
    
    NSUInteger randomIndex = arc4random_uniform(NUMBER_OF_ANSWER_OTIONS);
    
    //NSLog(@"DEBUG | %s | Selected %d answer options (insert answer at %d): \n%@", __func__, [mutableAnswerOptions count], randomIndex, mutableAnswerOptions);
    
    [mutableAnswerOptions insertObject:self.question.answerString atIndex:randomIndex];
    
    //NSLog(@"DEBUG | %s | Added actual answer (%@) options: \n%@", __func__, self.question.answerString, mutableAnswerOptions);
    
    return mutableAnswerOptions;
}


//#pragma mark - Implementation of abstract methods from superclass

//- (void)questionWasAnsweredCorrectly:(BOOL)questionWasAnsweredCorrectly
//{
//    NSString *instructionMessage = questionWasAnsweredCorrectly ? @"YES" : @"NO";
//    [super setInstructionMessage:instructionMessage answerCorrect:questionWasAnsweredCorrectly];
//}


@end
