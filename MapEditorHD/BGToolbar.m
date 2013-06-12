//
//  BGToolbar.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-13.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "BGToolbar.h"


@implementation BGToolbar
- (id)init {
    self = [super init];
    if (self) {
    
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, self.bounds, [UIImage imageNamed:@"ToolBarBg.png"].CGImage);
}
@end
