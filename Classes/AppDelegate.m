#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window, navigationController, mainViewController, data, pathToUserCopyOfPlist;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Check for data in Documents directory. Copy default appData.plist to Documents if not found.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.pathToUserCopyOfPlist = [documentsDirectory stringByAppendingPathComponent:@"appData.plist"];
    if ([fileManager fileExistsAtPath:pathToUserCopyOfPlist] == NO) {
        NSString *pathToDefaultPlist = [[NSBundle mainBundle] pathForResource:@"appData" ofType:@"plist"];
        if ([fileManager copyItemAtPath:pathToDefaultPlist toPath:pathToUserCopyOfPlist error:&error] == NO) {
            NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
        }
    }
    // Unarchive the data, store it in the local property, and pass it to the main view controller
    self.data = [[[NSMutableArray alloc] initWithContentsOfFile:pathToUserCopyOfPlist] autorelease];
	
	/*
	UIView *backgroundView = [[UIView alloc] initWithFrame:window.frame];
	backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IMainViewBackground.png"]];
	[window addSubview:backgroundView];
	[backgroundView release];
	mainViewController.view.backgroundColor = [UIColor clearColor];
	 */
	
    mainViewController.data = data;
    // Add the navigation controller's view to the window.
    [window addSubview:navigationController.view];
    // Show window
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [pathToUserCopyOfPlist release];
    [mainViewController release];
    [data release];
    [navigationController release];
    [window release];
    [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // save changes to plist in Documents
    [data writeToFile:pathToUserCopyOfPlist atomically:NO];
}

@end
