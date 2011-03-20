#import <UIKit/UIKit.h>

@interface EditingViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSMutableArray *editingContent;
    NSMutableDictionary *editingItem;
    NSDictionary *editingItemCopy;
    BOOL newItem;
	
	BOOL tramStopNotSelected;
	
	NSMutableString *tramStopText;
	NSMutableString *tramNumberText;
	NSMutableString *tramLocationText;
	
	NSArray *tramStopArray;
	NSMutableArray *tramNumberArray;
	
	UIPickerView *myPickerView;
	UIButton *myButton;
	UILabel *statusMessage;
	UILabel *headerMessage;
	UILabel *textMessage;
	
	NSURLConnection *netConnection;
	NSMutableData *rawData;
}

@property (nonatomic, retain) NSMutableArray *editingContent;
@property (nonatomic, retain) NSMutableDictionary *editingItem;
@property (nonatomic, copy) NSDictionary *editingItemCopy;
@property (nonatomic, retain) IBOutlet UIPickerView *myPickerView;
@property (nonatomic, retain) IBOutlet UIButton *myButton;
@property (nonatomic, retain) IBOutlet UILabel *statusMessage;
@property (nonatomic, retain) IBOutlet UILabel *headerMessage;
@property (nonatomic, retain) IBOutlet UILabel *textMessage;

- (void)cancel;
- (void)save;

- (void)getData;

- (IBAction)buttonAction:(id)sender;
    
@end