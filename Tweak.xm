#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

// Định nghĩa Dynamic Island View
@interface HDangDynamicView : UIView
@property (nonatomic, strong) UIView *expandedView;
@property (nonatomic, strong) UIView *compactView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *albumArtView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, strong) UIView *cameraDot;
@property (nonatomic, strong) UIView *sensorDot;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) BOOL isShowingMusic;
@property (nonatomic, assign) BOOL isShowingCall;
@property (nonatomic, assign) BOOL isShowingTimer;
@property (nonatomic, assign) BOOL isShowingBattery;
@property (nonatomic, assign) CGFloat originalWidth;
@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, strong) UILabel *notificationTitle;
@property (nonatomic, strong) UILabel *notificationMessage;
@property (nonatomic, strong) UIImageView *notificationIcon;
@property (nonatomic, strong) NSMutableArray *notificationQueue;
@property (nonatomic, assign) BOOL isShowingNotification;
@property (nonatomic, strong) UIView *volumeIndicator;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, assign) BOOL isShowingVolume;
@property (nonatomic, strong) NSTimer *volumeTimer;
@property (nonatomic, strong) UIView *chargingView;
@property (nonatomic, strong) UILabel *chargingLabel;
@property (nonatomic, assign) BOOL isShowingCharging;
@property (nonatomic, strong) NSTimer *batteryTimer;
@property (nonatomic, strong) UIView *airplaneView;
@property (nonatomic, strong) UILabel *airplaneLabel;
@property (nonatomic, assign) BOOL isShowingAirplane;
@property (nonatomic, strong) UIView *bluetoothView;
@property (nonatomic, strong) UILabel *bluetoothLabel;
@property (nonatomic, assign) BOOL isShowingBluetooth;
@property (nonatomic, strong) UIView *wifiView;
@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, assign) BOOL isShowingWifi;
@property (nonatomic, strong) UIView *hotspotView;
@property (nonatomic, strong) UILabel *hotspotLabel;
@property (nonatomic, assign) BOOL isShowingHotspot;
@property (nonatomic, strong) UIView *airplayView;
@property (nonatomic, strong) UILabel *airplayLabel;
@property (nonatomic, assign) BOOL isShowingAirplay;
@property (nonatomic, strong) UIView *screenRecordView;
@property (nonatomic, strong) UILabel *screenRecordLabel;
@property (nonatomic, assign) BOOL isShowingScreenRecord;
@property (nonatomic, strong) UIView *screenRecordIndicator;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) UIView *faceIDView;
@property (nonatomic, strong) UILabel *faceIDLabel;
@property (nonatomic, assign) BOOL isShowingFaceID;
@property (nonatomic, strong) UIView *lowBatteryView;
@property (nonatomic, strong) UILabel *lowBatteryLabel;
@property (nonatomic, assign) BOOL isShowingLowBattery;
@end

@implementation HDangDynamicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDynamicIsland];
    }
    return self;
}

- (void)initializeDynamicIsland {
    // Khởi tạo các thuộc tính
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = YES;
    self.originalWidth = self.frame.size.width;
    self.originalHeight = self.frame.size.height;
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.isExpanded = NO;
    self.isShowingMusic = NO;
    self.isShowingCall = NO;
    self.isShowingTimer = NO;
    self.isShowingBattery = NO;
    self.isShowingNotification = NO;
    self.isShowingVolume = NO;
    self.isShowingCharging = NO;
    self.isShowingAirplane = NO;
    self.isShowingBluetooth = NO;
    self.isShowingWifi = NO;
    self.isShowingHotspot = NO;
    self.isShowingAirplay = NO;
    self.isShowingScreenRecord = NO;
    self.isShowingFaceID = NO;
    self.isShowingLowBattery = NO;
    self.isRecording = NO;
    self.isDragging = NO;
    self.notificationQueue = [[NSMutableArray alloc] init];
    
    // Tạo camera dot
    [self createCameraDot];
    
    // Tạo sensor dot
    [self createSensorDot];
    
    // Thêm gestures
    [self addGestures];
    
    // Bắt đầu update timer
    [self startUpdateTimer];
    
    // Đăng ký notifications
    [self registerForNotifications];
    
    // Hiện battery ban đầu
    [self showBatteryStatus];
}

