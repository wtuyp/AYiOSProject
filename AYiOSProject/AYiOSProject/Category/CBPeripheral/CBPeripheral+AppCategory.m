//   
//   CBPeripheral+AppCategory.m
//
//   Created by alpha yu on 2024/1/16
//
   

#import "CBPeripheral+AppCategory.h"
#import "MMMLab.h"

@implementation CBPeripheral (AppCategory)

MMMSynthesizeIdStrongProperty(writeCharacteristic, setWriteCharacteristic)
MMMSynthesizeIdStrongProperty(advertisementData, setAdvertisementData)

- (NSString *)stateString {
    if (self.state == CBPeripheralStateConnected) {
        return @"已连接";
    } else if (self.state == CBPeripheralStateConnecting) {
        return @"连接中";
    } else if (self.state == CBPeripheralStateDisconnecting) {
        return @"断开中";
    }
    
    return @"未连接";
}
@end
