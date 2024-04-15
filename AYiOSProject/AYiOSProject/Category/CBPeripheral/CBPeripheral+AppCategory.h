//   
//   CBPeripheral+AppCategory.h
//
//   Created by alpha yu on 2023/6/25 
//   
   

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (AppCategory)

@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;///< 写特征
@property (nonatomic, strong) NSDictionary *advertisementData;      ///< 广告数据，字段参见 CBAdvertisementData.h
@property (nonatomic, copy, readonly) NSString *stateString;        ///< 连接状态文本

@end

NS_ASSUME_NONNULL_END
