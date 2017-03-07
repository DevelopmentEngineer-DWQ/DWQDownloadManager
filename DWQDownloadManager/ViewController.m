//
//
//  DWQDownloadManager.m
//  DWQDownloadManagerExample
//
//  Created by 杜文全 on 14/5/16.
//  Copyright © 2014年 duwenquan. All rights reserved.
//

#import "ViewController.h"
#import "DWQDownloadManager.h"


@interface ViewController ()
/** 进度UILabel */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel1;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel2;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel3;

/** 进度UIProgressView */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView1;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView2;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView3;

/** 下载按钮 */
@property (weak, nonatomic) IBOutlet UIButton *downloadButton1;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton2;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton3;

@end

@implementation ViewController

//视频
NSString * const downloadUrl1 = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
//图片
NSString * const downloadUrl2 = @"http://pic6.nipic.com/20100330/4592428_113348097000_2.jpg";

//视频
NSString * const downloadUrl3 = @"https://hximgtest.acool.pro/uploads/video/jinghuahezi.mp4";
//

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
    
    [self refreshDataWithState:DownloadStateSuspended];
}

#pragma mark 刷新数据
- (void)refreshDataWithState:(DownloadState)state
{
    self.progressLabel1.text = [NSString stringWithFormat:@"%.f%%", [[DWQDownloadManager sharedInstance] progress:downloadUrl1] * 100];
    self.progressView1.progress = [[DWQDownloadManager sharedInstance] progress:downloadUrl1];
    [self.downloadButton1 setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
    
    self.progressLabel2.text = [NSString stringWithFormat:@"%.f%%", [[DWQDownloadManager sharedInstance] progress:downloadUrl2] * 100];
    self.progressView2.progress = [[DWQDownloadManager sharedInstance] progress:downloadUrl2];
    [self.downloadButton2 setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
    
    self.progressLabel3.text = [NSString stringWithFormat:@"%.f%%", [[DWQDownloadManager sharedInstance] progress:downloadUrl3] * 100];
    self.progressView3.progress = [[DWQDownloadManager sharedInstance] progress:downloadUrl3];
    [self.downloadButton3 setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
    NSLog(@"-----%f", [[DWQDownloadManager sharedInstance] progress:downloadUrl1]);
    NSLog(@"-----%f", [[DWQDownloadManager sharedInstance] progress:downloadUrl2]);
}

#pragma mark 下载按钮事件
- (IBAction)download1:(UIButton *)sender {
    
    [self download:downloadUrl1 progressLabel:self.progressLabel1 progressView:self.progressView1 button:sender];
}

- (IBAction)download2:(UIButton *)sender {
    
    [self download:downloadUrl2 progressLabel:self.progressLabel2 progressView:self.progressView2 button:sender];
}

- (IBAction)download3:(UIButton *)sender {
    
    [self download:downloadUrl3 progressLabel:self.progressLabel3 progressView:self.progressView3 button:sender];
}

#pragma mark 删除
- (IBAction)deleteFile1:(UIButton *)sender {
    [[DWQDownloadManager sharedInstance] deleteFile:downloadUrl1];

    self.progressLabel1.text = [NSString stringWithFormat:@"%.f%%", [[DWQDownloadManager sharedInstance] progress:downloadUrl1] * 100];
    self.progressView1.progress = [[DWQDownloadManager sharedInstance] progress:downloadUrl1];
    [self.downloadButton1 setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
}

- (IBAction)deleteFile2:(UIButton *)sender {
    [[DWQDownloadManager sharedInstance] deleteFile:downloadUrl2];
    self.progressLabel2.text = [NSString stringWithFormat:@"%.f%%", [[DWQDownloadManager sharedInstance] progress:downloadUrl2] * 100];
    self.progressView2.progress = [[DWQDownloadManager sharedInstance] progress:downloadUrl2];
    [self.downloadButton2 setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
}

- (IBAction)deleteFile3:(UIButton *)sender {
    [[DWQDownloadManager sharedInstance] deleteFile:downloadUrl3];
    self.progressLabel3.text = [NSString stringWithFormat:@"%.f%%", [[DWQDownloadManager sharedInstance] progress:downloadUrl3] * 100];
    self.progressView3.progress = [[DWQDownloadManager sharedInstance] progress:downloadUrl3];
    [self.downloadButton3 setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
}

- (IBAction)deleteAllFile:(UIButton *)sender {
    [[DWQDownloadManager sharedInstance] deleteAllFile];
    [self refreshDataWithState:DownloadStateSuspended];
}


#pragma mark 开启任务下载资源
- (void)download:(NSString *)url progressLabel:(UILabel *)progressLabel progressView:(UIProgressView *)progressView button:(UIButton *)button
{
    [[DWQDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            progressView.progress = progress;
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
        });
    }];
}

#pragma mark 按钮状态
- (NSString *)getTitleWithDownloadState:(DownloadState)state
{
    switch (state) {
        case DownloadStateStart:
            return @"暂停";
        case DownloadStateSuspended:
        case DownloadStateFailed:
            return @"开始";
        case DownloadStateCompleted:
            return @"完成";
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
