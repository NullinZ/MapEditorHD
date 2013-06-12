//
//  CreateProjectController.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-26.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "ProjectInfoCreateController.h"
#import "MapEditorHDViewController.h"

@implementation ProjectInfoCreateController
@synthesize tipsLabel;
@synthesize projNameTF;
@synthesize resPathTF;
@synthesize widthTF;
@synthesize heightTF;
@synthesize descriptionTV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        project = [Project currentProject];
    }
    return self;
}

-(void)toChooseTiles:(id)sender{
    if ([projNameTF.text length] <= 0 ) {
        tipsLabel.text = @"Title is not allowed blank";
        return;
    }
    if ([resPathTF.text length] <= 0 ) {
        tipsLabel.text = @"resPath is not allowed blank";
        return;
    }
    if ([heightTF.text length] <= 0 ) {
        tipsLabel.text = @"height is not allowed blank";
        return;
    }
    if ([widthTF.text length] <= 0 ) {
        tipsLabel.text = @"width is not allowed blank";
        return;
    }
    project.projectName = projNameTF.text;
    project.resPath = resPathTF.text;
    project.description = descriptionTV.text;
    [project generateMapWithWidth:[widthTF.text intValue] Height:[heightTF.text intValue]];
    FileMgr *fm = [FileMgr defaultFileMgr];
    if ([fm createProjectDir:project]) {
        [project.tilesArray removeAllObjects];
        [project.resMapping removeAllObjects];
        
        TileGridController *tableCon = [[TileGridController alloc] initWithStyle:UITableViewStylePlain];    
        [self.navigationController pushViewController:tableCon animated:YES];

    }
}

-(void)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(toChooseTiles:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(cancel:)];
	self.navigationItem.rightBarButtonItem = addButton;
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tipsLabel = nil;
    projNameTF = nil;
    resPathTF = nil;
    widthTF = nil;
    heightTF = nil;
    descriptionTV = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
