//
//  PuzzlePiece.h
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzlePiece : UIImage

@property (nonatomic, assign, readonly) NSInteger originalIndex;

- (id)initWithCGImage:(CGImageRef)cgImage originalIndex:(NSInteger)originalIndex;

@end
