//
//  InfoViewController.h
//  Melb Journey
//
//  Created by Donny Kurniawan on 12/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController {
	UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)done:(id)sender;
- (IBAction)emailAction:(id)sender;
- (IBAction)findAction:(id)sender;

@end
