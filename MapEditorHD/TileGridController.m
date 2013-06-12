//
//  TileGridController.m
//  MapEditorHD
//
//  Created by Nullin on 11-7-5.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "TileGridController.h"
#import "FileMgr.h"

@implementation TileGridController
@synthesize rowHeight;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        tilesArray = [[NSMutableArray alloc] init];
        project = [Project currentProject];
        [self setEditing:YES animated:YES];
        FileMgr *fm = [FileMgr defaultFileMgr];
       // [fm changeDir:[project resPath]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"extensions" ofType:@"plist"];
        NSDictionary *dicTemp = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *extensions = [dicTemp objectForKey:@"Root"];
        NSArray* files = [fm listFileWithExtensions:extensions];
        Tile *tile;
        for (NSString *file in files) {
            NSString *path = [[fm rootDictionary] stringByAppendingPathComponent:file];
            tile = [[Tile alloc] initWithTitle:[file substringToIndex:[file length] - 4 ]
                                         Value:[files indexOfObject:file] + 1 
                                      TileType:TileTypeImage 
                                         Image:path];
            [tilesArray addObject:tile];
        }
        tilesSelected = malloc([tilesArray count] * sizeof(bool));
        for (int i = 0; i < [tilesArray count]; i++) {
            tilesSelected[i] = NO;
        }
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
-(void)loadTilesAndReturn{
    Tile *tile;
    for (int i = 0;i<[tilesArray count];i++) {
        if (tilesSelected[i]) {
            tile = [tilesArray objectAtIndex:i];
            FileMgr *fm = [FileMgr defaultFileMgr];
            [fm importTileFileFrom:tile move:NO];
            [project.tilesArray addObject:tile];
            [project.resMapping setValue:tile forKey:[NSString stringWithFormat:@"%x", tile.value]];
        }
    }
    [self.parentViewController performSelector:@selector(createProject)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ChooseTile";
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStyleBordered target:self
                                                             action:@selector(loadTilesAndReturn)];
    self.navigationItem.rightBarButtonItem = done;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tilesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TileLoadingCell";
    TileLoadingCell *cell = (TileLoadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TileLoadingCell" owner:self options:nil];  
        cell = [array objectAtIndex:0];
    }
    [cell setTile:[tilesArray objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    tilesSelected[indexPath.row]= !tilesSelected[indexPath.row];
}

@end
