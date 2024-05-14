# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'BXCardUsuario' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	
	# Pods for AttiveCardUsuario
	pod 'Alamofire'
	pod 'AlamofireImage'
	pod 'IQKeyboardManagerSwift'
	pod 'VMaskTextField'
	pod 'InputMask'
	pod 'Firebase'
	pod 'FirebaseMessaging'
	pod 'AnimatedCollectionViewLayout'
	pod 'GoogleMaps'
	pod 'GooglePlaces'
	pod 'UPCarouselFlowLayout'
	pod 'CryptoSwift'
	pod 'SwiftKeychainWrapper'
	
	post_install do |installer|
		installer.pods_project.targets.each do |target|
			target.build_configurations.each do |config|
				config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
				config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
			end
		end
	end
end
