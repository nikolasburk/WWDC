//
//  LocationQuestionViewController.m
//  WWDC14
//
//  Created by Nikolas Burk on 05/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "LocationQuestionViewController.h"
#import "LocationQuestion.h"
#import "MapAnnotation.h"

@interface LocationQuestionViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation LocationQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(locationPressed:)];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)locationPressed:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded)
    {
        CGPoint touchLocation = [longPress locationInView:self.mapView];
        NSLog(@"DEBUG | %s | Tapped at point: (%f, %f)", __func__, touchLocation.x, touchLocation.y);
        
        CLLocationCoordinate2D coordinate;
        coordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
        
        float latitude = coordinate.latitude;
        float longitude = coordinate.longitude;
        
        NSDictionary *coordinates = @{kLatitude: @(latitude), kLongitude : @(longitude)};
        [self submitAnswer:coordinates];
        
        MapAnnotation *mapAnnotation;
        if (self.question.answered)
        {
            mapAnnotation = [[MapAnnotation alloc] initWithTitle:self.question.answerString subtitle:@""];
            mapAnnotation.coordinate = [self coordinateForDictionary:((LocationQuestion *)self.question).coordinates];
            [self.mapView addAnnotation:mapAnnotation];
            MKCoordinateRegion region = MKCoordinateRegionMake([self coordinateForDictionary:((LocationQuestion *)self.question).coordinates], MKCoordinateSpanMake(0.5f, 0.5f));
            [self.mapView setRegion:region animated:YES];
            self.mapView.userInteractionEnabled = NO;
            [self.mapView removeGestureRecognizer:longPress];
        }
        else
        {
            mapAnnotation = [[MapAnnotation alloc] initWithTitle:NSLocalizedString(@"Wrong guess", nil) subtitle:@""];
            mapAnnotation.coordinate = coordinate;
            [self.mapView addAnnotation:mapAnnotation];
        }
        [self.mapView selectAnnotation:mapAnnotation animated:YES];
        
    }

    
   // [self submitAnswer:];
}

- (CLLocationCoordinate2D)coordinateForDictionary:(NSDictionary *)coordinateDictionary
{
    return CLLocationCoordinate2DMake([coordinateDictionary[kLatitude] floatValue], [coordinateDictionary[kLongitude] floatValue]);
}


@end
