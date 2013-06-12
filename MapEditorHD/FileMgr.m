//
//  FilePicker.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-18.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "FileMgr.h"
#import "Project.h"

@implementation FileMgr

@synthesize curDictionary;
@synthesize rootDictionary;

static FileMgr *defaultMgr = nil;    
+(FileMgr *)defaultFileMgr{
    @synchronized(self){
        if (!defaultMgr) {
            defaultMgr = [[self alloc] init];        
            defaultMgr->fManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
            defaultMgr.rootDictionary = [[paths objectAtIndex:0] copy];
            defaultMgr.curDictionary = [defaultMgr.rootDictionary copy];
        }
    }
    return defaultMgr;
}

/**
 
 */
-(NSArray *)listFile{
    NSArray *array ;
    array = [fManager contentsOfDirectoryAtPath:curDictionary error:nil ];
    return array;
}
-(NSArray *)listFileWithExtensions:(NSArray *)extensions{
    NSMutableArray *array;
    array = [NSMutableArray arrayWithArray:[fManager  contentsOfDirectoryAtPath:rootDictionary error:nil ]];
    for (int i = 0; i < [array count]; i++) {
        NSString *file = [array objectAtIndex:i];
        BOOL included = NO;
        if (extensions) {
            for (int j = 0; j < [extensions count]; j++) {
                NSString *extension = [extensions objectAtIndex:j];
                if ([file rangeOfString:extension].length) {
                    included = YES;
                    break;
                }
            }
        }

        if (!included) {
            [array removeObjectAtIndex:i];
            i--;
        }
    }
    return array;
}
-(NSMutableArray *)listProject{
    NSMutableArray *files ;
    files = [NSMutableArray arrayWithArray:[fManager contentsOfDirectoryAtPath:rootDictionary error:nil]];
    BOOL isDir;
    NSString *curDir;
    for (int i = 0;i < [files count];i++) {
        NSString *file = [files objectAtIndex:i];
        curDir = [rootDictionary stringByAppendingPathComponent:file];
        if([fManager fileExistsAtPath:curDir isDirectory:&isDir]){
            if (isDir) {
                if (![fManager fileExistsAtPath:[curDir stringByAppendingPathComponent:zPROJ_CONFIG_FILE]]) {
                    [files removeObject:file];
                    i--;
                }
            }else{
                [files removeObject:file];
                i--;
            }
        }
    }
    return files;
}

-(BOOL)createProjectDir:(Project *)project{
    NSString *root = rootDictionary;
    if (fManager&&project) {
        NSString *projectPath = [root stringByAppendingPathComponent:project.projectName];
        if([fManager fileExistsAtPath:projectPath]){
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Map %@ has existed!",project.projectName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [a show];
            return NO;
        }
        
        [fManager createDirectoryAtPath:projectPath withIntermediateDirectories:NO attributes:nil error:nil];
        [self openProject:project];
        return YES;
    }
    return NO;
}

-(BOOL)openProject:(Project *)project{
    curDictionary = [[rootDictionary stringByAppendingPathComponent:project.projectName] copy];
    return YES;
}

-(BOOL)changeDir:(NSString *)direction{
    NSString *dir = [rootDictionary stringByAppendingPathComponent:direction];
    BOOL isDir;
    if ([fManager fileExistsAtPath:dir isDirectory:&isDir]) {
        if (!isDir) {
            return NO;
        }else{
            curDictionary = [[rootDictionary stringByAppendingPathComponent:direction] copy];
            return YES;
        }
    }
    return NO;
}

-(BOOL)importTileFileFrom:(Tile *)tile move:(BOOL) isMove{
    if ([Project currentProject] == nil) {
        return NO;
    }
    NSArray *fileSp= [[tile imagePath] componentsSeparatedByString:@"/"];
    NSString *imageName = [fileSp objectAtIndex:[fileSp count]-1];
    NSString *imageFile = [curDictionary stringByAppendingPathComponent:imageName];
    BOOL succ = NO;
    if (isMove) {
        succ = [fManager moveItemAtPath:[tile imagePath] toPath:imageFile error:nil];
    }else{
        succ = [fManager copyItemAtPath:[tile imagePath] toPath:imageFile error:nil];
    }
    if (succ) {
        tile.imagePath = imageFile;
        tile.image = [UIImage imageWithContentsOfFile:imageFile];
        return YES;
    }
    return NO;
}
-(BOOL)importTileFileFromLib:(Tile *)tile {
    if ([Project currentProject] == nil) {
        return NO;
    }
    NSString *imageFile = [curDictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", tile.title]];
    int i = 0;
    while ([fManager fileExistsAtPath:imageFile]) {
        imageFile = [curDictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png", tile.title, i++]];
    }
    if ([UIImagePNGRepresentation(tile.image) writeToFile:imageFile atomically:YES]) {
        tile.imagePath = imageFile;
        return YES;
    }
    return NO;
}

@end
