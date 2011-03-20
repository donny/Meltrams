#import <UIKit/UIKit.h>

@interface JourneyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
	NSString *tramStopString;
	NSString *tramNumberString;
	NSString *tramLocationString;
	NSMutableArray *tableSections;
	
	UIView *myHeaderView;
	UILabel *headerTramLocation;	
	UIView *myFooterView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *tramStopString;
@property (nonatomic, copy) NSString *tramNumberString;
@property (nonatomic, copy) NSString *tramLocationString;
@property (nonatomic, retain) IBOutlet UIView *myHeaderView;
@property (nonatomic, retain) IBOutlet UILabel *headerTramLocation;
@property (nonatomic, retain) IBOutlet UIView *myFooterView;


- (void)getData;
- (void)emptyTable;

@end