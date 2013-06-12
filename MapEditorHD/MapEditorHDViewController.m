//
//  MapEditorHDViewController.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-3.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "MapEditorHDViewController.h"
#import "FileMgr.h"
#import "Project.h"
#import <QuartzCore/QuartzCore.h>
#import "MailComposerViewController.h"
#import "ZipArchive.h"

@interface MapEditorHDViewController(Private)
-(void)setupTableView;
-(IBAction)showTileEditArea:(id)sender;
-(void)refleshMapView;
@end


@implementation MapEditorHDViewController
@synthesize tilesView;
@synthesize itemsArray;
@synthesize tilesDrawer;
@synthesize scrollView;
@synthesize mapDataLabel;
@synthesize drawerSwitch;
@synthesize mapView;
@synthesize fm;
@synthesize projectNameView;



#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
    fm = [FileMgr defaultFileMgr];
    project = [Project currentProject];
    tilesView.backgroundView.hidden = YES;  
    mapView.controller = self;
    [self setupTableView];
    if ([itemsArray count] > 1) {
        [itemsArray removeObjectAtIndex:1];
    }
    [itemsArray addObject:[project tilesArray]];
    [self refleshMapView];
    tilesHide = NO;
    toggle = [NSTimer scheduledTimerWithTimeInterval:5 
                                              target:self 
                                            selector:@selector(toggleTilesView:) 
                                            userInfo:nil 
                                             repeats:NO];
    if (![persistentDefaults objectForKey:@"first"]) {
        [self initDemos];
        [self performSelector:@selector(showHelpView:) withObject:nil afterDelay:1];
        [self showHelpView:nil];
        [persistentDefaults setObject:@"NO" forKey:@"first"];
    }
}
-(void)setupTableView{
    itemsArray = [[NSMutableArray alloc] init];
    Tile *move = [[Tile alloc] initWithTitle:@"Moving" Value:zMOVING_VALUE TileType:TileTypeLibImage Image:@"move_mode.png"];
    Tile *eraser = [[Tile alloc] initWithTitle:@"Eraser" Value:zBLANK_VALUE TileType:TileTypeLibImage Image:@"eraser.png"];
    NSArray *modes = [[NSArray alloc] initWithObjects:move, eraser, nil];
    [itemsArray addObject:modes];
}

