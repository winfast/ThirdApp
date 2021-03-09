//
//  GHBLEClient.m
//  GHome
//
//  Created by Qincc on 2021/2/25.
//

#import "GHBLEClient.h"

#define Discover_ServiceUUID  		@"3A4F1680-4355-432E-444E-55534F474449"
#define DeviceID_CharacteristicUUID @"3A4F1681-4355-432E-444E-55534F474449"

@interface GHBLEClient ()<CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralDelegate>
// 中心管理者(管理设备的扫描和连接)
@property (nonatomic, strong) CBCentralManager *centralManager;
///已经连接上的设备
@property (nonatomic, strong) CBPeripheral *connectedPeripheral;
// 扫描的设备
@property (nonatomic, strong) NSMutableArray *peripheralsArray;
// 外设状态
@property (nonatomic, assign) CBManagerState peripheralState;
//app给ble写数据锁
@property(strong, nonatomic)NSCondition * writeCondition;
//app给设备发送数据的特征值
@property (nonatomic, strong) CBCharacteristic  *deviceID_Characteristic;

//@property (nonatomic, strong) CBUUID 			*notifyUUID;
//@property (nonatomic, strong) CBCharacteristic  *notifyChar;
/// 读写队列
//@property(strong, nonatomic)NSOperationQueue *requestQueue;
//@property(strong, nonatomic)NSOperationQueue *callbackQueue;

@end

@implementation GHBLEClient

#pragma mark 单例初始化
/// 单例构造方法
+ (instancetype)share {
	static GHBLEClient *share = nil;
	static dispatch_once_t oneToken;
	dispatch_once(&oneToken, ^{
		share = [[GHBLEClient alloc] init];
	});
	return share;
}

