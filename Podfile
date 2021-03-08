project 'Endangered Waves.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

# Fix from https://stackoverflow.com/questions/60884826/unable-to-add-a-source-with-url-https-cdn-cocoapods-org-named-trunk
source 'https://github.com/CocoaPods/Specs.git'

# ignore all warnings from all pods
inhibit_all_warnings!

abstract_target 'shared' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Firebase
  pod 'Firebase', '~> 7.7'
  # pod 'Fabric', '~> 1.10.2' removed my Matt on 2021-02-15 as they no long work/exist
  # pod 'Crashlytics', '~> 3.14.0' removed my Matt on 2021-02-15 as they no long work/exist
  
  # UI Bindings for Firebase
  pod 'FirebaseUI/Firestore', '~> 10.0'
  pod 'FirebaseUI/Auth', '~> 10.0'
  pod 'FirebaseUI/Storage', '~> 10.0'
  
  # UI Related
  pod 'SDWebImage', '~> 5.10'
  pod 'LocationPickerViewController', :git => 'https://github.com/zhuorantan/LocationPicker.git', :commit => '15d9bae350e8ffd6bf3640afc423a8350ea2b523'
  pod 'SVProgressHUD', '~> 2.2'

  # KML parser for WSR map polygons
  pod 'Kml.swift', '~> 0.3.2'

  # Dev stuff
  pod 'SwiftLint'

  # Target
  target 'Endangered Waves'
  target 'Endangered Waves dev'
end


post_install do |installer|
  # Fix from https://stackoverflow.com/questions/63607158/xcode-12-building-for-ios-simulator-but-linking-in-object-file-built-for-ios
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  
  # Fix from https://www.jessesquires.com/blog/2020/07/20/xcode-12-drops-support-for-ios-8-fix-for-cocoapods/
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
