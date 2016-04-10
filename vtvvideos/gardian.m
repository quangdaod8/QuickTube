//
//  gardian.m
//  vtvvideos
//
//  Created by Duy Quang on 3/18/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "gardian.h"

@implementation gardian

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
}
@end
