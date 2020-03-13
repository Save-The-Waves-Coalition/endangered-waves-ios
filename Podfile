project 'Endangered Waves.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# ignore all warnings from all pods
inhibit_all_warnings!

abstract_target 'shared' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Firebase
  pod 'Firebase', '~> 4.10'
  pod 'FirebaseUI', '~> 4.5'
  pod 'Crashlytics', '~> 3.10'

  # UI Related
  pod 'LocationPickerViewController', '~> 3.3'
  pod 'ImagePicker', '~> 3.0'
  pod 'Lightbox', '~> 2.1'
  pod 'SVProgressHUD', '~> 2.2'

  # Other
  pod 'SwiftLint'

  # Target
  target 'Endangered Waves'
  target 'Endangered Waves dev'
end

# See https://www.cerebralgardens.com/blog/entry/2017/10/04/mix-and-match-swift-3-swift-4-libraries-with-cocoapods
post_install do |installer|
    print "Setting the default SWIFT_VERSION to 4.2\n"
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
    end

    installer.pods_project.targets.each do |target|
        if ['LocationPickerViewController'].include? "#{target}"
            print "Setting #{target}'s SWIFT_VERSION to 3.0\n"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
            else
            print "Setting #{target}'s SWIFT_VERSION to Undefined (Xcode will automatically resolve)\n"
            target.build_configurations.each do |config|
                config.build_settings.delete('SWIFT_VERSION')
            end
        end
    end
end
