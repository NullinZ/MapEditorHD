//
//  BaseViewConteoller.m
//  MapEditorHD
//
//  Created by &#36213; &#30427; on 12-2-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

@synthesize HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)showProgressInView:(UIView*)pView {
	[self hideProgressView];
	
	self.HUD = [[TKLoadingView alloc] initWithTitle:@"正在载入..."];
	[self.HUD startAnimating];
	self.HUD.center = CGPointMake(self.view.bounds.size.width/2, 220);
    [pView addSubview:self.HUD];
}

-(void)hideProgressView {
	if (self.HUD) {
		[self.HUD stopAnimating];
		[self.HUD removeFromSuperview];
		self.HUD = nil;
	}
}


@end
