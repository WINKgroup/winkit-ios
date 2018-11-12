# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

target 'WinkKit' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  pod 'Alamofire', '~> 4.7'
  pod 'AlamofireImage', '~> 3.4.1'
  pod 'DateTools'
  # Pods for WinkKit

  target 'Tests' do
      inherit! :search_paths
  end
end

post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
    
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    
end
