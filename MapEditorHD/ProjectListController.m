//
//  ProjectListController.m
//  MapEditorHD
//
//  Created by Nullin on 11-7-4.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "ProjectListController.h"


@implementation ProjectListController
@synthesize projController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    FileMgr *fm = [FileMgr defaultFileMgr];
    projects = [[NSMutableArray alloc] initWithArray: [fm listProject] copyItems:YES];
    [super viewDidLoad];
}

#pragma mark - tableView datasource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifierOfProjectList = @"projectListId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfProjectList];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierOfProjectList];
    }
    cell.textLabel.text = [projects objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [projects count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (projController != nil) {
        NSString * projName = [projects objectAtIndex:indexPath.row];
        [projController loadProject:projName];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
