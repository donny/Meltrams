#import "MainViewController.h"
#import "MainViewCell.h"
#import "EditingViewController.h"
#import "JourneyViewController.h"
#import "InfoViewController.h"

@implementation MainViewController

@synthesize tableView, data, editingViewController, journeyViewController;

- (void)dealloc {
    tableView.delegate = nil;
    tableView.dataSource = nil;
    [tableView release];
    [data release];
    [editingViewController release];
	[journeyViewController release];
	[infoViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    // Add the built-in edit button item to the navigation bar. This item automatically toggles between
    // "Edit" and "Done" and updates the view controller's state accordingly.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	infoViewController = [[InfoViewController alloc] initWithNibName:@"Info" bundle:nil];

	// add our custom button to show our modal view controller
	//UIButton* modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	//[modalViewButton addTarget:self action:@selector(modalViewAction:) forControlEvents:UIControlEventTouchUpInside];	
	//UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
	
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" 
																	style:UIBarButtonItemStylePlain
																   target:self 
																   action:@selector(modalViewAction:)];
	self.navigationItem.leftBarButtonItem = modalButton;
	[modalButton release];
	
	
	/*
	// EMOJI

#define PREFS_FILE  @"/private/var/mobile/Library/Preferences/com.apple.Preferences.plist"
#define EMOJI_KEY  @"KeyboardEmojiEverywhere"

	// Read in prefs
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFS_FILE];
	if (!dict) 
	{
		NSLog(@"Cannot read dict");
	} else {
		NSLog(@"Can read dict");
		// Toggle the setting from on to off or vice versa
		//BOOL isSet = [[dict objectForKey:EMOJI_KEY] boolValue];
		//NSLog(@"%s key...\n", isSet ? "Removing" : "Setting");
		//if (isSet)
		//	[dict removeObjectForKey:EMOJI_KEY];
		//else
		//	[dict setObject:[NSNumber numberWithBool:YES] forKey:EMOJI_KEY];
		//[dict writeToFile:PREFS_FILE atomically:NO];

		[dict removeObjectForKey:EMOJI_KEY];
		//[dict setObject:[NSNumber numberWithBool:YES] forKey:EMOJI_KEY];
		[dict writeToFile:PREFS_FILE atomically:NO];

	}
	*/
	
}

