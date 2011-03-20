#import <UIKit/UIKit.h>

// Forward declaration of the editing view controller's class for the compiler.
@class EditingViewController;
@class JourneyViewController;
@class InfoViewController;

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
    NSMutableArray *data;
    EditingViewController *editingViewController;
	JourneyViewController *journeyViewController;
	InfoViewController *infoViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) EditingViewController *editingViewController;
@property (nonatomic, retain) JourneyViewController *journeyViewController;

@end
