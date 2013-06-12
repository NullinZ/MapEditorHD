//
//  TileGridController.h
//  MapEditorHD
//
//  Created by Nullin on 11-7-5.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "TileLoadingCell.h"

@interface TileGridController : UITableViewController {
    NSMutableArray *tilesArray;
    Project *project;
    bool *tilesSelected;
}
@property (nonatomic) float rowHeight;

@end
