//
//  CategoryView.h
//  WWDC14
//
//  Created by Nikolas Burk on 12/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView : UIImageView

- (id)initWithFrame:(CGRect)frame category:(NSString *)category;

@property (nonatomic, strong, readonly) NSString *category;

@end