- (void)createCameraDot {
    self.cameraDot = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 22, self.frame.size.height/2 - 6, 12, 12)];
    self.cameraDot.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    self.cameraDot.layer.cornerRadius = 6;
    self.cameraDot.layer.borderWidth = 1;
    self.cameraDot.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor;
    [self addSubview:self.cameraDot];
    
    // Thêm lens reflection
    UIView *lensReflection = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 3, 3)];
    lensReflection.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.5 alpha:0.8];
    lensReflection.layer.cornerRadius = 1.5;
    [self.cameraDot addSubview:lensReflection];
}

- (void)createSensorDot {
    self.sensorDot = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2 - 4, 8, 8)];
    self.sensorDot.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    self.sensorDot.layer.cornerRadius = 4;
    self.sensorDot.alpha = 0.5;
    [self addSubview:self.sensorDot];
}

- (void)addGestures {
    // Tap gesture
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tapGesture];
    
    // Double tap gesture
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [self.tapGesture requireGestureRecognizerToFail:doubleTap];
    
    // Long press gesture
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPressGesture.minimumPressDuration = 0.5;
    [self addGestureRecognizer:self.longPressGesture];
    
    // Pan gesture
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];
}

- (void)startUpdateTimer {
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(updateDynamicIsland)
                                                      userInfo:nil
                                                       repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
}

- (void)updateDynamicIsland {
    // Cập nhật thời gian
    [self updateTimeDisplay];
    
    // Cập nhật battery
    [self updateBatteryStatus];
    
    // Cập nhật trạng thái hệ thống
    [self updateSystemStatus];
}

- (void)updateTimeDisplay {
    if (self.timeLabel) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeString = [formatter stringFromDate:[NSDate date]];
        self.timeLabel.text = timeString;
    }
}

- (void)updateBatteryStatus {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    UIDeviceBatteryState batteryState = [UIDevice currentDevice].batteryState;
    
    if (batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull) {
        [self showChargingStatus:batteryLevel];
    } else if (batteryLevel <= 0.2) {
        [self showLowBatteryStatus:batteryLevel];
    }
}

- (void)updateSystemStatus {
    // Kiểm tra airplane mode
    BOOL isAirplaneMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"SBAirplaneMode"];
    if (isAirplaneMode && !self.isShowingAirplane) {
        [self showAirplaneStatus];
    } else if (!isAirplaneMode && self.isShowingAirplane) {
        [self hideAirplaneStatus];
    }
    
    // Kiểm tra bluetooth
    BOOL isBluetoothEnabled = [self isBluetoothEnabled];
    if (isBluetoothEnabled && !self.isShowingBluetooth) {
        [self showBluetoothStatus];
    } else if (!isBluetoothEnabled && self.isShowingBluetooth) {
        [self hideBluetoothStatus];
    }
    
    // Kiểm tra wifi
    BOOL isWifiEnabled = [self isWifiEnabled];
    if (isWifiEnabled && !self.isShowingWifi) {
        [self showWifiStatus];
    } else if (!isWifiEnabled && self.isShowingWifi) {
        [self hideWifiStatus];
    }
}

- (BOOL)isBluetoothEnabled {
    // Kiểm tra bluetooth status
    return NO;
}

- (BOOL)isWifiEnabled {
    // Kiểm tra wifi status
    return NO;
}

- (void)showBatteryStatus {
    if (self.isShowingBattery) return;
    self.isShowingBattery = YES;
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    
    if (self.isExpanded) {
        [self collapse];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 20,
                                self.frame.origin.y,
                                self.originalWidth + 40,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        // Hiện thông tin battery
        [self showBatteryInfo:batteryLevel];
        
        // Tự động thu nhỏ sau 2 giây
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self collapse];
            self.isShowingBattery = NO;
        });
    }];
}

- (void)showBatteryInfo:(CGFloat)level {
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height/2 - 12, 24, 24)];
    self.iconView.image = [UIImage systemImageNamed:@"battery.100"];
    self.iconView.tintColor = [UIColor greenColor];
    [self addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 60, 20)];
    self.titleLabel.text = [NSString stringWithFormat:@"%.0f%%", level * 100];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 22, 80, 12)];
    self.subtitleLabel.text = @"Battery";
    self.subtitleLabel.font = [UIFont systemFontOfSize:10];
    self.subtitleLabel.textColor = [UIColor grayColor];
    [self addSubview:self.subtitleLabel];
}

