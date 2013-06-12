//
//  Tile.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-16.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
typedef enum {TileTypeImage, TileTypeLibImage, TileTypeColor} TileType;
@interface Tile : NSObject <NSCoding, NSCopying>{
    TileType tileType;
    NSString *imagePath;
    NSString *title;
    UIImage* image;
    UIColor *color;
    int value;
}
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* imagePath;
@property (nonatomic) TileType tileType;
@property (nonatomic) int value;

-(id)initWithTitle:(NSString*)title Value:(int) value TileType:(TileType)tileType Image:(NSString*) imagePath;
-(id)initWithTitle:(NSString*)title Value:(int) value TileType:(TileType)tileType Image:(NSString*) imagePath Color:(UIColor*) color;
@end
