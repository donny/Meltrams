#import "EditingViewController.h"
#import "../JSON/JSON.h"

@implementation EditingViewController

@synthesize editingContent, editingItem, editingItemCopy, myPickerView, myButton, statusMessage, headerMessage, textMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																						 target:self action:@selector(save)];
		self.navigationItem.rightBarButtonItem = rightButtonItem;
		//[rightButtonItem release];
		
		UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						target:self action:@selector(cancel)];
		self.navigationItem.leftBarButtonItem = leftButtonItem;
		//[leftButtonItem release];
		
		tramStopArray = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
		[tramStopArray retain];
		
		tramNumberArray = [[NSMutableArray alloc] initWithCapacity:10];
		
		tramStopText = [[NSMutableString alloc] initWithCapacity:5];
		tramNumberText = [[NSMutableString alloc] initWithCapacity:5];
		tramLocationText = [[NSMutableString alloc] initWithCapacity:5];
    }
    return self;
}

// When we set the editing item, we also make a copy in case edits are made and then canceled - then we can
// restore from the copy.
- (void)setEditingItem:(NSMutableDictionary *)anItem {
    [editingItem release];
    editingItem = [anItem retain];
    self.editingItemCopy = editingItem;
}

- (void)dealloc {
	[self.navigationItem.rightBarButtonItem release];
	[self.navigationItem.leftBarButtonItem release];
	
	[tramStopText release];
	[tramNumberText release];
	[tramLocationText release];
	
	[myPickerView release];
	[myButton release];
	[statusMessage release];
	[headerMessage release];
	[textMessage release];
	
	[tramStopArray release];
	[tramNumberArray release];
	
    [editingContent release];
    [editingItem release];
    [editingItemCopy release];
    [super dealloc];
}

