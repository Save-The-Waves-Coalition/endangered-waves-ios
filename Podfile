project 'Endangered Waves.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

abstract_target 'shared' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Firebase
  pod 'Firebase', '~> 6.19.0'
  pod 'FirebaseUI/Firestore', '~> 8.4.2'
  pod 'FirebaseUI/Auth', '~> 8.4.2'
  pod 'FirebaseUI/Storage', '~> 8.4.2'
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  pod 'SDWebImage', '~> 5.6.1'

  # UI Related
  pod 'LocationPickerViewController', :git => 'https://github.com/zhuorantan/LocationPicker.git', :commit => '15d9bae350e8ffd6bf3640afc423a8350ea2b523'
  pod 'SVProgressHUD', '~> 2.2'

  # Other
  pod 'SwiftLint'

  # Target
  target 'Endangered Waves'
  target 'Endangered Waves dev'
end
