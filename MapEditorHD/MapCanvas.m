//
//  MapCanvas.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-3.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "MapCanvas.h"

#import "MapEditorHDViewController.h"
@class MapEditorHDViewController;
@implementation MapCanvas
@synthesize controller;
@synthesize project;
@synthesize curBrush;
@synthesize mapMode,colorMode;
-(void)setupProperty{
    project = [Project currentProject];
    curBrush = zMOVING_VALUE;
    font = [UIFont fontWithName:@"Arial" size:12];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperty];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupProperty];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code/
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.1] CGColor]);
    Tile *item;
    NSString *key;
    int startX = MAX(rect.origin.x / zTILE_SIZE - 1, 0); 
    int endX = MIN((rect.origin.x + rect.size.width) / zTILE_SIZE, project.map.width); 
    int startY = MAX(rect.origin.y / zTILE_SIZE - 1, 0); 
    int endY = MIN((rect.origin.y + rect.size.height) / zTILE_SIZE + 1, project.map.height); 
    for (int i = startY; i < endY ; i++) {
        for (int j = startX; j < endX; j++) {
            key = [NSString stringWithFormat:@"%x", project.map.mapData[i * project.map.width + j]];
            item = [project.resMapping objectForKey:key];
            if(mapMode == zMAP_MODE_DATA){
                if (item != nil) {
                    NSString *value = [NSString stringWithFormat:@"0x%x", item.value];
                    [value drawAtPoint:CGPointMake(j * zTILE_SIZE , i * zTILE_SIZE) withFont:font];
                }else{
                    NSString *value = @"0x0";
                    [value drawAtPoint:CGPointMake(j * zTILE_SIZE , i * zTILE_SIZE) withFont:font];
                }
            }else if (item == nil) {
                if(colorMode){
                    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]);
                    CGContextFillRect(context, CGRectMake(j * zTILE_SIZE , i * zTILE_SIZE , zTILE_SIZE , zTILE_SIZE ));
                }else{
                    CGContextStrokeRect(context, CGRectMake(j * zTILE_SIZE , i * zTILE_SIZE , zTILE_SIZE , zTILE_SIZE ));
                }
            } else if(mapMode == zMAP_MODE_COLORRECT){
                CGContextSetFillColorWithColor(context, item.color.CGColor);
                CGContextFillRect(context, CGRectMake(j * zTILE_SIZE , i * zTILE_SIZE , zTILE_SIZE , zTILE_SIZE ));
            }else if(mapMode == zMAP_MODE_REALTIME2D){
                CGContextDrawImage(context, CGRectMake(j * zTILE_SIZE , i * zTILE_SIZE , zTILE_SIZE , zTILE_SIZE ), item.image.CGImage);
            }
        }
    }
    [super drawRect:rect];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if([[touches anyObject] tapCount] == 2){
        [controller touchesBegan:touches withEvent:event];
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    int y = (int)(point.y / zTILE_SIZE );
    int x = (int)(point.x / zTILE_SIZE );
    if (curBrush == zMOVING_VALUE) {

    }else{
        int index = y * project.map.width + x;
        project.map.mapData[index] = curBrush;
        [self setNeedsDisplayInRect:CGRectMake(x * zTILE_SIZE , y * zTILE_SIZE , zTILE_SIZE , zTILE_SIZE )];
        
    }
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    CGPoint point = [[touches anyObject] locationInView:self];
    int y = (int)(point.y / zTILE_SIZE);
    int x = (int)(point.x / zTILE_SIZE);
    if (curBrush == zMOVING_VALUE) {
    }else{
        int index = y * project.map.width + x;
        project.map.mapData[index] = curBrush;
        [self setNeedsDisplayInRect:CGRectMake(x * zTILE_SIZE , y * zTILE_SIZE , zTILE_SIZE , zTILE_SIZE )];
    }


}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
}

@end
