//
//  GHBLEClient.h
//  GHome
//
//  Created by Qincc on 2021/2/25.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN


@protocol GHBLEClientDelegate <NSObject>
 
@optional
/**检测手机蓝牙状态*/
- (void)discoverManagerDidUpdateState:(CBCentralManager *_Nonnull)central;
/**发现蓝牙设备*/
- (void)didDiscoverPeripheral:(NSMutableArray<CBPeripheral *>*)peripherals;
/**连接上蓝牙设备成功*/
- (void)didConnectPeripheral:(CBPeripheral *_Nonnull)peripheral;
/**连接蓝牙设备失败*/
- (void)centralManager:(CBCentralManager * __nonnull)central didFailToConnectPeripheral:(CBPeripheral * __nonnull)peripheral error:(nullable NSError *)error;
/**断开连接蓝牙设备*/
- (void)didDisConnectPeripheral:(CBPeripheral *_Nonnull)peripheral;
//数据发送成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic;


/**
 *@abstract 当获取到设备deviceID时
 *@param peripheral 外设。
 *@param value 特征值
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristicOfDeviceID:(NSData *)value;



@end

@interface GHBLEClient : NSObject

@property (nonatomic, weak) id<GHBLEClientDelegate> delegate;

@property (nonatomic, assign, readonly) CBManagerState peripheralState;
/// 连接上的蓝牙
@property (nonatomic, strong, readonly) CBPeripheral *connectedPeripheral;

- (instancetype)init NS_UNAVAILABLE;

/// 单例构造方法
+ (instancetype)share;

/// 开始扫描
- (void)startScanBlutooth;
///  停止扫描
- (void)stopScan;
//连接设备
- (void)connectPeripheral:(CBPeripheral *)peripheral;

//断开连接
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;


-(void)sendConfigdataToPeripheral:(CBPeripheral *)peripheral withData:(NSData *)data;
/// 扫描到设备后的回调
//@property (nonatomic, copy) void (^scanBLEDeviceBlock)(CBPeripheral* peripheral);
//
///// 停止扫描的回调
//@property (nonatomic, copy) void (^stopScanDevice)(void);
//
///// 蓝牙连接成功的回调
//@property (nonatomic, copy) void (^connectSuccessBLEPeripheral)(CBPeripheral *peripheral);
//
///// 蓝牙连接失败的回调
//@property (nonatomic, copy) void (^connectFailBLEPeripheral)(CBPeripheral *peripheral);
//
///// 蓝牙连接断开的回调
//@property (nonatomic, copy) void (^disConnectBLEPeripheral)(CBPeripheral *peripheral);
//
/////  获取到外设的数据
//@property (nonatomic, copy) void (^peripheralUpdateData)(CBPeripheral *peripheral, CBCharacteristic * characteristic, NSData *data);

@end

NS_ASSUME_NONNULL_END
