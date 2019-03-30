platform :ios, '10.0'
inhibit_all_warnings!

target 'Curbd' do
  use_frameworks!

  pod 'Pulley'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'Eureka'
  pod 'Stripe'
  pod 'ImageSlideshow'
  pod 'ImageSlideshow/Kingfisher'
  pod 'NVActivityIndicatorView'
  pod 'Siren'
  pod 'ImageViewer', :git => 'https://github.com/MailOnline/ImageViewer.git', :commit => 'ffe41dffb2ec0d6506d622b10099dc5e5eaeea43'
  pod 'SwiftEntryKit', '0.8.8'
  pod 'SwiftySound'

end


# The following code was taken from:
# https://github.com/CocoaPods/CocoaPods/issues/7314
# It is intended to ensure all Pods' deployment target
# is at least iOS 10.0 despite what the Pod's settings
# may have specified.

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
