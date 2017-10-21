# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Chatter' do
    use_frameworks!
    
    # Pods for Chatter
    
    pod 'Material'
    pod 'TinyConstraints'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'TransitionButton'
    pod 'Gifu'
    
    # [START auth_pod]
    pod 'Firebase/Auth'
    # [END auth_pod]
    
    # These are pods used for the auth providers.
    pod 'FBSDKLoginKit'
    # [START google_pod]
    pod 'GoogleSignIn'
    # [END google_pod]
    pod 'TwitterKit'
    
    
    
    
    target 'ChatterTests' do
        inherit! :search_paths
        # Pods for testing
        pod 'RxBlocking'
        pod 'RxTest'
        
        
    end
    
    target 'ChatterUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end
