# MobileID iOS SDK — Binary Distribution

SDK xác thực số điện thoại di động cho iOS.

Yêu cầu: iOS 13.0+, Swift 5.

Bản phân phối có **2 flavor**, cùng module `MobileIdSdk` (`import MobileIdSdk` /
`@import MobileIdSdk` không đổi giữa 2 bản — chọn **đúng 1** bản, không cài song song):

| Flavor | Pod | Link | Đối tác phải làm ở Xcode |
|---|---|---|---|
| **Dynamic** | `MobileIdSdk` | dynamic framework | Embed & Sign (CocoaPods lo tự động) |
| **Static** | `MobileIdSdk-Static` | link thẳng vào app | Không embed, không `use_frameworks!` |

Bản **static** gọn hơn khi tích hợp: không cần Embed & Sign, không bắt `use_frameworks!`.
Đánh đổi: khi kéo thủ công phải tự thêm privacy manifest (xem mục Static + thủ công).

---

## 1. Dynamic + CocoaPods

```ruby
platform :ios, '13.0'

target 'MyApp' do
  use_frameworks!
  pod 'MobileIdSdk', :git => 'https://github.com/WiinventDevTeam/mobileid-ios-sdk.git', :tag => '1.0.2'
end
```

```bash
pod install
```

## 2. Static + CocoaPods (khuyến nghị cho tích hợp gọn)

Không cần `use_frameworks!`. Privacy manifest tự đi kèm qua resource bundle.

```ruby
platform :ios, '13.0'

target 'MyApp' do
  pod 'MobileIdSdk-Static', :git => 'https://github.com/WiinventDevTeam/mobileid-ios-sdk.git', :tag => '1.0.2'
end
```

```bash
pod install
```

## 3. Dynamic + kéo thủ công (không dùng CocoaPods)

1. Kéo `MobileIdSdk.xcframework` vào project.
2. Target → General → **Frameworks, Libraries & Embedded Content** → chọn **Embed & Sign**.

Privacy manifest nằm sẵn trong framework bundle, tự đi theo khi embed.

## 4. Static + kéo thủ công

1. Kéo `static/MobileIdSdk.xcframework` vào project.
2. Target → General → **Frameworks, Libraries & Embedded Content** → chọn **Do Not Embed**
   (static link thẳng vào app, không embed).
3. **Bắt buộc**: kéo `PrivacyInfo.xcprivacy` (kèm trong bản phân phối) vào
   **Build Phases → Copy Bundle Resources** của app target.

> **Quan trọng**: bước 3 không được bỏ. Privacy manifest nằm trong static framework
> **không** được Apple gom vào App Privacy Report — phải copy thẳng vào app bundle,
> nếu không App Store review có thể cảnh báo thiếu privacy manifest.

---

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
