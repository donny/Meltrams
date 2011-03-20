#import <UIKit/UIKit.h>

@interface MainViewCell : UITableViewCell {
    UITextField *tramStopString;
    UITextField *tramNumberString;
	UITextField *tramLocationString;
    UITextField *prompt;
    BOOL promptMode;
}

@property (readonly, retain) UITextField *tramStopString;
@property (readonly, retain) UITextField *tramNumberString;
@property (readonly, retain) UITextField *tramLocationString;
@property (readonly, retain) UITextField *prompt;
@property BOOL promptMode;

@end
