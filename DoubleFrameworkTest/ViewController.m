//
//  ViewController.m
//  DoubleFrameworkTest
//
//  Created by 清风徐来 on 2022/12/21.
//

#import "ViewController.h"
#import <MPPBHand/MPPBHand.h>
#import <MPPBFaceGeometry/MPPBFaceGeometry.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    dispatch_queue_t _videoBufferQueue;
}

@property (nonatomic, strong) MPPBHand * handTrack;
@property (nonatomic, strong) MPPBFaceGeometry * faceTrack;

@property (nonatomic, strong) AVCaptureDevice *mDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *mDeviceInput;
@property (nonatomic, readwrite, retain) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureSession *mSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *mPreviewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _videoBufferQueue = dispatch_queue_create("video_buffer_handle_queue", NULL);
    [self installCamera];
}


#pragma -mark Private

/**
 * 设置相机
 */
-(void)installCamera {
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    _mDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    _mDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.mDevice error:nil];
    
    //生成输出对象
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    _videoDataOutput.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    [_videoDataOutput setSampleBufferDelegate:self queue:_videoBufferQueue];
    
    //生成会话，用来结合输入输出
    _mSession = [[AVCaptureSession alloc] init];
    if ([_mSession canAddInput:self.mDeviceInput]) {
        [_mSession addInput:self.mDeviceInput];
    }
    
    if ([_mSession canAddOutput:_videoDataOutput]) {
        [_mSession addOutput:_videoDataOutput];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.mPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.mSession];
    self.mPreviewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.mPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.mPreviewLayer];

    [self.mSession startRunning];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

}


@end
