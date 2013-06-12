//
//  RowView.h
//  MapEditorHD
//
//  Created by Nullin on 11-7-5.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tile.h"

@interface TileLoadingCell : UITableViewCell {
    UITextField *titleTF;
    UITextField *valueTF;
    UIImageView *imageIV;
}

@property (strong, nonatomic) IBOutlet UITextField *titleTF;
@property (strong, nonatomic) IBOutlet UITextField *valueTF;
@property (strong, nonatomic) IBOutlet UIImageView *imageIV;

-(void)setTile:(Tile *)tile;
@end
