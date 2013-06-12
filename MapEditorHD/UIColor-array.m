//
//  UIColor-array.m
//  MapEditorHD
//
//  Created by Nullin on 11-7-14.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import "UIColor-array.h"


@implementation UIColor (List)
+(NSDictionary *)listColor{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
             [UIColor redColor], @"Red",
             [UIColor greenColor], @"Green",
             [UIColor blueColor], @"Blue",
             [UIColor whiteColor], @"White",
             [UIColor blackColor], @"Black",
             [UIColor grayColor], @"Gray",
             [UIColor brownColor], @"Brown",
             [UIColor cyanColor], @"Cyan",
             [UIColor darkGrayColor], @"DarkGray",
             [UIColor darkTextColor], @"DrakText",
             [UIColor lightGrayColor], @"LightGray",
             [UIColor lightTextColor], @"LightText",
             [UIColor orangeColor], @"Orange",
             [UIColor purpleColor], @"Purple",
             [UIColor yellowColor], @"Yellow",
             nil];
}
@end
