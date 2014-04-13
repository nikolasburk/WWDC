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

//@property double startRadians;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *subtitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *shakeIcon;
@property (weak, nonatomic) IBOutlet UILabel *puzzleMeTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *puzzleMeTextView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;


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

+ (void)showHelpShakeInfo
{
    NSString *title = NSLocalizedString(@"Shake it, baby!", nil);
    NSString *message = NSLocalizedString(@"Whenever you see this icon, a shake gesture on the device will open a help screen to support you with your current task.", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
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
    self.dismissButton.layer.cornerRadius = 5.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self shake];
}

- (IBAction)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Rotate the image from fromValue radians to toValue radians
-(void)rotateTo:(double)toValue from:(double)fromValue
{
    NSLog(@"DEBUG | %s | To: %f; From: %f", __func__, toValue, fromValue);
    float repeatCount = 6.0;
    float duration = 0.18;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [animation setFromValue:[NSNumber numberWithFloat:fromValue]];
    [animation setToValue:[NSNumber numberWithDouble:toValue]];
    [animation setDuration:duration];
    [animation setRepeatCount:repeatCount];
    [animation setAutoreverses:YES];
    [animation setRemovedOnCompletion:YES];
    [self.shakeIcon.layer addAnimation:animation forKey:@"iconShake"];
}

-(void)shake
{
    NSLog(@"DEBUG | %s | Shake", __func__);

    CGFloat rotateRadians = 0.85; // rotate two radians (2 rad = 115 c)
    
    // Determine the transform from the current position
    double startPosition = 0.0; //self.startRadians;
    double toValue = startPosition + rotateRadians;

    // Set initial transform
    CGAffineTransform transform = CGAffineTransformMakeRotation(startPosition);
    self.shakeIcon.transform = transform;
    
    [self rotateTo:toValue from:startPosition];
}


@end
