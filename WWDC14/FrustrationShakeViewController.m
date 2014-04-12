//
//  FrustrationShakeViewController.m
//  Travel
//
//  Created by Astill, John on 3/17/13.
//
//

#import "FrustrationShakeViewController.h"
#include <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#include <asl.h>
#import <SystemConfiguration/SystemConfiguration.h>
//#import "UIConstants.h"


// Distribution list as target for support email https://profiles.wdf.sap.corp/groups 
#define cDistributionList @"Global IT Mobile CoE <IT_Mobile@sap.com>"

// Image name for screencapture attachment to email
#define cImageFilename @"trcscreencapture.png"

// Body of the email sent when sharing the application via email. Share meaning recommending it to someone else. This is in the file shareappemail.html


@implementation FrustrationShakeViewController
{
    NSArray *_buttons;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _buttons = @[self.submitButton, self.dismissButton, self.shareButton];
    
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    for(UIButton *currentButton in _buttons)
    {
        [currentButton.layer setBorderWidth:1.0];
        [currentButton.layer setBorderColor:kSAPBrightBlueColor.CGColor];
        [currentButton.layer setCornerRadius:0.0];
    }
    
    // Adjust for iPhone 5 larger screen
    if(RETINA_4_INCH)
    {
        // Configure and move down buttons
        for(UIButton *currentButton in _buttons)
        {
            [currentButton.layer setBorderWidth:1.0];
            [currentButton.layer setBorderColor:kSAPBrightBlueColor.CGColor];
            [currentButton.layer setCornerRadius:0.0];
            
            [self moveView:currentButton onYAxis:IPHONE_5_DELTA];
        }
        
        // Move down belonging icons
        [self moveView:self.mailIcon onYAxis:IPHONE_5_DELTA];
        [self moveView:self.shareIcon onYAxis:IPHONE_5_DELTA];
        [self moveView:self.dismissIcon onYAxis:IPHONE_5_DELTA];
        
        // Move down remaining icons
        [self moveView:self.shakeImage onYAxis:IPHONE_5_DELTA/2];
        [self moveView:self.textLabel onYAxis:IPHONE_5_DELTA/2];
        
        // Adjust mobile coe icon (which got somehow got srewed up by interface builder...)
//        self.mobileCoeIcon.frame = CGRectMake(self.mobileCoeIcon.frame.origin.x, self.mobileCoeIcon.frame.origin.y, 88.0, 36.0);
    }
    
}

- (void)backToChats
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Read the log file from the device.
-(NSString*)getLogs
{
    NSMutableString *logFile = [[NSMutableString alloc] initWithCapacity:9000];
    
    aslmsg q, m;
    q = asl_new(ASL_TYPE_QUERY);
    
    // This performs an open search and will return all log entries, not only app specific.
    aslresponse r = asl_search(NULL, q);
    while (NULL != (m = aslresponse_next(r)))
    {
        const char* level = asl_get(m, ASL_KEY_LEVEL);
        const char* facility = asl_get(m, ASL_KEY_FACILITY);
        const char* message = asl_get(m, ASL_KEY_MSG);
        const char* time = asl_get(m, ASL_KEY_TIME);
        const char* nano = asl_get(m, ASL_KEY_TIME_NSEC);
        
        NSTimeInterval interval = [[NSString stringWithFormat:@"%s",time] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        
        [logFile appendString:[NSString stringWithFormat:@"[%s] %@ %snS %s %s\n", level, date, nano, facility, message]];

    }
    aslresponse_free(r);
    
    return logFile;
}

// This will cuase the support email to be composed. This currently includes data Specific to Travel Receipt Capture
-(IBAction)sendFeedback:(id)sender
{
    
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *logs = [self getLogs];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setToRecipients:[NSArray arrayWithObjects:cDistributionList, nil]];
        [mailer setSubject:@"SAP News"];
        NSData *imageData = UIImagePNGRepresentation(self.screenCapture);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"trcscreencapture.png"];
        [mailer addAttachmentData:[logs dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:@"logfile.txt"];
        
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        NSString *deviceType = [UIDevice currentDevice].model;
//        NSString *ssid = [FrustrationShakeViewController currentWifiSSID];
//        if (ssid == nil) {
//            ssid = @"No Wifi SSID found";
//        }
        
        //NSString *endpointAddress = [LiteSUPAppSettings getApplicationEndPoint];
        
        NSString *emailBody = [NSString stringWithFormat:@"Please describe your feedback here, including steps on how to recreate any problems you may have:\r\n\r\n\r\n\n Version: %@\r\niOS Version: %@\r\nDevice type: %@\r\nLocale: %@\r\nLanguage: %@\r\n", appVersion, systemVersion, deviceType,[[NSLocale currentLocale] localeIdentifier],[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]];
        
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to submit email"
                                                        message:@"It appears that your device does not support sending email."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(IBAction)dismiss:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.shakeImage.layer addAnimation:anim forKey:@"iconShake"];    
}

-(IBAction)shake:(UIRotationGestureRecognizer *)recognizer
{
    // Determine the transform from the current position
    double startPosition = self.startRadians + [recognizer rotation];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(startPosition);
    self.shakeImage.transform = transform;
    
    // If the gesture has ended or is canceled, begin the animation
    // back to horizontal and fade out
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {

        // To value should be current rotation in radians
        CGFloat toValue = self.startRadians;
        [self rotateTo:toValue from:startPosition];
        
    }
}

-(IBAction)shareWithFriends:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
//        [[mailer navigationBar] setTintColor:UIColorFromRGB(0x333333)];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"App Recommendation"];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"appshare" ofType:@"html"];
        NSError *error;
        NSString *shareEmail = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: &error];
        [mailer setMessageBody:shareEmail  isHTML:YES];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to submit email"
                                                        message:@"It would appear that your device does not support sending email."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

// Delegate method for sending mail. Generic error display if something did not work.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
    [self dismiss:self];
}

#pragma mark - Helpers

// This controller needs to be able to be first responder to respond to the shake
-(BOOL) canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Allow to be the first responder for receiving the shake gesture event
    [self becomeFirstResponder];

    // Wobble the image when the view appears
    [self rotateTo:M_PI/8 from:0.0f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // No longer need to receive the shake gesture event since the view is gone
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self rotateTo:self.startRadians - M_PI/8 from:self.startRadians ];
}

- (void)moveView:(UIView *)view onYAxis:(float)distance
{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+distance, view.frame.size.width, view.frame.size.height);
}

@end
