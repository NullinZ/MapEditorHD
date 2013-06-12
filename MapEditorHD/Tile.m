//
//  Tile.m
//  MapEditorHD
//
//  Created by Nullin on 11-6-16.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "Tile.h"
#import "UIColor-Random.h"
#import "FileMgr.h"
@implementation Tile
@synthesize imagePath;
@synthesize tileType;
@synthesize title;
@synthesize image;
@synthesize color;
@synthesize value;

-(id)initWithTitle:(NSString *)ptitle Value:(int)pvalue TileType:(TileType)ptileType Image:(NSString *)pimagePath{
    return [self initWithTitle:ptitle Value:pvalue TileType:ptileType Image:pimagePath Color:[UIColor randomColor]];
    
}
-(id)initWithTitle:(NSString *)ptitle Value:(int)pvalue TileType:(TileType)ptileType Image:(NSString *)pimagePath Color:(UIColor *)pcolor{
    self = [super init];
    if (self) {
        self.title = ptitle;
        self.imagePath = pimagePath;
        self.tileType = ptileType;
        UIImage *i;
        if (tileType == TileTypeLibImage) {
            i = [UIImage imageNamed:self.imagePath];
        }else if(tileType == TileTypeImage){
            i = [UIImage imageWithContentsOfFile:self.imagePath];
        }else{
            i = nil;
        }
        self.image = i;
        self.color = pcolor;
        self.value = pvalue;
    }
    return self; 
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        title = [coder decodeObjectForKey:@"title"];
        imagePath = [coder decodeObjectForKey:@"imagePath"];
        FileMgr *fm = [FileMgr defaultFileMgr];
        if([imagePath rangeOfString:[fm curDictionary]].length == 0){
            NSString * filename =  [[imagePath componentsSeparatedByString:@"/"] lastObject];
            imagePath = [[fm curDictionary] stringByAppendingPathComponent:filename];
        }
        tileType = [[coder decodeObjectForKey:@"tileType"] intValue];
        value = [[coder decodeObjectForKey:@"value"] intValue];
        color = [coder decodeObjectForKey:@"color"];
        UIImage *i;
        if (tileType == TileTypeLibImage) {
            i = [UIImage imageNamed:self.imagePath];
        }else if(tileType == TileTypeImage){
            i = [UIImage imageWithContentsOfFile:self.imagePath];
        }else{
            i = nil;
        }
        self.image = i;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:imagePath forKey:@"imagePath"];
    [aCoder encodeObject:[NSNumber numberWithInt:tileType] forKey:@"tileType"];
    [aCoder encodeObject:color forKey:@"color"];
    [aCoder encodeObject:[NSNumber numberWithInt:value] forKey:@"value"];

}

-(id)copyWithZone:(NSZone *)zone{
    Tile *copy = [[[self class] allocWithZone:zone] init];
    copy.title = [self.title copyWithZone:zone];
    copy.imagePath = [self.imagePath copyWithZone:zone];
    copy.color = [UIColor colorWithCGColor:self.color.CGColor];
    copy.tileType = self.tileType;
    copy.value = self.value;
    copy.image = [self.image copy];
    return copy;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"[title:%@, imagePath:%@, image:%@, color:%@, value:%x]", title, imagePath, image, color, value];
}
@end
