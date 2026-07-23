# Changelog

## [1.0.2] - 2026-07-23

### Added
- Thêm bản phân phối **static** qua `MobileIdSdk-Static.podspec`, cùng module
  `MobileIdSdk` nên code tích hợp vẫn dùng `import MobileIdSdk` / `@import MobileIdSdk`.
- Thêm `static/MobileIdSdk.xcframework` để đối tác link SDK mà không cần Embed & Sign
  hoặc `use_frameworks!`.
- Ship `PrivacyInfo.xcprivacy` standalone để bản static được copy vào app bundle qua
  `MobileIdSdk_Privacy.bundle` và được Apple Privacy Report gom đúng.

### Changed
- Cập nhật README và Example-Podfile với cả 2 hướng tích hợp dynamic/static.

## [1.0.1] - 2026-07-14

### Added
- **Tương thích Objective-C**: toàn bộ API public giờ gọi được từ Objective-C
  (`@import MobileIdSdk;` hoặc `#import <MobileIdSdk/MobileIdSdk-Swift.h>`).
  - `MobileID`, `MobileIdError` là `@objc` class (kế thừa `NSObject`).
  - `MobileIdEnvironment`, `MobileIdErrorCode` là `@objc enum : Int` (NS_ENUM).
- `MobileIdError.code` / `MobileIdErrorCode.code`: mã lỗi dạng **string ổn định**
  (khớp Android/Dart), dùng thay cho integer raw value.

## [1.0.0] - 2026-07-07

- Bản phát hành binary đầu tiên: xác thực qua mạng di động (cellular) + coverage check,
  cấu hình runtime qua `configure(configUrl:)`, phân phối qua CocoaPods (git + tag).