// user clicked the "i" button, present info view as modal UIViewController
- (IBAction)modalViewAction:(id)sender {
	// present info view as a modal child or overlay view
	[self.navigationController presentModalViewController:infoViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [tableView reloadData];
}

- (EditingViewController *)editingViewController {
    // Instantiate the editing view controller if necessary.
    if (editingViewController == nil) {
        EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
        self.editingViewController = controller;
        [controller release];
    }
    return editingViewController;
}

- (JourneyViewController *)journeyViewController {
    // Instantiate the journey view controller if necessary.
    if (journeyViewController == nil) {
        JourneyViewController *controller = [[JourneyViewController alloc] initWithNibName:@"JourneyView" bundle:nil];
        self.journeyViewController = controller;
        [controller release];
    }
    return journeyViewController;
}

#pragma mark Table Content and Appearance

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // The number of sections is based on the number of items in the data property list.
    return [data count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // The number of rows in each section depends on the number of sub-items in each item in the data property list. 
    NSInteger count = [[[data objectAtIndex:section] valueForKeyPath:@"content.@count"] intValue];
    // If we're in editing mode, we add a placeholder row for creating new items.
    if (self.editing) count++;
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[data objectAtIndex:section] objectForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewCell *cell = (MainViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MainViewCell"];
    if (cell == nil) {
        cell = [[[MainViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MainViewCell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // The MainViewCell has two modes of display - either a type/name pair or a prompt for creating a new item of a type
    // The type derives from the section, the name from the item.
    NSDictionary *section = [data objectAtIndex:indexPath.section];
    if (section) {
        NSArray *content = [section valueForKey:@"content"];
        if (content && indexPath.row < [content count]) {
            NSDictionary *item = (NSDictionary *)[content objectAtIndex:indexPath.row];
			
			NSString *tramStopText = [item valueForKey:@"TramStop"];
			NSString *tramNumberText = [item valueForKey:@"TramNumber"];
			NSString *tramLocationText = [item valueForKey:@"TramLocation"];
			cell.tramStopString.text = tramStopText;
			cell.tramNumberString.text = tramNumberText;
			cell.tramLocationString.text = tramLocationText;
			
			cell.promptMode = NO;
        } else {
            cell.prompt.text = [NSString stringWithFormat:@"Add new %@", [section valueForKey:@"name"]];
            cell.promptMode = YES;
        }
    } else {
        cell.tramStopString.text = @"";
        cell.tramNumberString.text = @"";
		cell.tramLocationString.text = @"";
    }
    return cell;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.
    NSDictionary *section = [data objectAtIndex:indexPath.section];
    if (section) {
        NSArray *content = [section valueForKey:@"content"];
        if (content) {
            if (indexPath.row >= [content count]) {
                return UITableViewCellEditingStyleInsert;
            } else {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    return UITableViewCellEditingStyleNone;
}

#pragma mark Table Selection 

// Called after selection. In editing mode, this will navigate to a new view controller.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        // Don't maintain the selection. We will navigate to a new view so there's no reason to keep the selection here.
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // Go to edit view
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            // Make a local reference to the editing view controller.
            EditingViewController *controller = self.editingViewController;
            // Pass the item being edited to the editing controller.
            NSMutableArray *content = [section valueForKey:@"content"];
            if (content && indexPath.row < [content count]) {
                // The row selected is one with existing content, so that content will be edited.
                //NSMutableDictionary *item = (NSMutableDictionary *)[content objectAtIndex:indexPath.row];
                //controller.editingItem = item;
            } else {
                // The row selected is a placeholder for adding content. The editor should create a new item.
                controller.editingItem = nil;
                controller.editingContent = content;

				// Additional information for the editing controller.
				[self.navigationController pushViewController:controller animated:YES];

            }
        }
    } else {
        // This will give the user visual feedback that the cell was selected but fade out to indicate that no
        // action is taken.
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
        //[tableView deselectRowAtIndexPath:indexPath animated:NO];
		// Go to journey view
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            // Make a local reference to the journey view controller.
            JourneyViewController *controller = self.journeyViewController;
            // Pass the item being edited to the journey controller.
            NSMutableArray *content = [section valueForKey:@"content"];
			NSMutableDictionary *item = (NSMutableDictionary *)[content objectAtIndex:indexPath.row];
            // Additional information for the journey controller.
			controller.tramStopString = [item valueForKey:@"TramStop"];
			controller.tramNumberString = [item valueForKey:@"TramNumber"];
			controller.tramLocationString = [item valueForKey:@"TramLocation"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark Editing

// Set the editing state of the view controller. We pass this down to the table view and also modify the content
// of the table to insert a placeholder row for adding content when in editing mode.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Calculate the index paths for all of the placeholder rows based on the number of items in each section.
    NSArray *indexPaths = [NSArray arrayWithObjects:
            [NSIndexPath indexPathForRow:[[[data objectAtIndex:0] valueForKeyPath:@"content.@count"] intValue] inSection:0], nil];
    [tableView beginUpdates];
    [tableView setEditing:editing animated:YES];
    if (editing) {
        // Show the placeholder rows
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        // Hide the placeholder rows.
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    [tableView endUpdates];
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
            forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            NSMutableArray *content = [section valueForKey:@"content"];
            if (content && indexPath.row < [content count]) {
                [content removeObjectAtIndex:indexPath.row];
            }
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSDictionary *section = [data objectAtIndex:indexPath.section];
        if (section) {
            // Make a local reference to the editing view controller.
            EditingViewController *controller = self.editingViewController;
            NSMutableArray *content = [section valueForKey:@"content"];
            // A "nil" editingItem indicates the editor should create a new item.
            controller.editingItem = nil;
            // The group to which the new item should be added.
            controller.editingContent = content;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark Row reordering

// Determine whether a given row is eligible for reordering or not. In this app, all rows except the placeholders for
// new content are eligible, so the test is just the index path row against the number of items in the content.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // get the size of the content array
    NSUInteger numberOfRowsInSection = [[[data objectAtIndex:indexPath.section] valueForKeyPath:@"content.@count"] intValue];
    // Don't allow the placeholder to be moved.
    return (indexPath.row < numberOfRowsInSection);
}

// This allows the delegate to retarget the move destination to an index path of its choice. In this app, we don't want
// the user to be able to move items from one group to another, or to the last row of its group (the last row is
// reserved for the add-item placeholder).
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
        toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSDictionary *section = [data objectAtIndex:sourceIndexPath.section];
    NSUInteger sectionCount = [[section valueForKey:@"content"] count];
    // Check to see if the source and destination sections match. If not, retarget to either the top of the source
    // section (if the destination is above the source) or the bottom of the source section if not.
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSUInteger rowInSourceSection = (sourceIndexPath.section > proposedDestinationIndexPath.section) ? 0 : 
                sectionCount - 1;
        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
    // Check for moving to the placeholder row. If so, retarget to just above that row.
    } else if (proposedDestinationIndexPath.row >= sectionCount) {
        return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
    }
    // Allow the proposed destination.
    return proposedDestinationIndexPath;
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
            toIndexPath:(NSIndexPath *)toIndexPath {
    NSDictionary *section = [data objectAtIndex:fromIndexPath.section];
    if (section && fromIndexPath.section == toIndexPath.section) {
        NSMutableArray *content = [section valueForKey:@"content"];
        if (content && toIndexPath.row < [content count]) {
            id item = [[content objectAtIndex:fromIndexPath.row] retain];
            [content removeObject:item];
            [content insertObject:item atIndex:toIndexPath.row];
            [item release];
        }
    }
}

@end
