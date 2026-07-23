Pod::Spec.new do |s|
  s.name             = "MobileIdSdk"
  s.version          = "1.0.2"
  s.summary          = "MobileID SDK for iOS"
  s.description      = "MobileID mobile authentication SDK for iOS (binary distribution)."
  s.homepage         = "https://mobileid.vn"
  s.license          = { :type => "Commercial", :file => "LICENSE" }
  s.author           = { "Wiinvent" => "info@wiinvent.tv" }
  s.source           = { :git => "https://github.com/WiinventDevTeam/mobileid-ios-sdk.git", :tag => s.version.to_s }
  s.platform         = :ios, "13.0"
  s.swift_version    = "5.0"

  # Binary distribution: prebuilt MobileIdSdk (upstream engine compiled in).
  s.vendored_frameworks = "MobileIdSdk.xcframework"

  s.pod_target_xcconfig = {
    "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "i386"
  }
end
