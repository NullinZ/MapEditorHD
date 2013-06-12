//
//  ProjectController.h
//  MapEditorHD
//
//  Created by Nullin on 11-7-4.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ProjectController
-(IBAction)loadProject:(NSString *)projectName;
-(IBAction)createProjectComplete;
@end
