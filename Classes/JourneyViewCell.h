//
//  FirstLastExampleTableViewCell.h
//  FastScrolling
//
//  Created by Loren Brichter on 12/9/08.
//  Copyright 2008 atebits. All rights reserved.
//  http://blog.atebits.com/2008/12/fast-scrolling-in-tweetie-with-uitableview/
//

#import "ABTableViewCell.h"

// example table view cell with first text normal, last text bold (like address book contacts)
@interface JourneyViewCell : ABTableViewCell
{
	NSString *firstText;
	NSString *secondText;
	NSString *lastText;
}

@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *secondText;
@property (nonatomic, copy) NSString *lastText;

@end
