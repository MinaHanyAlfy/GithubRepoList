# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RepoTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'SVProgressHUD', '2.2.5'
pod 'UIScrollView-InfiniteScroll', '1.1.0'
pod 'DZNEmptyDataSet', '1.8.1'

  # Pods for RepoTask

  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
                 end
            end
     end
  end
  
  target 'RepoTaskTests' do
    inherit! :search_paths
    
    # Pods for testing
  end

  target 'RepoTaskUITests' do
    # Pods for testing
  end

end
