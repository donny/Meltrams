//
//  FirstLastExampleTableViewCell.m
//  FastScrolling
//
//  Created by Loren Brichter on 12/9/08.
//  Copyright 2008 atebits. All rights reserved.
//  http://blog.atebits.com/2008/12/fast-scrolling-in-tweetie-with-uitableview/
//

#import "JourneyViewCell.h"

@implementation JourneyViewCell

@synthesize firstText;
@synthesize secondText;
@synthesize lastText;

static UIFont *firstTextFont = nil;
static UIFont *secondTextFont = nil;
static UIFont *lastTextFont = nil;

+ (void)initialize
{
	if(self == [JourneyViewCell class])
	{
		firstTextFont = [[UIFont boldSystemFontOfSize:14] retain];
		secondTextFont = [[UIFont boldSystemFontOfSize:14] retain];
		lastTextFont = [[UIFont systemFontOfSize:12] retain];
		
		// Original code:
		//firstTextFont = [[UIFont boldSystemFontOfSize:12] retain];
		//lastTextFont = [[UIFont systemFontOfSize:12] retain];
		
		// this is a good spot to load any graphics you might be drawing in -drawContentView:
		// just load them and retain them here (ONLY if they're small enough that you don't care about them wasting memory)
		// the idea is to do as LITTLE work (e.g. allocations) in -drawContentView: as possible
	}
}

- (void)dealloc
{
	[firstText release];
	[secondText release];
	[lastText release];
    [super dealloc];
}

// the reason I don't synthesize setters for 'firstText' and 'lastText' is because I need to 
// call -setNeedsDisplay when they change

- (void)setFirstText:(NSString *)s
{
	[firstText release];
	firstText = [s copy];
	[self setNeedsDisplay]; 
}

- (void)setSecondText:(NSString *)s
{
	[secondText release];
	secondText = [s copy];
	[self setNeedsDisplay]; 
}

- (void)setLastText:(NSString *)s
{
	[lastText release];
	lastText = [s copy];
	[self setNeedsDisplay]; 
}

// override
- (void)setFrame:(CGRect)f
{
	[super setFrame:f];
	CGRect b = [self bounds];
	
	b.origin.x += 20;
	b.origin.y += 2;
	b.size.width -= 40;
	b.size.height -= 4;
	
	[contentView setFrame:b];
}

- (void)drawContentView:(CGRect)r
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	
	if(self.selected)
	{
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = 10;
	p.y = 10;
	
	[textColor set];
	
	[firstText drawAtPoint:p withFont:firstTextFont];

	p.x += 30;
	[secondText drawAtPoint:p withFont:firstTextFont];

	textColor = [UIColor darkGrayColor];
	[textColor set];
	
	p.x += 190;
	[lastText drawAtPoint:p withFont:lastTextFont];
}

@end