-(void)refleshMapView{
    int width =  self.scrollView.zoomScale * project.map.width * zTILE_SIZE;
    int height =  self.scrollView.zoomScale * project.map.height * zTILE_SIZE;
    self.mapView.frame = CGRectMake(0, 0, width, height );   
    self.scrollView.contentSize =  CGSizeMake(width, height);
    self.scrollView.contentOffset = CGPointMake((width-1024)/2, (height - 768)/2);
    [self.mapView setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)createTile:(id)sender{

}

-(void)createProject:(id)sender{
    ProjectInfoCreateController *cp = [[ProjectInfoCreateController alloc] initWithNibName:@"ProjectCreateController" 
                                                                                    bundle:nil];
    ProjectCreatingNavController *navC = [[ProjectCreatingNavController alloc] initWithRootViewController:cp];
    navC.modalPresentationStyle = UIModalPresentationFormSheet;
    navC.projController = self;
//    [navC pushViewController:cp animated:YES];
    

    [self presentModalViewController:navC animated:YES];
}

-(void)createProjectComplete{
    if([self.itemsArray count] > 1)
    {
        [self.itemsArray removeObjectAtIndex:1];
    }
    [self.itemsArray addObject:project.tilesArray];
    [tilesView reloadData];
    self.projectNameView.text = project.projectName;
    [self refleshMapView];
}
-(void)showProjectList:(id)sender{
    ProjectListController *tableCon = [[ProjectListController alloc] initWithStyle:UITableViewStylePlain];
    tableCon.projController = self;
    [self showPopoverWithBarItem:sender Controller:tableCon height:480];
}
-(void)showExportPopover:(id)sender{
    if(project&&project.projectName)
    {
        ExportTableController *exportCon = [[ExportTableController alloc] initWithStyle:UITableViewStylePlain];
        exportCon.mec = self;
        [self showPopoverWithBarItem:sender Controller:exportCon height:100];
   
    }else{
        [self tips:@"There's no map opend!"];
    }
}

-(void)loadProject:(NSString *)projectName{
    [detailViewPopover dismissPopoverAnimated:NO];
    [self showProgressInView:self.mapView];
    [project loadWithProject:projectName];
    if([itemsArray count] > 1)
    {
        [itemsArray removeObjectAtIndex:1];
    }
    [itemsArray addObject:project.tilesArray];
    [[self tilesView] reloadData];
    self.projectNameView.text = project.projectName;
    [self refleshMapView];
    [self hideProgressView];
}

-(void)saveMap:(id)sender{
    if (project&&project.projectName) {
        [project saveMap];
        [self tips:[NSString stringWithFormat:@"%@ saved!",project.projectName]];
    }else{
        [self tips:@"There's no map opend!"];
    }
   }

-(void)changeMapMode:(id)sender{
    UISegmentedControl  *seg = sender;
    int index =[seg selectedSegmentIndex];
    switch (index) {
        case 0:
            mapView.mapMode = zMAP_MODE_COLORRECT;
            break;
        case 1:
            mapView.mapMode = zMAP_MODE_REALTIME2D;
            break;
        case 2:
            mapView.mapMode = zMAP_MODE_DATA;
            break;
        default:
            mapView.mapMode = zMAP_MODE_REALTIME2D;
            break;
    }
    [mapView setNeedsDisplay];
}

-(void)changeBackColor:(id)sender{
    UISegmentedControl  *seg = sender;
    int index =[seg selectedSegmentIndex];
    mapView.colorMode = index;
    [mapView setNeedsDisplay];
}

-(void)toggleTilesView:(id)sender{
    if(tilesHide){
        [UIView beginAnimations:@"show" context:nil];
        tilesDrawer.center = CGPointMake(zTILES_X_SHOW, tilesDrawer.center.y);
        [drawerSwitch setImage:[UIImage imageNamed:@"collapse.png"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        tilesHide = NO;
        toggle = [NSTimer scheduledTimerWithTimeInterval:5 
                                                  target:self 
                                                selector:@selector(toggleTilesView:) 
                                                userInfo:nil 
                                                 repeats:NO];
    }else{
        [UIView beginAnimations:@"hide" context:nil];
        tilesDrawer.center = CGPointMake(zTILES_X_HIDE, tilesDrawer.center.y);
        [drawerSwitch setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        tilesHide = YES;
        [toggle invalidate];
    }
}

#pragma -
#pragma popup dialog
- (IBAction)showPopoverWithBarItem:(id)sender Controller:(UIViewController*)controller height:(float)height{
    if (detailViewPopover != nil) {
        [detailViewPopover dismissPopoverAnimated:NO];
    }
	UIBarButtonItem *focusButton = (UIBarButtonItem *)sender;
    detailViewPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller.view sizeToFit];
	detailViewPopover.popoverContentSize = CGSizeMake(320, controller.view.frame.size.height);
//    detailViewPopover.popoverContentSize = controller.view.frame.size;
	detailViewPopover.delegate = self;
	[detailViewPopover presentPopoverFromBarButtonItem:focusButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([[touches anyObject] tapCount] == 2) {
        [UIView beginAnimations:@"resetScale" context:(__bridge void*)self];
        [UIView setAnimationDuration:.5f];
        scrollView.zoomScale = 1;
        [UIView commitAnimations];
    }
    if(!tilesHide&&[[touches anyObject] view] != tilesDrawer)
        [self toggleTilesView:nil];
}

#pragma mark -
#pragma mark tableview

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int section =[indexPath section];
    Tile *item = [[itemsArray objectAtIndex:section] objectAtIndex:[indexPath row]];
    if (item.value == zMOVING_VALUE) {
        scrollView.scrollEnabled = YES;
        mapView.curBrush = item.value;
    }else{
        mapView.curBrush = item.value;
        scrollView.scrollEnabled = NO;
    }
    if (tilesHide) {

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[itemsArray objectAtIndex:section] count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [itemsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"tilesIden";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:identifier] ;
        if ([indexPath section] == 1) {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeInfoDark] ;
            b.frame = CGRectMake(190, 5, 35, 35);
            [b setTitle:@"hello" forState:UIControlStateNormal];
            b.tag = [indexPath row];
            [b addTarget:self action:@selector(showTileEditArea:) forControlEvents:UIControlEventTouchUpInside];
            [[cell contentView] addSubview:b];
        }
    }   
    Tile *item = [[itemsArray objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];        
    cell.textLabel.text = [item title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"0x%x",[item value]];
    cell.imageView.image = [item image]; 

    return cell;
}

#pragma mark -
#pragma mark tile operation

-(void)showTileEditArea:(id)sender{
    UIButton *btn = sender;
    CATransition *animation = [CATransition animation];  
    [animation setDelegate:self];  
    [animation setDuration:0.2f];  
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];  
    [animation setType: kCATransitionMoveIn];  
    [animation setSubtype: kCATransitionFromRight];      

    if (tileAddingC == nil) {
        tileAddingC = [[TileAddController alloc] initWithNibName:@"TileAddController" bundle:nil];
        tileAddingView = tileAddingC.view;
    }
    tileAddingView.hidden = NO;
    tileAddingView.frame = CGRectMake(1014 - zDIALOG_ADD_WIDTH, 100, zDIALOG_ADD_WIDTH, zDIALOG_ADD_HEIGHT);
    [self.view addSubview:tileAddingView];
    if ([[itemsArray objectAtIndex:1] count] > btn.tag) {
        [tileAddingC setCurTile:[[itemsArray objectAtIndex:1] objectAtIndex:btn.tag]];
    }else{
        [tileAddingC setCurTile:nil];
    }
    tileAddingC.mec = self;

    [tileAddingView.layer addAnimation:animation forKey:@"pageCurlAnimation"];
    tilesDrawer.alpha = 0;
    [tilesDrawer.layer addAnimation:animation forKey:@"pageCurlAnimation"];
}

-(void)showTilesDrawer:(id)sender{
    CATransition *animation = [CATransition animation];  
    [animation setDelegate:self];  
    [animation setDuration:0.2f];  
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];  
    [animation setType: kCATransitionFade];  
    tilesDrawer.alpha = 1;
    [tilesDrawer.layer addAnimation:animation forKey:@"pageCurlAnimation"];
}
-(void)closeModal:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    [detailViewPopover dismissPopoverAnimated:NO];
}
-(void)showEmailView{
    if (!project||!project.projectName) {
        [self tips:@"Current map is null"];
        return;
    }
    mailSender = [[MailComposerViewController alloc] initWithController:self];
    mailSender.title = project.projectName;
    mailSender.content = project.map2Str;
    UIGraphicsBeginImageContext(self.mapView.bounds.size); //currentView当前的view
    
    [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    mailSender.attchment = UIImageJPEGRepresentation(viewImage, 10);
    [mailSender showPicker:nil];
}
-(void)showHelpView:(id)sender{
    GuideController *scroller = [[GuideController alloc] initWithNibName:@"GuideView" bundle:nil];
    UIScrollView *scrollViewer = (UIScrollView*)scroller.view;
    scrollViewer.contentSize = CGSizeMake(5 * 1024, 718);
    scrollViewer.directionalLockEnabled = YES;
    scrollViewer.pagingEnabled = true;
    for (int i = 1; i <= 5; i++) {
        UIImageView *uv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide%d.png",i]]];
        uv.frame = CGRectMake((i-1)*1024, 0, 1024, 768);
        [scroller.view addSubview:uv];
    }
    UIImageView *close = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backToMap.png"]];
    CGRect rect = close.frame;
    rect.origin.x = 5*1024-200;
    rect.origin.y = 290;
    close.frame = rect;
    close.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeModal:)];
    [close addGestureRecognizer:singleTap];    [scroller.view addSubview:close];
    scroller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:scroller animated:YES ];
}

#pragma mark -
#pragma mark Popover controller delegates

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
}
#pragma mark -
#pragma mark imagepicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
   // [addImage setImage:image forState:UIControlStateNormal] ;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark scrolldelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return mapView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
}

#pragma mark -
#pragma mark life cycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)tips:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)initDemos{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
                         objectAtIndex:0];
    NSString *resPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"initData.zip"];    
    ZipArchive* zip = [[ZipArchive alloc] init];    
    NSString* l_zipfile = resPath;
    NSString* unzipto = docPath;
    if( [zip UnzipOpenFile:l_zipfile] )
    {
        BOOL ret = [zip UnzipFileTo:unzipto overWrite:YES];
        if( NO==ret )
        {
        }
        [zip UnzipCloseFile];
    }
}

-(void)testing:(id)sender{
//    TileGridController *tableCon = [[TileGridController alloc] initWithStyle:UITableViewStylePlain];
//    [self showPopoverWithBarItem:sender Controller:tableCon];
    UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"title" message:@"msg" delegate:self cancelButtonTitle:@"a" otherButtonTitles:@"b", nil];
    [a show];
}


@end
