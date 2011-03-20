#import "MainViewCell.h"

@implementation MainViewCell

@synthesize tramStopString, tramNumberString, tramLocationString, prompt, promptMode;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialize the labels, their fonts, colors, alignment, and background color.
        tramStopString = [[UILabel alloc] initWithFrame:CGRectZero];
        tramStopString.font = [UIFont boldSystemFontOfSize:12];
        tramStopString.backgroundColor = [UIColor clearColor];
				
        tramNumberString = [[UILabel alloc] initWithFrame:CGRectZero];
        tramNumberString.font = [UIFont boldSystemFontOfSize:14];
        tramNumberString.backgroundColor = [UIColor clearColor];
        
        tramLocationString = [[UILabel alloc] initWithFrame:CGRectZero];
        tramLocationString.font = [UIFont boldSystemFontOfSize:12];
        tramLocationString.backgroundColor = [UIColor clearColor];
        
		prompt = [[UILabel alloc] initWithFrame:CGRectZero];
        prompt.font = [UIFont boldSystemFontOfSize:12];
        prompt.backgroundColor = [UIColor clearColor];
        
        // Add the labels to the content view of the cell.
        
        // Important: although UITableViewCell inherits from UIView, you should add subviews to its content view
        // rather than directly to the cell so that they will be positioned appropriately as the cell transitions 
        // into and out of editing mode.
        
        [self.contentView addSubview:tramStopString];
        [self.contentView addSubview:tramNumberString];
		[self.contentView addSubview:tramLocationString];
        [self.contentView addSubview:prompt];
    }
    return self;
}

- (void)dealloc {
    [tramStopString release];
    [tramNumberString release];
    [tramLocationString release];
    [prompt release];
    [super dealloc];
}

// Setting the prompt mode to YES hides the type/name labels and shows the prompt label.
- (void)setPromptMode:(BOOL)flag {
    if (flag) {
        tramStopString.hidden = YES;
        tramNumberString.hidden = YES;
		tramLocationString.hidden = YES;
        prompt.hidden = NO;
    } else {
        tramStopString.hidden = NO;
        tramNumberString.hidden = NO;
		tramLocationString.hidden = NO;
        prompt.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Start with a rect that is inset from the content view by 5 pixels on all sides.
    CGRect baseRect = CGRectInset(self.contentView.bounds, 5, 5);
    CGRect rect = baseRect;
    //rect.origin.x += 10;
	//rect.size.width = baseRect.size.width - 10;
    rect.origin.x += 10;
	rect.size.width = baseRect.size.width - 20;

    prompt.frame = rect;

	rect.origin.y += 0;
	
	rect.origin.x -= 3;
    tramNumberString.frame = rect;

	rect.origin.y -= 10;
	rect.origin.x += 35;
	tramLocationString.frame = rect;
    	
	//rect.origin.x -= 30;
	rect.origin.y += 20;
	tramStopString.frame = rect;
		
}

// Update the text color of each label when entering and exiting selected mode.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        tramStopString.textColor = [UIColor whiteColor];
        tramNumberString.textColor = [UIColor whiteColor];
		tramLocationString.textColor = [UIColor whiteColor];
        prompt.textColor = [UIColor whiteColor];
    } else {
        tramStopString.textColor = [UIColor grayColor];
        tramNumberString.textColor = [UIColor blackColor];
		tramLocationString.textColor = [UIColor blackColor];
        prompt.textColor = [UIColor darkGrayColor];
    }
}

@end
