//
//  TileAddController.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-16.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "TileAddController.h"
#import "MapEditorHDViewController.h"

@implementation TileAddController

@synthesize titleTF;
@synthesize valueTF;
@synthesize tileImageButton;
@synthesize mec;
@synthesize colorPicker;
@synthesize tileTypeSeg;

-(void)hideAddingPage{
    self.view.frame = CGRectMake(1024, 100, zDIALOG_ADD_WIDTH, zDIALOG_ADD_HEIGHT);
    self.view.hidden = YES;
    CATransition *animation = [CATransition animation];  
    [animation setDelegate:self];  
    [animation setDuration:0.2f];  
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];  
    [animation setType: kCATransitionMoveIn];  
    [animation setSubtype: kCATransitionFromLeft];
    [self.view.layer addAnimation:animation forKey:@"pageCurlAnimation"];
    if (mec) {
        [mec showTilesDrawer:nil];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)changeTileType:(id)sender{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    int selectIndex = seg.selectedSegmentIndex;
    switch (selectIndex) {
        case 0:
            curTileType = TileTypeImage;
            if (curTile.image) {
                [tileImageButton setBackgroundImage:curTile.image forState:UIControlStateNormal];
            }else{
                [tileImageButton setBackgroundImage:imageAdd forState:UIControlStateNormal];
            }
            break;
        case 1:
            curTileType = TileTypeLibImage;
            if (imageChange) {
                [tileImageButton setBackgroundImage:imageChange forState:UIControlStateNormal];
            }else{
                [tileImageButton setBackgroundImage:imageAdd forState:UIControlStateNormal];
            }
            break;
        case 2:
            curTileType = TileTypeColor;
            [tileImageButton setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        default:
            curTileType = TileTypeLibImage;
            break;
    }

    tileImageButton.backgroundColor = curColor;

}

-(void)cancelEdit:(id)sender{
    [self hideAddingPage];
}

-(void)saveEdit:(id)sender{
    int oldValue = curTile.value;
    Project *project = [Project currentProject];

    if (curTile) {  
        curTile.title = titleTF.text;
        curTile.value = [valueTF.text hexValue];
        curTile.color = curColor;
        if (curTileType == TileTypeLibImage) {
            curTileType = TileTypeImage;
        }
        curTile.tileType = curTileType;
        curTile.image = imageChange;
    }
    if (!updating) {
        curTile.image = imageChange;
        [project.tilesArray addObject:curTile];
        [project.resMapping setValue:curTile forKey:[NSString stringWithFormat:@"%x", curTile.value]];
    }else{
        [project.resMapping removeObjectForKey:[NSString stringWithFormat:@"%x", oldValue]];
        [project.resMapping setValue:curTile forKey:[NSString stringWithFormat:@"%x", curTile.value]];
    }
    [[FileMgr defaultFileMgr] importTileFileFromLib:curTile];
    [project saveTiles];
    [project saveResMapping];
    [self hideAddingPage];
    [mec.tilesView reloadData];
    
}

-(void)creatTile:(id)sender{


}
-(void)setCurTile:(Tile *)pTile{
    curTile = pTile;
    updating = YES;
    if (!curTile) {
        curTile = [[Tile alloc] initWithTitle:@"" Value:0 TileType:TileTypeImage Image:@""];
        updating = NO;
    }
    if (curTile.image) {
        [tileImageButton setBackgroundImage:curTile.image forState:UIControlStateNormal];
    }else{      
        [tileImageButton setBackgroundImage:imageAdd forState:UIControlStateNormal];
    }
    titleTF.text = curTile.title;
    valueTF.text =[NSString stringWithFormat:@"%x", curTile.value];
    [colorPicker selectRow:[[pickerData allValues] indexOfObject:curTile.color] inComponent:0 animated:YES];
    curColor = curTile.color;
    tileTypeSeg.selectedSegmentIndex=curTile.tileType;
    curTileType = curTile.tileType;
}


#pragma mark -
#pragma mark image picker

-(void)chooseImage:(id)sender{
    if (curTileType == TileTypeLibImage) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        if (imagePopover) {
//            [imagePopover release];
//        }
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:picker];

        imagePopover.popoverContentSize = CGSizeMake(zDIALOG_ADD_WIDTH, zDIALOG_ADD_HEIGHT);
        imagePopover.delegate = self;
        
        [imagePopover presentPopoverFromRect:CGRectMake(778, 170, 10, 10) inView:mec.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

    }else if(curTileType == TileTypeImage){
        TileImgSelectController *tableCon = [[TileImgSelectController alloc] 
                                              initWithStyle:UITableViewStylePlain];   
//        if (imagePopover) {
//            [imagePopover release];
//        }
        tableCon.delegate = self;
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:tableCon];
        
        imagePopover.popoverContentSize = CGSizeMake(540 , 748);
        imagePopover.delegate = self;
        
        [imagePopover presentPopoverFromRect:CGRectMake(778, 170, 10, 10) inView:mec.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];

    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if (image) {
        if(image.size.width > 100||image.size.height){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"image too large!" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        imageChange = image;
        [tileImageButton setBackgroundImage:imageChange forState:UIControlStateNormal];
    }
    [imagePopover dismissPopoverAnimated:NO];
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
}

#pragma mark -
#pragma mark picker datasource&delegate

-(void)tileImgSelectController:(TileImgSelectController *)picker didFinishPickingImage:(UIImage *)image{
    if (image) {
        imageChange = image;
        [tileImageButton setBackgroundImage:imageChange forState:UIControlStateNormal];
    }
    [imagePopover dismissPopoverAnimated:NO];
}

#pragma mark -
#pragma mark picker datasource&delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[pickerData allKeys] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[pickerData allKeys] objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zDIALOG_ADD_WIDTH - 50, 44)];
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
        colorView.tag = 100;
        [view addSubview:colorView];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, zDIALOG_ADD_WIDTH - 44 - 50, 44)];
        title.tag = 101;
        title.backgroundColor = [UIColor clearColor];
        [view addSubview:title];
    }

    UILabel *title = (UILabel*)[view viewWithTag:101];
    title.text = [[pickerData allKeys] objectAtIndex:row];
    UIView *iv = (UIView *)[view viewWithTag:100];
    iv.backgroundColor = [pickerData objectForKey:title.text];
    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    curColor = [[pickerData allValues] objectAtIndex:row];
    tileImageButton.backgroundColor = curColor;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    imageChange = imageAdd = [UIImage imageNamed:@"imageAdd.png"];
    pickerData = [UIColor listColor];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    titleTF = nil;
    valueTF = nil;
    tileImageButton = nil;
    colorPicker = nil;
    pickerData = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationLandscapeLeft == interfaceOrientation || UIInterfaceOrientationLandscapeRight == interfaceOrientation;
}

@end
