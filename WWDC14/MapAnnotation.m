//
//  MapAnnotation.m
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self)
    {
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

@end
