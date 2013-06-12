//
//  ExportTableController.h
//  MapEditorHD
//
//  Created by Nullin on 11-7-28.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MapEditorHDViewController.h"

@interface ExportTableController : UITableViewController {
    NSArray *exportList;
    MapEditorHDViewController *mec;
}
@property (nonatomic,strong) MapEditorHDViewController *mec;
-(void)mapshotToLib;
-(void)mapToItunes;
@end
