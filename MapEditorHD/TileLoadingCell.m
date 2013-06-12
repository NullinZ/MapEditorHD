//
//  RowView.m
//  MapEditorHD
//
//  Created by Nullin on 11-7-5.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "TileLoadingCell.h"


@implementation TileLoadingCell
@synthesize titleTF;
@synthesize valueTF;
@synthesize imageIV;

-(void)setTile:(Tile *)tile{
    titleTF.text = tile.title;
    valueTF.text = [NSString stringWithFormat:@"%x", tile.value];
    imageIV.image = tile.image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
