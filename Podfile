# Uncomment the next line to define a global platform for your project
platform :ios, '10.2'

target 'PillBuddies' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # ignore all warnings from all pods
  inhibit_all_warnings!
  # Pods for PillBuddies
  pod 'SVGKit', :git => 'https://github.com/SVGKit/SVGKit.git', :branch => '2.x'
  pod 'DesignSystem', :git => 'https://github.com/pill-pals/design-system-ios.git', :branch => 'master'

  target 'PillBuddiesTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |pi|
      pi.pods_project.targets.each do |t|
          t.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.2'
          end
      end
  end

end
