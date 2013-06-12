//
//  MapEditorHDViewController.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-3.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tile.h"
#import "MapData.h"
#import "MapCanvas.h"
#import "TileGridController.h"
#import "ProjectInfoCreateController.h"
#import "ProjectListController.h"
#import "ProjectController.h"
#import "ProjectCreatingNavController.h"
#import "TileAddController.h"
#import "ExportTableController.h"
#import "BaseViewController.h"
#import "GuideController.h"
@class MailComposerViewController;

@interface MapEditorHDViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProjectController>{

    UIPopoverController *detailViewPopover;
    Project *project;
    FileMgr *fm;
    NSTimer *toggle;
    
    NSMutableArray *itemsArray;
    UITableView *tilesView;
    UIScrollView *scrollView;
    UILabel *mapDataLabel;
    UILabel *projectNameView;
    MapCanvas* mapView;

    UIView *tilesDrawer;
    UIButton *drawerSwitch;
    BOOL tilesHide;

    TileAddController *tileAddingC;
    UIView *tileAddingView;
    MailComposerViewController *mailSender;
}

@property (strong, nonatomic) FileMgr *fm;
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong,nonatomic) IBOutlet UIButton* drawerSwitch;
@property (strong,nonatomic) IBOutlet UITableView* tilesView;
@property (strong,nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong,nonatomic) IBOutlet UILabel* mapDataLabel;
@property (strong,nonatomic) IBOutlet UILabel* projectNameView;
@property (strong,nonatomic) IBOutlet UIView* tilesDrawer;
@property (strong,nonatomic) IBOutlet MapCanvas* mapView;

-(IBAction)toggleTilesView:(id)sender;
-(IBAction)createTile:(id)sender;
-(IBAction)createProject:(id)sender;
-(IBAction)showProjectList:(id)sender;
-(IBAction)changeMapMode:(id)sender;
-(IBAction)changeBackColor:(id)sender;
-(IBAction)saveMap:(id)sender;
-(void)showTilesDrawer:(id)sender;
-(void)showEmailView;
-(void)closeModal:(id)sender;
-(IBAction)showExportPopover:(id)sender;
-(IBAction)showHelpView:(id)sender;
-(IBAction)showPopoverWithBarItem:(id)sender Controller:(UIViewController*)controller height:(float) height;
-(IBAction)testing:(id)sender;
-(void)tips:(NSString *)msg;
-(void)initDemos;

@end