- (void)showChargingStatus:(CGFloat)level {
    if (self.isShowingCharging) return;
    self.isShowingCharging = YES;
    
    if (self.isExpanded) {
        [self collapse];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 30,
                                self.frame.origin.y,
                                self.originalWidth + 60,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        self.chargingView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        
        UIImageView *chargingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 12, 24, 24)];
        chargingIcon.image = [UIImage systemImageNamed:@"bolt.fill"];
        chargingIcon.tintColor = [UIColor yellowColor];
        [self.chargingView addSubview:chargingIcon];
        
        UILabel *chargingLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 80, 20)];
        chargingLabel.text = [NSString stringWithFormat:@"%.0f%%", level * 100];
        chargingLabel.font = [UIFont boldSystemFontOfSize:14];
        chargingLabel.textColor = [UIColor whiteColor];
        [self.chargingView addSubview:chargingLabel];
        
        UILabel *chargingStatus = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 60, 12)];
        chargingStatus.text = @"Charging";
        chargingStatus.font = [UIFont systemFontOfSize:10];
        chargingStatus.textColor = [UIColor grayColor];
        [self.chargingView addSubview:chargingStatus];
        
        [self addSubview:self.chargingView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chargingView removeFromSuperview];
            self.chargingView = nil;
            [self collapse];
            self.isShowingCharging = NO;
        });
    }];
}

- (void)showLowBatteryStatus:(CGFloat)level {
    if (self.isShowingLowBattery) return;
    self.isShowingLowBattery = YES;
    
    if (self.isExpanded) {
        [self collapse];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 30,
                                self.frame.origin.y,
                                self.originalWidth + 60,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        self.lowBatteryView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        
        UIImageView *lowBatteryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 12, 24, 24)];
        lowBatteryIcon.image = [UIImage systemImageNamed:@"battery.25"];
        lowBatteryIcon.tintColor = [UIColor redColor];
        [self.lowBatteryView addSubview:lowBatteryIcon];
        
        UILabel *lowBatteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 80, 20)];
        lowBatteryLabel.text = [NSString stringWithFormat:@"%.0f%%", level * 100];
        lowBatteryLabel.font = [UIFont boldSystemFontOfSize:14];
        lowBatteryLabel.textColor = [UIColor whiteColor];
        [self.lowBatteryView addSubview:lowBatteryLabel];
        
        UILabel *lowBatteryStatus = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 80, 12)];
        lowBatteryStatus.text = @"Low Battery";
        lowBatteryStatus.font = [UIFont systemFontOfSize:10];
        lowBatteryStatus.textColor = [UIColor redColor];
        [self.lowBatteryView addSubview:lowBatteryStatus];
        
        [self addSubview:self.lowBatteryView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.lowBatteryView removeFromSuperview];
            self.lowBatteryView = nil;
            [self collapse];
            self.isShowingLowBattery = NO;
        });
    }];
}

- (void)showAirplaneStatus {
    if (self.isShowingAirplane) return;
    self.isShowingAirplane = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 20,
                                self.frame.origin.y,
                                self.originalWidth + 40,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        self.airplaneView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        
        UIImageView *airplaneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 12, 24, 24)];
        airplaneIcon.image = [UIImage systemImageNamed:@"airplane"];
        airplaneIcon.tintColor = [UIColor orangeColor];
        [self.airplaneView addSubview:airplaneIcon];
        
        UILabel *airplaneLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, self.frame.size.height/2 - 10, 80, 20)];
        airplaneLabel.text = @"Airplane";
        airplaneLabel.font = [UIFont boldSystemFontOfSize:12];
        airplaneLabel.textColor = [UIColor whiteColor];
        [self.airplaneView addSubview:airplaneLabel];
        
        [self addSubview:self.airplaneView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.airplaneView removeFromSuperview];
            self.airplaneView = nil;
            [self collapse];
            self.isShowingAirplane = NO;
        });
    }];
}

- (void)hideAirplaneStatus {
    [self.airplaneView removeFromSuperview];
    self.airplaneView = nil;
    self.isShowingAirplane = NO;
    [self collapse];
}

