//
//  TileImgSelectController.h
//  MapEditorHD
//
//  Created by Nullin on 11-7-16.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileMgr.h"
@protocol TileImgSelectDelegate;
@interface TileImgSelectController : UITableViewController {
    FileMgr *fm;
    NSArray *imagePathes;
    id<TileImgSelectDelegate> delegate;
}

@property (strong, nonatomic) id<TileImgSelectDelegate> delegate;

@end
@protocol TileImgSelectDelegate
-(void)tileImgSelectController:(TileImgSelectController *)picker didFinishPickingImage:(UIImage *)image ;
@end