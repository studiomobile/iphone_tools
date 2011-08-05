//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "PagerController.h"

@interface PagerController ()
- (void)updateCurrentPage;
@end


@implementation PagerController

@synthesize delegate;
@synthesize dataSource;
@synthesize loadMargin;
@synthesize currentPage;


- (void)loadView {
    [super loadView];
    if (!self.view) {
        self.view = scrollView;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!scrollView) {
        assert([self.view isKindOfClass:[UIScrollView class]]);
        scrollView = (UIScrollView*)[self.view retain];
    }

    scrollView.pagingEnabled = YES;
    if (loadMargin == 0) {
        loadMargin = 2;
    }
    
    scrollView.delegate = self;
    pageControl.defersCurrentPageDisplay = YES;
    [pageControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged];
}


- (void)switchPage {
    [self switchToPage:pageControl.currentPage animated:YES];
}


- (BOOL)pagingEnabled {
    return scrollView.scrollEnabled;
}


- (void)setPagingEnabled:(BOOL)enabled {
    scrollView.scrollEnabled = enabled;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!pages.count) {
        [self reloadData];
    }
    [self updateCurrentPage];
}


- (void)scrollRight {
    if (!animating) {
        [self switchToPage:currentPage+1 animated:YES];
    }
}


- (void)scrollLeft {
    if (!animating) {
        [self switchToPage:currentPage-1 animated:YES];
    }
}


- (void)_loadPage:(NSUInteger)page {
    UIView *pageView = [pages objectAtIndex:page];
    if ([pageView isKindOfClass:[NSNull class]]) {
        pageView = [dataSource viewForPage:page inPager:self];
        if (pageView) {
            [pages replaceObjectAtIndex:page withObject:pageView];
            CGSize pageSize = scrollView.frame.size; 
            pageView.frame = CGRectMake(pageSize.width * page, 0, pageSize.width, pageSize.height);
            [scrollView addSubview:pageView];
        }
    }
}


- (void)_unloadPage:(NSUInteger)page {
    UIView *pageView = [pages objectAtIndex:page];
    if (![pageView isKindOfClass:[NSNull class]]) {
        [pageView removeFromSuperview];
        [delegate pagerController:self didUnloadPage:pageView atIndex:page];
        [pages replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


- (void)reloadData {
    NSUInteger numberOfPages = [dataSource numberOfPagesInPager:self];
    CGSize pageSize = scrollView.frame.size; 
    CGFloat totalWidth = numberOfPages * pageSize.width;
    pageControl.numberOfPages = numberOfPages;
    scrollView.contentSize = CGSizeMake(totalWidth, pageSize.height);
    
    for (int i = minLoadedPage; i < maxLoadedPage; i++) {
        [self _unloadPage:i];
    }

    minLoadedPage = maxLoadedPage = 0;
    
    [pages release];
    pages = [NSMutableArray new];
    for (int i = 0; i < numberOfPages; i++) {
        [pages addObject:[NSNull null]];
    }

    NSUInteger startIndex = [dataSource respondsToSelector:@selector(startPageIndex)] ? [dataSource startPageIndex] : currentPage;
    [self switchToPage:fmax(0, fmin(startIndex, pages.count-1)) animated:NO];
}


- (void)setActivePage:(NSUInteger)page {
    if (page >= pages.count) return;

    NSUInteger min = page > loadMargin ? page - loadMargin : 0;
    NSUInteger max = MIN(page + loadMargin + 1, pages.count);

    for (NSUInteger i = minLoadedPage; i < min; i++) {
        [self _unloadPage:i];
    }
    for (NSUInteger i = max; i < maxLoadedPage; i++) {
        [self _unloadPage:i];
    }
    
    [self _loadPage:page];
    for (NSUInteger i = min; i < max; i++) {
        [self _loadPage:i];
    }

    minLoadedPage = min;
    maxLoadedPage = max;
    
    currentPage = page;
    pageControl.currentPage = currentPage;
    [pageControl updateCurrentPageDisplay];
    [delegate pagerController:self didSwitchToPage:currentPage];
}


- (void)switchToPage:(NSUInteger)page animated:(BOOL)animated {
    if (page >= pages.count) return;

    CGSize pageSize = scrollView.frame.size;
    CGPoint offset = CGPointMake(page * pageSize.width, scrollView.contentOffset.y);
    [scrollView setContentOffset:offset animated:animated];
    
    animating = animated;

    if (!animated) {
        [self setActivePage:page];
    }
}


- (void)updateCurrentPage {
    CGFloat pageWidth = self.view.bounds.size.width;
    NSUInteger page = scrollView.contentOffset.x / pageWidth;
    if (scrollView.contentOffset.x - (page * pageWidth) > pageWidth / 2) {
        page++;
    }
    [self setActivePage:page];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self updateCurrentPage];
        animating = NO;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentPage];
    animating = NO;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateCurrentPage];
    animating = NO;
}


- (void)dealloc {
    [scrollView release];
    [pageControl release];
    [pages release];
    [super dealloc];
}


@end
