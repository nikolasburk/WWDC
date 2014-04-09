//
//  UIImage+Split.h
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Split)


- (NSArray *)splitIntoPieces:(NSInteger)numberOfPieces;

@end
