//
//  MapEditorHDAppDelegate.h
//  MapEditorHD
//
//  Created by Nullin on 11-6-3.
//  Copyright 2011年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapEditorHDViewController;

@interface MapEditorHDAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet MapEditorHDViewController *viewController;

@end
