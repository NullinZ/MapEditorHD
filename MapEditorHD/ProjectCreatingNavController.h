//
//  ProjectCreatingNavController.h
//  MapEditorHD
//
//  Created by Nullin on 11-7-10.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapEditorHDViewController.h"
#import "Project.h"
@interface ProjectCreatingNavController : UINavigationController {
    Project *project;
    id<ProjectController> projController;
}
@property (nonatomic, strong) id<ProjectController> projController;
-(IBAction)createProject;

@end
