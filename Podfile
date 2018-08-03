platform :ios, '9.0'
inhibit_all_warnings!

target 'parking app' do
  use_frameworks!

  pod 'Pulley'
  pod 'Alamofire', '~> 4.5'
  pod 'SwiftyJSON'
  pod 'Eureka'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Eureka'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
            end
        end
    end
end
