# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'FireChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for FireChat
 
 # Add the pods for any other Firebase products you want to use in your app
# For example, to use Firebase Authentication and Cloud Firestore
 #pod 'Firebase/Analytics'
 pod 'Firebase/Auth'
 pod 'Firebase/Messaging'
 pod 'Firebase/Firestore'
 pod 'Firebase/Storage'
 #pod 'Reveal-SDK', :configurations => ['Debug']
 pod 'MessageKit'

  target 'FireChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == "Pods-[Name of Project]"
      puts "Updating #{target.name} to exclude Crashlytics/Fabric/Analytics/FIRAnalyticsConnector"
      target.build_configurations.each do |config|
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig.sub!('-framework "Crashlytics"', '')
        xcconfig.sub!('-framework "Fabric"', '')
	xconfig.sub!('-framework "Analytics"', '')
	xconfig.sub!('-framework "FIRAnalyticsConnector"', '')
        new_xcconfig = xcconfig + 'OTHER_LDFLAGS[sdk=iphone*] = -framework "Crashlytics" -framework "Fabric" -framework "Analytics" -framework "FIRAnalyticsConnector"'
        File.open(xcconfig_path, "w") { |file| file << new_xcconfig }
      end
    end
  end
end

end
