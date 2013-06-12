//
//  TKCoverView.m
//  Created by Devin Ross on 1/3/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TKCoverflowCoverView.h"
#import "UIImage+TKCategory.h"


@implementation TKCoverflowCoverView
@synthesize imageView;

- (id) initWithFrame:(CGRect)frame {
    if(!(self=[super initWithFrame:frame])) return nil;
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
	self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
	UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	bkView.image = [UIImage imageNamed:@"topitem_bk.png"];
	[self addSubview:bkView];
	[bkView release];

    self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4)] autorelease];
	self.imageView.contentMode = UIViewContentModeScaleToFill;
	self.imageView.layer.borderColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:0.8].CGColor;
	
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.cornerRadius = 2.0;  
    self.imageView.layer.masksToBounds = YES;  
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    
    return self;
}


- (void) setImage:(UIImage *)img {
	if (self.image != img) {
		[image release];
		image = [img retain];
		
		//imageView.frame = CGRectMake(30, y+30, w-60, h-60);
		self.imageView.image = image;
	}
}
- (UIImage*) image{
	return self.imageView.image;
}

- (void) dealloc {
	[image release];
	[imageView release];
    [super dealloc];
}


@end
