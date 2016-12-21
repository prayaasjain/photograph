//
//  HomeFeedViewController.m
//  Photograph
//
//  Created by Prayaas Jain on 10/26/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "ImageDownloader.h"
#import "PictureCell.h"
#import "DataManager.h"

@interface HomeFeedViewController () <DataRefreshDelegate> {
    NSUInteger lastLoadedImageIndex;
}

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

static NSString *pictureCellReuseIdentifier = @"pictureCellReuseIdentifier";

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [[DataManager getInstance] setRefreshDelegate:self];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestFeed)
                  forControlEvents:UIControlEventValueChanged];
    
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    lastLoadedImageIndex = 0;
}


#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.tableData count] > 0) {
        return 1;
    }
    else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Oops! We couldn't load those cute puppy images\nPull to refresh";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:AppFont_SF_UI_Text_Regular size:15.0];
        [messageLabel sizeToFit];

        [self.tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width * 1.4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:pictureCellReuseIdentifier];
    PictureCellData *picData = (self.tableData)[indexPath.row];
    cell = [[PictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pictureCellReuseIdentifier withData:picData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self startImageDownload:picData forIndexPath:indexPath];
    return cell;
}

#pragma mark - Table Cell Image Support Operations
- (void)startImageDownload:(PictureCellData *)picData forIndexPath:(NSIndexPath *)indexPath {
    ImageDownloader *imgDownloader = (self.imageDownloadsInProgress)[indexPath];

    if (imgDownloader == nil) {
        imgDownloader = [[ImageDownloader alloc] init];
        imgDownloader.pictureURL = picData.imageURLString;
        [imgDownloader setMaxWidthForImage:self.view.frame.size.width];

        [imgDownloader setCompletionHandler:^(UIImage *image){
            PictureCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

            // display the newly loaded image
            cell.mainImage.image = image;
            lastLoadedImageIndex = indexPath.row;

            // remove the ImageDownloader object from the in progress list to free up memory
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];

        (self.imageDownloadsInProgress)[indexPath] = imgDownloader;
        [imgDownloader startDownload];
    }
}

// Loads images for the next 6 rows to be displayed
- (void)loadImagesForSubsequentRows {
    if ([self.tableData count] > 0) {
        int upperBound = lastLoadedImageIndex + 6 > [self.tableData count] ? (int)[self.tableData count] : (int)lastLoadedImageIndex + 6;

        for (int i=0; i<upperBound; i++) {
            PictureCellData *picData = (self.tableData)[i];
            if (!picData.image) {
                [self startImageDownload:picData forIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            }
        }
    }
}

- (void)getLatestFeed {
    [[DataManager getInstance] fetchTagBasedDataForTag:@"gameofthrones"];
}

#pragma mark - DataRefreshDelegate Methods
- (void)refreshWithData:(NSArray *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableData = data;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForSubsequentRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForSubsequentRows];
}

#pragma mark - Memory Clean Up
- (void)terminateAllDownloads {
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];

    [self.imageDownloadsInProgress removeAllObjects];
}

//  If this view controller is going away, we need to cancel all outstanding image downloads
- (void)dealloc {
    // terminate all pending download connections
    [self terminateAllDownloads];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
