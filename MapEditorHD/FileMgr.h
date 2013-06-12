//
//  FilePicker.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-18.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"
@class Project;
@interface FileMgr : NSObject {
    NSString *rootDictionary;
    NSString *curDictionary;
    NSFileManager *fManager;
}

@property (strong, nonatomic) NSString *curDictionary;
@property (strong, nonatomic) NSString *rootDictionary;

+(id)defaultFileMgr;
-(NSArray *)listFile;
-(NSArray *)listFileWithExtensions:(NSArray*) extensions;
-(NSMutableArray *)listProject;
-(BOOL)openProject:(Project *)project;
-(BOOL)changeDir:(NSString *)direction;
-(BOOL)createProjectDir:(Project *) project;
-(BOOL)importTileFileFrom:(Tile *)tile move:(BOOL) isMove;
-(BOOL)importTileFileFromLib:(Tile *)tile;
@end
