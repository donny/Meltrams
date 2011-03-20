#import <UIKit/UIKit.h>

// Forward declaration of the main view controller's class for the compiler.
@class MainViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    MainViewController *mainViewController;
    NSMutableArray *data;
    NSString *pathToUserCopyOfPlist;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *pathToUserCopyOfPlist;

@end
