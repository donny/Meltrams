#import "JourneyViewController.h"
#import "../JSON/JSON.h"
#import "JourneyViewCell.h"

@implementation JourneyViewController

@synthesize tableView, tramStopString, tramNumberString, tramLocationString, myHeaderView, headerTramLocation, myFooterView;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    if (self = [super initWithNibName:nibName bundle:bundle]) {
		// Initialization code
    }
	tableSections = [[NSMutableArray alloc] initWithCapacity:1];

    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[tableSections release];
    [tramStopString release];
	[tramNumberString release];
	[tramLocationString release];
	[myHeaderView release];
	[headerTramLocation release];
	[myFooterView release];
	tableView.delegate = nil;
	tableView.dataSource = nil;
    [tableView release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
	[self getData];
	myHeaderView.hidden = NO;
	myFooterView.hidden = YES;
	[tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
	//self.title = [NSString stringWithFormat:@"Tracker: %@", tramStopString];
	
	[self emptyTable];
    [tableView reloadData];
	
	myHeaderView.hidden = YES;
	myHeaderView.backgroundColor = [UIColor clearColor];
	headerTramLocation.text = [NSString stringWithFormat:@"%@", tramLocationString];
	myFooterView.hidden = NO;
	myFooterView.backgroundColor = [UIColor clearColor];
	
	tableView.tableHeaderView = myHeaderView;
	tableView.tableFooterView = myFooterView;
}

// The table uses standard UITableViewCells. The text for a cell is simply the string value of the matching type.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 	static NSString *CellIdentifier = @"JourneyViewCell";
	
	JourneyViewCell *cell = (JourneyViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[JourneyViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSString *arrivalString = [[tableSections objectAtIndex:indexPath.section] objectAtIndex:(indexPath.row + 1)];
	NSArray *arrivalInfo = [arrivalString componentsSeparatedByString:@"#"];
	
	cell.firstText = [arrivalInfo objectAtIndex:0];
	cell.secondText = [arrivalInfo objectAtIndex:1];
	cell.lastText = [arrivalInfo objectAtIndex:2];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return [[tableSections objectAtIndex:section] count] - 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [tableSections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[tableSections objectAtIndex:section] objectAtIndex:0];
}

- (void)emptyTable {
	[tableSections removeAllObjects];
	[tableSections addObject:[NSArray arrayWithObjects:@"", nil]];
	
	// The first member of the array is the title. Thus, [array count] MUST BE >= 1.
	//[tableSections addObject:[NSArray arrayWithObjects:@"Train Stations", @"Train1", @"Train2", nil]];
	//[tableSections addObject:[NSArray arrayWithObjects:@"Tram Stops", @"Tram1", @"Tram2", nil]];
	//[tableSections addObject:[NSArray arrayWithObjects:@"Bus Stops", @"Bus1", @"Bus2", nil]];	
	//Check for validity of data, if not valid, return this:
	//[tableSections addObject:[NSArray arrayWithObjects:@"", nil]];	
}

- (void)getData {
	[tableSections removeAllObjects];
	
	NSURL *url = [NSURL URLWithString:@"http://1.latest.meltrams.appspot.com/listArrivals"];
	NSMutableString *requestString = [NSMutableString stringWithString:@"stop="];
	[requestString appendString:tramStopString];
	[requestString appendString:@"&tram="];
	[requestString appendString:tramNumberString];
	
	NSData *requestData = [NSData dataWithBytes:[requestString UTF8String]
										 length:[requestString length]];
	
	NSMutableURLRequest *netRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[netRequest setHTTPMethod:@"POST"];
	[netRequest setHTTPBody:requestData];
	[netRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	BOOL canHandleRequest = [NSURLConnection canHandleRequest:netRequest];
	
	if (!canHandleRequest) {
		[tableSections addObject:[NSArray arrayWithObjects:@"", nil]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meltrams Error"
														message:@"No Internet connection."
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		[netRequest release];
		return;
	}
	
	
	
	NSMutableString *errorMessage = [NSMutableString stringWithCapacity:10];
	NSHTTPURLResponse *netResponse;
	NSError *netError;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSData *rawNetData = [NSURLConnection sendSynchronousRequest:netRequest 
											   returningResponse:&netResponse error:&netError];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[netRequest release];
	
	if ([netResponse statusCode] == 200) {
		NSString *json = [[NSString alloc] initWithData:rawNetData 
											   encoding:NSUTF8StringEncoding];
		NSMutableArray *netData = [json JSONValue];
		[json autorelease];
		
		if (netData != nil) {
			NSString *worqStatus = [[netData objectAtIndex:0] valueForKey:@"status"];
			NSString *worqMessage = [[netData objectAtIndex:0] valueForKey:@"message"];
			
			if ([worqStatus isEqualToString:@"WORQ-OK"] && [worqMessage isEqualToString:@"LA-OK"]) {
				NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:10];

				//[resultArray addObject:@"Journey Summaries"];
				[resultArray addObject:@""];
				
				NSDictionary *arrivals = [netData objectAtIndex:1];
				[resultArray addObjectsFromArray:[arrivals objectForKey:@"arrivals"]];

				[tableSections addObject:[NSArray arrayWithArray:resultArray]];
				[resultArray release];
				return;
			} else {
				//[errorMessage setString:worqStatus];
				[errorMessage setString:@"Server Error: "];
				[errorMessage appendString:worqMessage];
			}
		} else {
			[errorMessage setString:@"Invalid data from server."];
		}
	} else {
		[errorMessage setString:@"Invalid connection. Try again later."];
	}
	
	[tableSections addObject:[NSArray arrayWithObjects:@"", nil]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meltrams Error"
													message:errorMessage
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
