//
//  Project.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-26.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "Project.h"


@implementation Project
@synthesize fm;
@synthesize projectName;
@synthesize resPath;
@synthesize description;
@synthesize resMapping;
@synthesize tilesArray;
@synthesize map;

static Project *curProject = nil;    

+(Project *)currentProject{
    @synchronized(self){
        if (!curProject) {
            curProject = [[self alloc] init];        
            curProject.resMapping = [[NSMutableDictionary alloc] init];
            curProject.tilesArray = [[NSMutableArray alloc] init];
            curProject.fm = [FileMgr defaultFileMgr];
        }
    }
    return curProject;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (curProject == nil) {
            curProject = [super allocWithZone:zone];
            return curProject; // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

-(void)generateMapWithWidth:(int)width Height:(int)height{
    
    map.mapData = malloc(width * height * sizeof(int));
    int i = -1;
    while (++i < width * height) {
        map.mapData[i] = 0;
    }
    map.width = width;
    map.height = height;
}

-(BOOL)save{
    [fm openProject:self];
    
    //save infomation
    NSMutableDictionary *projInfo = [[NSMutableDictionary alloc] init];
    [projInfo setValue:[self projectName] forKey:zPROJ_INFO_TITLE];
    [projInfo setValue:zPROJ_INFO_MAPFILE forKey:zPROJ_INFO_MAPFILE];
    [projInfo setValue:[NSNumber numberWithInt:map.width] forKey:zPROJ_INFO_MAPWIDTH];
    [projInfo setValue:[NSNumber numberWithInt:map.height] forKey:zPROJ_INFO_MAPHEIGHT];    
    [projInfo setValue:zPROJ_INFO_RESMAPPING forKey:zPROJ_INFO_RESMAPPING];
    [projInfo setValue:zPROJ_INFO_TILES forKey:zPROJ_INFO_TILES];
    [projInfo setValue:[self description] forKey:zPROJ_INFO_DESCRIPTION];
    [projInfo setValue:[self resPath] forKey:zPROJ_INFO_RESPATH];
    [projInfo writeToFile:[[fm curDictionary]stringByAppendingPathComponent:@"info.plist"] atomically:YES];
    
    //mapdata saving
    [self saveMap];
    
    //tilesArray saving
    [self saveTiles];
    
    //resmapping saving
    [self saveResMapping];
    
    return NO;
}

-(BOOL)saveTiles{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc ] initForWritingWithMutableData:data];
    NSString *tilesFile = [[[fm curDictionary] stringByAppendingPathComponent:zPROJ_INFO_TILES] copy];
    [archiver encodeObject:tilesArray forKey:zPROJ_INFO_TILES];
    [archiver finishEncoding];
    [data writeToFile:tilesFile atomically:YES];
    return NO;
}
-(BOOL)saveResMapping{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc ] initForWritingWithMutableData:data];
    NSString *resMappingFile = [[[fm curDictionary] stringByAppendingPathComponent:zPROJ_INFO_RESMAPPING] copy];
    [archiver encodeObject:resMapping forKey:zPROJ_INFO_RESMAPPING];
    [archiver finishEncoding];
    [data writeToFile:resMappingFile atomically:YES];
    return NO;
}

-(BOOL)saveMap{
   
    NSString *mapFile = [[fm curDictionary] stringByAppendingPathComponent:zPROJ_INFO_MAPFILE];
    [[self map2Str] writeToFile:mapFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return YES;
}

-(NSString *)map2Str{
    NSMutableString *mapStr = [[NSMutableString alloc] init];
    for (int i = 0; i< map.height; i++) {
        for (int j = 0 ; j< map.width; j++) {
            [mapStr appendFormat:@"%d ",map.mapData[i * map.width + j]];
        }
        [mapStr appendString:@"\n"];
    }
    return mapStr;
}

-(BOOL)loadWithProject:(NSString *)pProjectName{
    if (![fm changeDir:pProjectName]) {
        return NO;
    }
    NSMutableDictionary *projInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:[[fm curDictionary]stringByAppendingPathComponent:zPROJ_CONFIG_FILE]];
    self.projectName = [projInfo objectForKey:zPROJ_INFO_TITLE];
    self.resPath = [projInfo objectForKey:zPROJ_INFO_RESPATH];
    self.description = [projInfo objectForKey:zPROJ_INFO_DESCRIPTION];
   
    //load mapdata
    int width = [[projInfo objectForKey:zPROJ_INFO_MAPWIDTH] intValue];
    int height = [[projInfo objectForKey:zPROJ_INFO_MAPHEIGHT] intValue];
    NSString *mapFile = [[fm curDictionary] stringByAppendingPathComponent: [projInfo objectForKey:zPROJ_INFO_MAPFILE]];
    NSMutableString *mapStr = [[NSMutableString alloc] initWithContentsOfFile:mapFile encoding:NSUTF8StringEncoding error:nil];
    [mapStr replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, [mapStr length])];
    NSArray* intArray = [mapStr componentsSeparatedByString:@" "];
    if(!map.mapData)free(map.mapData);
    map.mapData = malloc(width * height *sizeof(int));
    map.width = width;
    map.height = height;
    for (int i = 0;i< width * height;i++ ) {
        map.mapData[i] = [[intArray objectAtIndex:i] intValue];
    }
    
    //load tiles
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[[fm curDictionary] stringByAppendingPathComponent:[projInfo objectForKey:zPROJ_INFO_TILES]]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc ] initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObjectForKey:zPROJ_INFO_TILES];
    tilesArray = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
    [unarchiver finishDecoding];
    
    //load resmapping
    data = [[NSMutableData alloc] initWithContentsOfFile:[[fm curDictionary] stringByAppendingPathComponent:[projInfo objectForKey:zPROJ_INFO_RESMAPPING]]];
    unarchiver = [[NSKeyedUnarchiver alloc ] initForReadingWithData:data];
    NSMutableDictionary *arrayUnArchive = [unarchiver decodeObjectForKey:zPROJ_INFO_RESMAPPING];
    resMapping = [[NSMutableDictionary alloc] initWithDictionary:arrayUnArchive copyItems:YES];
    [unarchiver finishDecoding];
    
    [fm openProject:self];
    return NO;
}
-(void)loadMap{

}

- (void)dealloc {
    free(&map);
}

-(void)setupTiles{
    
        
}
@end
