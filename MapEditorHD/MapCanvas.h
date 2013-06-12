//
//  MapCanvas.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-3.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapData.h"
#import "Constants.h"
#import "Project.h"
#import "Tile.h"
@class MapEditorHDViewController;

@interface MapCanvas : UIView {
    MapEditorHDViewController *controller;
    Project *project;
    CGPoint lastPosition;
    UIFont *font;
    int colorMode;
    int curBrush;
    int mapMode;
    
}

@property (nonatomic, strong) MapEditorHDViewController *controller;
@property (nonatomic, strong) Project *project;
@property int colorMode;
@property int curBrush;
@property int mapMode;

-(void)setupProperty;
@end
