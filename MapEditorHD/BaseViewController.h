//
//  BaseViewConteoller.h
//  MapEditorHD
//
//  Created by &#36213; &#30427; on 12-2-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKLoadingView.h"

@interface BaseViewController : UIViewController
{
 	TKLoadingView *HUD;   
}

@property (nonatomic,strong) TKLoadingView *HUD;
- (void)showProgressInView:(UIView*)pView;
- (void)hideProgressView;
@end