- (instancetype)init {
	if (self = [super init]) {
//		self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//		dispatch_queue_t queue = dispatch_queue_create("bluetooth", DISPATCH_QUEUE_SERIAL);
		self.centralManager= [[CBCentralManager alloc] initWithDelegate:self queue:nil];
	}
	return self;
}
#pragma mark CBCentralManagerDelegate
// 状态更新时调用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	switch (central.state) {
		case CBManagerStateUnknown:{
			NSLog(@"未知状态");
			self.peripheralState = central.state;
		}
			break;
		case CBManagerStateResetting:
		{
			NSLog(@"重置状态");
			self.peripheralState = central.state;
		}
			break;
		case CBManagerStateUnsupported:
		{
			NSLog(@"不支持的状态");
			self.peripheralState = central.state;
		}
			break;
		case CBManagerStateUnauthorized:
		{
			NSLog(@"未授权的状态");
			self.peripheralState = central.state;
		}
			break;
		case CBManagerStatePoweredOff:
		{
			NSLog(@"关闭状态");
			self.peripheralState = central.state;
		}
			break;
		case CBManagerStatePoweredOn:
		{
			NSLog(@"开启状态－可用状态");
			self.peripheralState = central.state;
//			NSLog(@"%ld",(long)self.peripheralState);
//			CBUUID* cbUUID = nil;
//			cbUUID = [CBUUID UUIDWithString:Discover_ServiceUUID];
//			[self.centralManager scanForPeripheralsWithServices:@[cbUUID] options:nil];
		}
			break;
		default:
			break;
	}
}
#pragma mark 开始扫描设备
/// 开始扫描
- (void)startScanBlutooth{
	if (self.peripheralsArray.count != 0) {
		[self.peripheralsArray removeAllObjects];
	}
	CBUUID* cbUUID = nil;
	cbUUID = [CBUUID UUIDWithString:Discover_ServiceUUID];
//	[self.centralManager scanForPeripheralsWithServices:@[cbUUID]  options:nil];
	[self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark 停止扫描
///  停止扫描
- (void)stopScan {
	if ([self.centralManager isScanning]) {
		[self.centralManager stopScan];
	}
}

#pragma mark 连接设备
//连接设备
- (void)connectPeripheral:(CBPeripheral *)peripheral {
	[self.centralManager stopScan];
	if ([self.connectedPeripheral isEqual: peripheral] || !peripheral) {
		return;
	}
	if (_connectedPeripheral.state == CBPeripheralStateConnected) {

		[self.centralManager cancelPeripheralConnection:_connectedPeripheral];
	}
	if (peripheral.state==CBPeripheralStateConnected) {
		[self.centralManager cancelPeripheralConnection:peripheral];
	}
	[self.centralManager connectPeripheral:peripheral options:nil];
}

#pragma mark 断开连接
//断开连接
- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
	if (peripheral.state == CBPeripheralStateConnected) {
		[self.centralManager cancelPeripheralConnection:peripheral];
	}
}

#pragma mark - CBCentralManagerDelegate
/**
 扫描到设备
 @param central 中心管理者
 @param peripheral 扫描到的设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
	
	NSLog(@"\n peripheral is :\n%@\n advertisementData is :\n%@\n RSSI is :%d",peripheral,advertisementData,[RSSI intValue]);
	if (![peripheral.name containsString:@"cuco-00:00:00"]) {
		return;
	}
	if (![self.peripheralsArray containsObject:peripheral] && RSSI.intValue >= -60) {
		[self.peripheralsArray addObject:peripheral];
		if ([_delegate respondsToSelector:@selector(didDiscoverPeripheral:)]) {
			[_delegate didDiscoverPeripheral:self.peripheralsArray];
		}
	}
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	NSLog(@"连接外设成功！%@",peripheral.name);
	self.connectedPeripheral = peripheral;
	[peripheral setDelegate:self];
	[peripheral discoverServices:nil];
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	NSLog(@"连接到外设 失败！%@ %@",[peripheral name],[error localizedDescription]);
	self.connectedPeripheral = nil;
	if ([self.delegate respondsToSelector:@selector(centralManager:didFailToConnectPeripheral:error:)])
	{
		[self.delegate centralManager:central didFailToConnectPeripheral:peripheral error:error];
	}
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
	NSLog(@"断开蓝牙%@ error:%@",peripheral.name,error);
	self.connectedPeripheral = nil;
}

#pragma mark - CBPeripheralDelegate
//扫描到服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
	if (error) {
		NSLog(@"扫描外设服务出错：%@-> %@", peripheral.name, [error localizedDescription]);
		return;
	}
	
	NSLog(@"扫描到外设服务：%@ -> %@",peripheral.name,peripheral.services);
	for (CBService *service in peripheral.services) {
		[peripheral discoverCharacteristics:nil forService:service]; //订阅服务下面所有的特征
	}
	if ([_delegate respondsToSelector:@selector(didConnectPeripheral:)]) {
		[_delegate didConnectPeripheral:peripheral];
	}
}

//扫描到特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
	if (error) {
		NSLog(@"扫描外设的特征失败！%@->%@-> %@",peripheral.name,service.UUID, [error localizedDescription]);
		return;
	}
	NSLog(@"扫描到外设服务特征有：%@->%@->%@",peripheral.name,service.UUID,service.characteristics);
	//获取Characteristic的值
	for (CBCharacteristic *characteristic in service.characteristics){
		//这里外设需要订阅特征的通知，否则无法收到外设发送过来的数据
		[peripheral setNotifyValue:YES forCharacteristic:characteristic];
		if ([characteristic.UUID.UUIDString isEqualToString:DeviceID_CharacteristicUUID])
		{
			self.deviceID_Characteristic = characteristic;
		}
	}
}

//扫描到具体的值->通讯主要的获取数据的方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
	if (error) {
		NSLog(@"扫描外设的特征失败！%@-> %@",peripheral.name, [error localizedDescription]);
		return;
	}
	NSLog(@"didUpdateValueForCharacteristic===%@ %@",characteristic.UUID.UUIDString,characteristic.value);
	if ([characteristic.UUID.UUIDString isEqualToString:DeviceID_CharacteristicUUID]) {
		NSData *data = characteristic.value;
		if ([_delegate respondsToSelector:@selector(peripheral:didUpdateValueForCharacteristicOfDeviceID:)]) {
			[_delegate peripheral:peripheral didUpdateValueForCharacteristicOfDeviceID:data];
		}
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	NSLog(@"发送数据成功");
	[_writeCondition lock];
	[_writeCondition signal];
	[_writeCondition unlock];
//	[peripheral readValueForCharacteristic:characteristic];
	if (_delegate && [_delegate respondsToSelector:@selector(peripheral:didWriteValueForCharacteristic:error:)]) {
		[_delegate peripheral:peripheral didWriteValueForCharacteristic:characteristic];
	}
}

#pragma mark public method
//发送配网配置信息
-(void)sendConfigdataToPeripheral:(CBPeripheral *)peripheral withData:(NSData *)data{
	if (self.deviceID_Characteristic) {
		[self gattWrite:data withCharacteristic:self.deviceID_Characteristic];
	}
}

#pragma mark private method
- (void)gattWrite:(NSData *)data withCharacteristic:(CBCharacteristic *)characteristic {
	[_writeCondition lock];
	if (!self.connectedPeripheral) {
		[_writeCondition unlock];
		return;
	}
	[self.connectedPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
	[_writeCondition wait];
	[_writeCondition unlock];
	return;
}

#pragma mark lazy load
-(NSMutableArray*)peripheralsArray{
	if (!_peripheralsArray) {
		_peripheralsArray = [[NSMutableArray alloc] init];
	}
	return _peripheralsArray;
}


@end
