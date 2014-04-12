//
//  FrustrationShakeViewController.h
//  Travel
//
//  Created by Astill, John on 3/17/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FrustrationShakeViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) UIImage *screenCapture;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) IBOutlet UIButton *dismissButton;
@property (nonatomic, retain) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) IBOutlet UIImageView *shakeImage;

@property (nonatomic, strong) IBOutlet UIImageView *mailIcon;
@property (strong, nonatomic) IBOutlet UIImageView *shareIcon;
@property (strong, nonatomic) IBOutlet UIImageView *dismissIcon;
@property (strong, nonatomic) IBOutlet UITextView *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mobileCoeIcon;

@property double startRadians;

-(IBAction)sendFeedback:(id)sender;
-(IBAction)shareWithFriends:(id)sender;
-(IBAction)dismiss:(id)sender;
-(IBAction)shake:(id)sender;

+ (NSString *)currentWifiSSID;


@end
