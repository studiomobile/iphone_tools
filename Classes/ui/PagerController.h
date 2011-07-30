//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <UIKit/UIKit.h>

@class PagerController;

@protocol PagerControllerDataSource
- (NSUInteger)numberOfPagesInPager:(PagerController*)pager;
- (UIView*)viewForPage:(NSUInteger)pageIndex inPager:(PagerController*)pager;
@end

@protocol PagerControllerDelegate
- (void)pagerController:(PagerController*)pager didSwitchToPage:(NSUInteger)page;
- (void)pagerController:(PagerController*)pager didUnloadPage:(UIView*)page atIndex:(NSUInteger)pageIndex;
@end



@interface PagerController : UIViewController<UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    id<PagerControllerDelegate> delegate;
    id<PagerControllerDataSource> dataSource;
    NSMutableArray *pages;
    NSUInteger loadMargin;

    NSUInteger currentPage;
    NSUInteger minLoadedPage;
    NSUInteger maxLoadedPage;
    BOOL animating;
}
@property (nonatomic, assign) IBOutlet id<PagerControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<PagerControllerDataSource> dataSource;
@property (nonatomic, readonly) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger loadMargin;
@property (nonatomic, assign) BOOL pagingEnabled;

- (void)switchToPage:(NSUInteger)page animated:(BOOL)animated;

- (IBAction)reloadData;

- (IBAction)scrollRight;
- (IBAction)scrollLeft;

@end
