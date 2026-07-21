# MobileID iOS SDK — Binary Distribution

SDK xác thực số điện thoại di động cho iOS

Yêu cầu: iOS 13.0+, Swift 5, CocoaPods.

## Cài đặt (CocoaPods)

1. Trong `Podfile`, thêm pod trỏ tới Git repo bằng tag phiên bản:

   ```ruby
   platform :ios, '13.0'

   target 'MyApp' do
     use_frameworks!
     pod 'MobileIdSdk', :git => 'https://github.com/WiinventDevTeam/mobileid-ios-sdk.git', :tag => '1.0.1'
   end
   ```

2. Cài đặt:

   ```bash
   pod install
   ```

## Sử dụng nhanh (Swift)

```swift
import MobileIdSdk

let sdk = MobileID()

// 1. Resolve cấu hình từ backend.
sdk.configure(configUrl: "https://your-backend.com/api/sdk-config", success: {

    // 2. Kiểm tra coverage rồi xác thực.
    sdk.checkCoverageWithPhoneNumber("84901234567", success: { _ in
        sdk.doAuthentication(loginHint: "84901234567", success: { response in
            // Gửi authorization code trong `response` về backend để đổi token.
        }, fail: { error in
            print(error.errorMessage ?? "")
        })
    }, fail: { error in
        print(error.errorMessage ?? "")
    })

}, fail: { error in
    // Lỗi resolve cấu hình (mạng, backend từ chối, app không được phép…).
    print(error.errorMessage ?? "")
})
```

## Sử dụng nhanh (Objective-C)

```objc
@import MobileIdSdk;

MobileID *sdk = [[MobileID alloc] init];
[sdk configureWithConfigUrl:@"https://your-backend.com/api/sdk-config"
                    headers:nil
                    success:^{
    [sdk checkCoverageWithPhoneNumber:@"84901234567"
                              success:^(NSString * _Nonnull response) {
        [sdk doAuthenticationWithLoginHint:@"84901234567"
                                   success:^(NSString * _Nullable authResponse) {
            // Gửi authorization code về backend để đổi token.
        } fail:^(MobileIdError * _Nonnull error) {
            NSLog(@"%@", error.errorMessage);
        }];
    } fail:^(MobileIdError * _Nonnull error) {
        NSLog(@"%@", error.errorMessage);
    }];
} fail:^(MobileIdError * _Nonnull error) {
    NSLog(@"config: %@", error.errorMessage);
}];
```

`configure` nhận thêm tham số `headers` (tùy chọn) nếu backend của bạn yêu cầu header
auth riêng (vd `Authorization`). SDK không quy định cơ chế auth. Bên ObjC truyền `nil`
khi không cần.

### Xử lý lỗi

`MobileIdError` gồm `errorCode` (enum), `code` (string ổn định, khớp Android/Dart) và
`errorMessage`. Nên xử lý theo `code` / `errorCode`, **không** theo integer raw value.

> **Lưu ý**: xác thực qua mạng di động cần thiết bị thật kết nối **cellular data** —
> không chạy được trên Wifi hoặc emulator.
