//
//  CreateProjectController.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-26.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "FileMgr.h"


@interface ProjectInfoCreateController : UIViewController {
    UILabel *tipsLabel;
    UITextField *projNameTF;
    UITextField *resPathTF;
    UITextField *widthTF;
    UITextField *heightTF;
    UITextField *descriptionTV;
    Project *project;
    
}

@property (nonatomic,strong) IBOutlet UILabel *tipsLabel;
@property (nonatomic,strong) IBOutlet UITextField *projNameTF;
@property (nonatomic,strong) IBOutlet UITextField *resPathTF;
@property (nonatomic,strong) IBOutlet UITextField *widthTF;
@property (nonatomic,strong) IBOutlet UITextField *heightTF;
@property (nonatomic,strong) IBOutlet UITextField *descriptionTV;


-(IBAction)cancel:(id)sender;
-(IBAction)toChooseTiles:(id)sender;
@end