- (void)showBluetoothStatus {
    if (self.isShowingBluetooth) return;
    self.isShowingBluetooth = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 20,
                                self.frame.origin.y,
                                self.originalWidth + 40,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        self.bluetoothView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        
        UIImageView *bluetoothIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 12, 24, 24)];
        bluetoothIcon.image = [UIImage systemImageNamed:@"bluetooth"];
        bluetoothIcon.tintColor = [UIColor blueColor];
        [self.bluetoothView addSubview:bluetoothIcon];
        
        UILabel *bluetoothLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, self.frame.size.height/2 - 10, 80, 20)];
        bluetoothLabel.text = @"Bluetooth";
        bluetoothLabel.font = [UIFont boldSystemFontOfSize:12];
        bluetoothLabel.textColor = [UIColor whiteColor];
        [self.bluetoothView addSubview:bluetoothLabel];
        
        [self addSubview:self.bluetoothView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.bluetoothView removeFromSuperview];
            self.bluetoothView = nil;
            [self collapse];
            self.isShowingBluetooth = NO;
        });
    }];
}

- (void)hideBluetoothStatus {
    [self.bluetoothView removeFromSuperview];
    self.bluetoothView = nil;
    self.isShowingBluetooth = NO;
    [self collapse];
}

- (void)showWifiStatus {
    if (self.isShowingWifi) return;
    self.isShowingWifi = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 20,
                                self.frame.origin.y,
                                self.originalWidth + 40,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        self.wifiView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        
        UIImageView *wifiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2 - 12, 24, 24)];
        wifiIcon.image = [UIImage systemImageNamed:@"wifi"];
        wifiIcon.tintColor = [UIColor blueColor];
        [self.wifiView addSubview:wifiIcon];
        
        UILabel *wifiLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, self.frame.size.height/2 - 10, 60, 20)];
        wifiLabel.text = @"WiFi";
        wifiLabel.font = [UIFont boldSystemFontOfSize:12];
        wifiLabel.textColor = [UIColor whiteColor];
        [self.wifiView addSubview:wifiLabel];
        
        [self addSubview:self.wifiView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.wifiView removeFromSuperview];
            self.wifiView = nil;
            [self collapse];
            self.isShowingWifi = NO;
        });
    }];
}

- (void)hideWifiStatus {
    [self.wifiView removeFromSuperview];
    self.wifiView = nil;
    self.isShowingWifi = NO;
    [self collapse];
}

- (void)expand {
    if (self.isExpanded) return;
    self.isExpanded = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 60,
                                self.frame.origin.y - 10,
                                self.originalWidth + 120,
                                self.originalHeight + 20);
        self.layer.cornerRadius = self.frame.size.height / 2;
        
        // Ẩn camera dot và sensor dot
        self.cameraDot.alpha = 0;
        self.sensorDot.alpha = 0;
    } completion:nil];
}

- (void)collapse {
    if (!self.isExpanded) return;
    self.isExpanded = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.frame = CGRectMake(self.screenWidth/2 - self.originalWidth/2,
                                10,
                                self.originalWidth,
                                self.originalHeight);
        self.layer.cornerRadius = self.originalHeight / 2;
        
        // Hiện camera dot và sensor dot
        self.cameraDot.alpha = 1;
        self.sensorDot.alpha = 0.5;
        
        // Xóa các subview tạm thời
        [self clearTemporaryViews];
    } completion:nil];
}

- (void)clearTemporaryViews {
    [self.titleLabel removeFromSuperview];
    [self.subtitleLabel removeFromSuperview];
    [self.iconView removeFromSuperview];
    [self.albumArtView removeFromSuperview];
    [self.progressView removeFromSuperview];
    self.titleLabel = nil;
    self.subtitleLabel = nil;
    self.iconView = nil;
    self.albumArtView = nil;
    self.progressView = nil;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (self.isExpanded) {
        [self collapse];
    } else {
        [self expand];
        [self performHapticFeedback];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    // Double tap để mở rộng tối đa
    [self expandToFullScreen];
    [self performHapticFeedback];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self expand];
        [self performHapticFeedback];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.originalCenter = self.center;
            self.isDragging = YES;
            break;
            
        case UIGestureRecognizerStateChanged:
            if (self.isDragging) {
                CGPoint newCenter = CGPointMake(self.originalCenter.x + translation.x,
                                                self.originalCenter.y + translation.y);
                self.center = newCenter;
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            self.isDragging = NO;
            // Snap back to original position
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(self.screenWidth/2 - self.originalWidth/2,
                                        10,
                                        self.originalWidth,
                                        self.originalHeight);
            }];
            break;
            
        default:
            break;
    }
}