- (void)cancel {
    // cancel edits, restore all values from the copy
    newItem = NO;
    [editingItem setValuesForKeysWithDictionary:editingItemCopy];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    // save edits to the editing item and add new item to the content.
    [editingItem setValue:[NSString stringWithString:tramStopText] forKey:@"TramStop"];
    [editingItem setValue:[NSString stringWithString:tramNumberText] forKey:@"TramNumber"];
	[editingItem setValue:[NSString stringWithString:tramLocationText] forKey:@"TramLocation"];
    if (newItem) {
        [editingContent addObject:editingItem];
        newItem = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	tramStopNotSelected = TRUE;
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	
    self.title = @"Journey";
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
    // If the editing item is nil, that indicates a new item should be created
    if (editingItem == nil) {
        self.editingItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0000", @"TramStop", @"-", @"TramNumber", @"-", @"TramLocation", nil];
        // rather than immediately add the new item to the content array, set a flag. When the user saves, add the 
        // item then; if the user cancels, no action is needed.
        newItem = YES;
    }
    
    //tramStopLabel.text = [editingItem valueForKey:@"TramStop"];
	//[tramStopText setString:@"0000"];
    //tramNumberLabel.text = [editingItem valueForKey:@"TramNumber"];
	//[tramNumberText setString:@"-"];
	
	[tramStopText setString:[editingItem valueForKey:@"TramStop"]];
	[tramNumberText setString:[editingItem valueForKey:@"TramNumber"]];
	[tramLocationText setString:[editingItem valueForKey:@"TramLocation"]];
	
	statusMessage.text = @"";
	headerMessage.text = @"Select Tram Tracker ID";
	[myPickerView reloadAllComponents];
	[myPickerView selectRow:0 inComponent:0 animated:NO];
	[myPickerView selectRow:0 inComponent:1 animated:NO];
	[myPickerView selectRow:0 inComponent:2 animated:NO];
	[myPickerView selectRow:0 inComponent:3 animated:NO];

	myPickerView.hidden = FALSE;
	textMessage.hidden = TRUE;
	myButton.hidden = FALSE;
	
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return tramStopNotSelected ? 4 : 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if (tramStopNotSelected) {
		return 50;
	} else {
		return 210;
	}
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return tramStopNotSelected ? 10 : [tramNumberArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return tramStopNotSelected ? [tramStopArray objectAtIndex:row] : [tramNumberArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (tramStopNotSelected) {
		NSInteger c0 = [myPickerView selectedRowInComponent:0];
		NSInteger c1 = [myPickerView selectedRowInComponent:1];
		NSInteger c2 = [myPickerView selectedRowInComponent:2];
		NSInteger c3 = [myPickerView selectedRowInComponent:3];
		NSString *tramStop = [NSString stringWithFormat:@"%d%d%d%d", c0, c1, c2, c3];
		[tramStopText setString:tramStop];
	} else {
		[tramNumberText setString:[tramNumberArray objectAtIndex:row]];
	}
}

- (IBAction)buttonAction:(id)sender {
	if (tramStopNotSelected) {
		statusMessage.text = @"Fetching and validating data...";
		[self getData];
		//statusMessage.text = @"";
		
	} else {
		NSMutableString *text = [NSMutableString stringWithCapacity:100];
		[text appendString:[NSString stringWithFormat:@"Tram Tracker ID: %@\n", tramStopText]];
		[text appendString:[NSString stringWithFormat:@"Tram Number: %@\n\n", tramNumberText]];
		[text appendString:[NSString stringWithFormat:@"%@\n", tramLocationText]];

		headerMessage.text = @"Confirm Selection";
		
		textMessage.text = text;
		self.navigationItem.rightBarButtonItem.enabled = TRUE;

		myPickerView.hidden = TRUE;
		textMessage.hidden = FALSE;
		myButton.hidden = TRUE;

	}
	
	
/*	tramStopNotSelected = (((UISegmentedControl *) sender).selectedSegmentIndex == 0) ? TRUE : FALSE;
	if (tramStopNotSelected) {
		//tramStopLabel.text = @"0000";
		//tramNumberLabel.text = @"-";
		[myPickerView reloadAllComponents];
		[myPickerView selectRow:0 inComponent:0 animated:NO];
		[myPickerView selectRow:0 inComponent:1 animated:NO];
		[myPickerView selectRow:0 inComponent:2 animated:NO];
		[myPickerView selectRow:0 inComponent:3 animated:NO];
		self.navigationItem.rightBarButtonItem.enabled = FALSE;
	} else {
		//tramNumberLabel.text = @"-";
		
		[self getData];
		//statusMessage.text = @"";
		[myPickerView reloadAllComponents];
	}
 */
}



- (void)getData {
	NSURL *url = [NSURL URLWithString:@"http://1.latest.meltrams.appspot.com/listTrams"];
	NSMutableString *requestString = [NSMutableString stringWithString:@"stop="];
	[requestString appendString:tramStopText];
	
	NSData *requestData = [NSData dataWithBytes:[requestString UTF8String]
										 length:[requestString length]];
	
	NSMutableURLRequest *netRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[netRequest setHTTPMethod:@"POST"];
	[netRequest setHTTPBody:requestData];
	[netRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	statusMessage.text = @"Fetching and validating data...";
	
	rawData = [[NSMutableData alloc] initWithCapacity:50];
	netConnection = [[NSURLConnection alloc] initWithRequest:netRequest
													delegate:self startImmediately:YES];
	
	[netRequest autorelease];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[rawData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	statusMessage.text = @"Update Failed";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meltrams Error"
													message:@"Invalid Internet connection."
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[rawData release];
	[netConnection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	statusMessage.text = @"";
	
	NSMutableString *errorMessage = [NSMutableString stringWithCapacity:10];
	NSString *json = [[NSString alloc] initWithData:rawData 
										   encoding:NSUTF8StringEncoding];
	NSMutableArray *netData = [json JSONValue];
	[json autorelease];
		
	if (netData != nil) {
		NSString *worqStatus = [[netData objectAtIndex:0] valueForKey:@"status"];
		NSString *worqMessage = [[netData objectAtIndex:0] valueForKey:@"message"];
			
		if ([worqStatus isEqualToString:@"WORQ-OK"] && [worqMessage isEqualToString:@"LT-OK"]) {
			NSDictionary *trams = [netData objectAtIndex:1];
			NSDictionary *location = [netData objectAtIndex:2];
			
			[tramNumberArray removeAllObjects];
			[tramNumberArray addObjectsFromArray:[trams objectForKey:@"trams"]];
			[tramLocationText setString:[location objectForKey:@"location"]];

			tramStopNotSelected = FALSE;
			
			[myPickerView reloadAllComponents];
			[myPickerView selectRow:0 inComponent:0 animated:NO];
			[tramNumberText setString:@"Any"];
			
			headerMessage.text = @"Select Tram Number";
			
			[rawData release];
			[netConnection release];
			return;
		} else if ([worqStatus isEqualToString:@"WORQ-OK"] && [worqMessage isEqualToString:@"LT-NOTFOUND"]) {
			[errorMessage setString:@"Cannot find the Tram Tracker ID."];
		} else {
			//[errorMessage setString:worqStatus];
			[errorMessage setString:@"Server Error: "];
			[errorMessage appendString:worqMessage];
		}
	} else {
		[errorMessage setString:@"Invalid data from server."];
	}
	
	[rawData release];
	[netConnection release];
	
	statusMessage.text = errorMessage;
}



@end
