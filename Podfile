#source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'studioProectoveShops.xcodeproj'
#platform :ios, ‘8.0’
use_frameworks!

target ‘studioProectoveShops’ do
  pod 'Charts', '~> 3.0'
  pod 'Alamofire', '~> 4.3'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
end

pod 'PKHUD', '~> 4.2'
pod 'ReactiveCocoa', '~> 5.0'
pod 'Firebase'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end