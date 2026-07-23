Pod::Spec.new do |s|
  s.name             = "MobileIdSdk-Static"
  s.module_name      = "MobileIdSdk"
  s.version          = "1.0.2"
  s.summary          = "MobileID SDK for iOS (static distribution)"
  s.description      = "MobileID mobile authentication SDK for iOS (static binary distribution)."
  s.homepage         = "https://mobileid.vn"
  s.license          = { :type => "Commercial", :file => "LICENSE" }
  s.author           = { "Wiinvent" => "info@wiinvent.tv" }
  s.source           = { :git => "https://github.com/WiinventDevTeam/mobileid-ios-sdk.git", :tag => s.version.to_s }
  s.platform         = :ios, "13.0"
  s.swift_version    = "5.0"

  # Static distribution: prebuilt MobileIdSdk (upstream engine compiled in), linked
  # into the app binary. No Embed & Sign, no use_frameworks! required.
  # Inner framework is MobileIdSdk (import unchanged); the static wrapper lives in
  # static/ so its basename matches the inner name — CocoaPods links -framework
  # MobileIdSdk, which must match, and this avoids clashing with the dynamic wrapper.
  s.static_framework    = true
  s.vendored_frameworks = "static/MobileIdSdk.xcframework"

  # A static framework's bundled PrivacyInfo.xcprivacy is NOT surfaced in Apple's
  # privacy report (CocoaPods #12365). Ship the manifest as a resource bundle so it
  # lands at the app root where Apple aggregates it.
  s.resource_bundles = { "MobileIdSdk_Privacy" => ["PrivacyInfo.xcprivacy"] }

  s.pod_target_xcconfig = {
    "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "i386"
  }
end
