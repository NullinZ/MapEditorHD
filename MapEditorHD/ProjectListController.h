//
//  ProjectListController.h
//  MapEditorHD
//
//  Created by Nullin on 11-7-4.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectController.h"
#import "FileMgr.h"

@interface ProjectListController : UITableViewController{
    NSMutableArray *projects;
    id<ProjectController> projController;
}
@property (nonatomic, strong) id<ProjectController> projController;

@end
