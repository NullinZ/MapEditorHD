//
//  Project.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-26.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "FileMgr.h"
#import "Tile.h"
#import "MapData.h"
@interface Project : NSObject{
    FileMgr *fm;
    NSString *projectName;
    NSString *description;
    NSString *resPath;
    NSMutableDictionary *resMapping;
    NSMutableArray *tilesArray;   
    struct MapData map;
}   
@property (strong, nonatomic) FileMgr *fm;
@property (strong, nonatomic) NSMutableDictionary *resMapping;
@property (strong,nonatomic) NSMutableArray *tilesArray;
@property (strong,nonatomic) NSString *projectName;
@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSString *resPath;
@property (nonatomic) struct MapData map;

+(id)currentProject;
-(void)setupTiles;
-(BOOL)save;
-(NSString *)map2Str;
-(BOOL)saveMap;
-(BOOL)saveTiles;
-(BOOL)saveResMapping;
-(BOOL)loadWithProject:(NSString *)projectName;
-(void)generateMapWithWidth:(int)width Height:(int)height;

@end
