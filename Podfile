project 'Endangered Waves.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

# ignore all warnings from all pods
inhibit_all_warnings!

abstract_target 'shared' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Firebase
  pod 'Firebase'
  pod 'FirebaseUI'
  pod 'Fabric'
  pod 'Crashlytics'

  # UI Related
  pod 'LocationPickerViewController', :git => 'https://github.com/zhuorantan/LocationPicker.git', :commit => '15d9bae350e8ffd6bf3640afc423a8350ea2b523'
  pod 'LightboxV2'
  pod 'SVProgressHUD', '~> 2.2'

  # Other
  pod 'SwiftLint'

  # Target
  target 'Endangered Waves'
  target 'Endangered Waves dev'
end

# See https://www.cerebralgardens.com/blog/entry/2017/10/04/mix-and-match-swift-3-swift-4-libraries-with-cocoapods
# post_install do |installer|
#     print "Setting the default SWIFT_VERSION to 4.2\n"
#     installer.pods_project.build_configurations.each do |config|
#         config.build_settings['SWIFT_VERSION'] = '4.2'
#     end
#
#     installer.pods_project.targets.each do |target|
#         if ['LocationPickerViewController'].include? "#{target}"
#             print "Setting #{target}'s SWIFT_VERSION to 3.0\n"
#             target.build_configurations.each do |config|
#                 config.build_settings['SWIFT_VERSION'] = '3.0'
#             end
#             else
#             print "Setting #{target}'s SWIFT_VERSION to Undefined (Xcode will automatically resolve)\n"
#             target.build_configurations.each do |config|
#                 config.build_settings.delete('SWIFT_VERSION')
#             end
#         end
#     end
# end
