//
//  HelpShakeViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 12/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "HelpShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#include <QuartzCore/QuartzCore.h>


@interface HelpShakeViewController ()

@property double startRadians;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shakeIcon;
@property (weak, nonatomic) IBOutlet UILabel *puzzleMeTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *puzzleMeTextView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation HelpShakeViewController


+ (void)openHelpShakeViewControllerWithViewController:(UIViewController <HelpShake> *)viewController
{
    NSString *nibName = [NSString stringWithFormat:@"%@_%@", NSStringFromClass([HelpShakeViewController class]), [viewController nibNameSuffix]];
    HelpShakeViewController *helpShakeViewController = [[HelpShakeViewController alloc] initWithNibName:nibName bundle:nil];
    helpShakeViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//    helpShakeViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [viewController presentViewController:helpShakeViewController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

}

- (IBAction)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Rotate the image from fromValue radians to toValue radians
-(void)rotateTo:(double)toValue from:(double)fromValue
{
    NSLog(@"fromValue: %f toValue: %f",fromValue, toValue);
    
    self.startRadians = fromValue;
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setFromValue:[NSNumber numberWithFloat:fromValue]];
    [anim setToValue:[NSNumber numberWithDouble:toValue]]; // rotation angle
    [anim setDuration:0.1];
    [anim setRepeatCount:6];
    [anim setAutoreverses:YES];
    [self.shakeIcon.layer addAnimation:anim forKey:@"iconShake"];
}

-(IBAction)shake:(UIRotationGestureRecognizer *)recognizer
{
    // Determine the transform from the current position
    double startPosition = self.startRadians + [recognizer rotation];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(startPosition);
    self.shakeIcon.transform = transform;
    
    // If the gesture has ended or is canceled, begin the animation
    // back to horizontal and fade out
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        
        // To value should be current rotation in radians
        CGFloat toValue = self.startRadians;
        [self rotateTo:toValue from:startPosition];
        
    }
}

@end
