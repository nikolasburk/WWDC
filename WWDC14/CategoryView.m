//
//  CategoryView.m
//  WWDC14
//
//  Created by Nikolas Burk on 12/04/14.
//  Copyright (c) 2014 Nikolas Burk. All rights reserved.
//

#import "CategoryView.h"


@implementation CategoryView

- (id)initWithFrame:(CGRect)frame category:(NSString *)category
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _category = category;
        self.image = [UIImage imageNamed:@"category"];
        [self addCategoryLabel];
        
    }
    return self;
}

- (void)addCategoryLabel
{
    const CGFloat dx = self.bounds.size.width / 5.0;
    const CGFloat dy = self.bounds.size.height / 3.0;
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, dx, dy)];
    categoryLabel.font = [UIFont systemFontOfSize:35.0];
    categoryLabel.adjustsFontSizeToFitWidth = YES;
    categoryLabel.text = self.category;
    categoryLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:categoryLabel];
}


@end