- (void)expandToFullScreen {
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.frame = CGRectMake(20,
                                50,
                                self.screenWidth - 40,
                                200);
        self.layer.cornerRadius = 30;
    } completion:nil];
}

- (void)performHapticFeedback {
    AudioServicesPlaySystemSound(1519);
}

- (void)showMusicControls:(MPMediaItem *)song {
    if (self.isShowingMusic) return;
    self.isShowingMusic = YES;
    
    [self expand];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 40,
                                self.frame.origin.y - 20,
                                self.originalWidth + 80,
                                self.originalHeight + 40);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        // Album art
        self.albumArtView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.albumArtView.layer.cornerRadius = 20;
        self.albumArtView.layer.masksToBounds = YES;
        self.albumArtView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.albumArtView];
        
        // Song title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, self.frame.size.width - 70, 20)];
        self.titleLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        // Artist
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, self.frame.size.width - 70, 15)];
        self.subtitleLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
        self.subtitleLabel.font = [UIFont systemFontOfSize:11];
        self.subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.subtitleLabel];
        
        // Progress bar
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(60, 50, self.frame.size.width - 70, 2)];
        self.progressView.progressTintColor = [UIColor whiteColor];
        self.progressView.trackTintColor = [UIColor grayColor];
        [self addSubview:self.progressView];
        
        // Auto collapse after 5 seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self collapse];
            self.isShowingMusic = NO;
        });
    }];
}

- (void)showCallNotification:(NSString *)callerName {
    if (self.isShowingCall) return;
    self.isShowingCall = YES;
    
    [self expand];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 50,
                                self.frame.origin.y,
                                self.originalWidth + 100,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        // Call icon
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height/2 - 12, 24, 24)];
        self.iconView.image = [UIImage systemImageNamed:@"phone.fill"];
        self.iconView.tintColor = [UIColor greenColor];
        [self addSubview:self.iconView];
        
        // Caller name
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, self.frame.size.width - 60, 20)];
        self.titleLabel.text = callerName;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        // Call status
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 22, self.frame.size.width - 60, 12)];
        self.subtitleLabel.text = @"Incoming Call";
        self.subtitleLabel.font = [UIFont systemFontOfSize:10];
        self.subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.subtitleLabel];
    }];
}

- (void)showTimer:(NSTimeInterval)remainingTime {
    if (self.isShowingTimer) return;
    self.isShowingTimer = YES;
    
    [self expand];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - 30,
                                self.frame.origin.y,
                                self.originalWidth + 60,
                                self.originalHeight);
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        // Timer icon
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height/2 - 12, 24, 24)];
        self.iconView.image = [UIImage systemImageNamed:@"timer"];
        self.iconView.tintColor = [UIColor orangeColor];
        [self addSubview:self.iconView];
        
        // Time remaining
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, self.frame.size.width - 60, 20)];
        self.titleLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)remainingTime / 60, (int)remainingTime % 60];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        // Timer label
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 22, self.frame.size.width - 60, 12)];
        self.subtitleLabel.text = @"Timer";
        self.subtitleLabel.font = [UIFont systemFontOfSize:10];
        self.subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.subtitleLabel];
    }];
}

- (void)registerForNotifications {
    // Music notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMusicNotification:)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMusicNotification:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:nil];
    
    // Call notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCallNotification:)
                                                 name:@"SBApplicationStateChangedNotification"
                                               object:nil];
    
    // Battery notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBatteryNotification:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBatteryNotification:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
    
    // Volume notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleVolumeNotification:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    
    // Screen recording notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleScreenRecordingNotification:)
                                                 name:UIScreenCapturedDidChangeNotification
                                               object:nil];
    
    // Face ID notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFaceIDNotification:)
                                                 name:@"SBFaceIDStatusChangedNotification"
                                               object:nil];
}
