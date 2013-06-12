//
//  TileAddController.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-16.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "NSString-Hex.h"
#import "UIColor-array.h"
#import "TileImgSelectController.h"
#import "Tile.h"

@class MapEditorHDViewController;

@interface TileAddController : UIViewController 
<UIPickerViewDelegate, UIPickerViewDataSource,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, 
UIPopoverControllerDelegate,
TileImgSelectDelegate>
{
    MapEditorHDViewController *mec;
    NSDictionary *pickerData;
    UIImage *imageChange;
    UIImage *imageAdd;

    UIPopoverController *imagePopover;
    UISegmentedControl *tileTypeSeg;
    UIPickerView *colorPicker;
    UIButton *tileImageButton;
    UITextField *titleTF;
    UITextField *valueTF;
    
    Tile* curTile;
    UIColor *curColor;
    TileType curTileType;
    BOOL updating;
}

@property (strong, nonatomic) MapEditorHDViewController *mec;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tileTypeSeg;
@property (strong, nonatomic) IBOutlet UIPickerView *colorPicker;
@property (strong, nonatomic) IBOutlet UIButton *tileImageButton;
@property (strong, nonatomic) IBOutlet UITextField *titleTF;
@property (strong, nonatomic) IBOutlet UITextField *valueTF;

-(IBAction) chooseImage:(id)sender;
-(IBAction) creatTile:(id)sender;
-(IBAction) setCurTile:(Tile *)pTile;
-(IBAction) changeTileType:(id)sender;
-(IBAction) cancelEdit:(id)sender;
-(IBAction) saveEdit:(id)sender;

@end
