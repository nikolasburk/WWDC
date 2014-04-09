//
//  UIImage+Split.m
//  WWDC14
//
//  Created by Nikolas Burk on 08/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "UIImage+Split.h"
#import "PuzzlePiece.h"

@implementation UIImage (Split)

- (NSArray *)splitIntoPieces:(NSInteger)numberOfPieces
{
    NSInteger root = sqrt(numberOfPieces);    
    NSMutableArray *splitPieces = [self getImagesFromImage:self withRow:root withColumn:root];
    return splitPieces;
}

- (NSMutableArray *)getImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns
{
    NSMutableArray *puzzlePieces = [NSMutableArray array];
    CGSize imageSize = image.size;
    CGFloat xPos = 0.0, yPos = 0.0;
    CGFloat width = imageSize.width/rows;
    CGFloat height = imageSize.height/columns;
    int imageIndex = 0;
    for (int y = 0; y < columns; y++) {
        xPos = 0.0;
        for (int x = 0; x < rows; x++) {
            
            CGRect rect = CGRectMake(xPos, yPos, width, height);
            CGImageRef cImage = CGImageCreateWithImageInRect([image CGImage],  rect);
            
            PuzzlePiece *puzzlePiece = [[PuzzlePiece alloc] initWithCGImage:cImage originalIndex:imageIndex++];
            [puzzlePieces addObject:puzzlePiece];
            xPos += width;
        }
        yPos += height;
    }
    return puzzlePieces;
}

//- (NSArray*)splitImageIntoRects:(CGImageRef)anImage{
//    
//    CGSize imageSize = CGSizeMake(CGImageGetWidth(anImage), CGImageGetHeight(anImage));
//    
//    NSMutableArray *splitLayers = [NSMutableArray array];
//    
//    kXSlices = 3;
//    kYSlices = 3;
//    
//    for(int x = 0;x < kXSlices;x++) {
//        for(int y = 0;y < kYSlices;y++) {
//            CGRect frame = CGRectMake((imageSize.width / kXSlices) * x,
//                                      (imageSize.height / kYSlices) * y,
//                                      (imageSize.width / kXSlices),
//                                      (imageSize.height / kYSlices));
//            
//            CALayer *layer = [CALayer layer];
//            layer.frame = frame;
//            CGImageRef subimage = CGImageCreateWithImageInRect(drawnImage, frame);
//            layer.contents = (id)subimage;
//            CFRelease(subimage);
//            [splitLayers addObject:layer];
//        }
//    }
//    return splitLayers;
//}

@end
