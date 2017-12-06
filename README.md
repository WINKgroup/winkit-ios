# WinkKit

An iOS framework that contains a set of classes that solve some common problem written in Swift, used for Wink's application. Follow this guide to know how to structure a Wink iOS project.

## Getting Started

### Prerequisites

You need [Xcode 9](https://developer.apple.com/xcode/), Swift 4 and [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) installed.

### Installing

Just paste the CocoaPods dependency in your  `podfile`. Due to a cocoapods bug, ensure to paste the **post_install** function too.

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do

    # https://github.com/WINKgroup/WinkKit
    pod 'WinkKit'
    
end

# This post install is needed because of a Cocoapods bug; it is needed to render WinkKit properties in InterfaceBuilder correctly.
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end

```

## Understanding Structure

Before talking about classes of framework we'll take a look on architecture structure. 

It is a kind of VIPER pattern; look at this [iOS Architectures overview](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52) to understand differences between MVC, MVP, MVVM, VIPER.

A Wink iOS project **should** be structured in the following way, expecially if the project will grow a lot:


![Arch diagram](./readme-res/arch_diagram.jpg)

This kind of architecture is try to follow the **Responsability Distribution** concept: each layer exists without other ones and every component has different responsability; this improves the maintanance and the testability. The whole Xcode proj structure that maps this architecture is something like this:

<img src="readme-res/xcode_structure.png" width=50% />

<br>

### Presentation

It's the layer that contains all iOS Framework dedicated classes, like `UIKit` framework. We could say that this layer cannot exists without an iPhone/iPad because `UIKit` can run only there.

<img src="readme-res/presentation_layer.png" width=50% />

* **AppDelegate**: It's the well known AppDelegate class, nothing special;
* **Use Cases**: A group that contains all use cases. It's important to understand that a *Use Case* is what user do in one or more app screen, for example the Login.
	* **Login**: En example of a Use Case. It will contain all related ViewControllers, Presenter (if a use case contains more than one), DataSources etc.
		* **LoginPresenter**: A simple presenter; LoginPresenter keep the state of LoginViewController; a presenter is the class that contains logic, the ViewController does **not** contain logic. **Presenter doesn't contains UIKit classes!**, this is needed to keep presenters easy testable.
		* **LoginViewController**: In classic MVC pattern, (Massive View Controller in iOS world 😫) all logic was here, mixed with the view handling; in this framework a ViewController **owns** a presenter and delegates it for the logic. The view controller doesn't have a method `func performLogin(email: String, password: String)` for example; instead, the presenter does. The view controller will only receive user input and tell the presenter that something happened. The presenter will do work and tell the view controller that the view should change.
* **Core**: A group that contains base classes re-usable all around project. It's a good practice to define this classes to avoid code duplication that could increase the maintanance difficulty.\
* **Models**: Contains all model classes that are used **only** in the presentation layer.
* **Resources**: All resources go here, included .xcassets, custom fonts...

<br>

### Data
It's the layer that handles all data stuff, such as http calls, cache uploading/downloading to/from a backend. No `UIKit` classes in this layer!

<img src="readme-res/data_layer.png" width=50% />

* **Cache**: A group that contains classes like SessionManager and all other stuff that saves data locally.
* **Networking**: The group that contains the Http Client, which must be implemented with **Alamofire**. WinkKit provides [Alamofire](https://github.com/Alamofire/Alamofire) and [Alamofire Image](https://github.com/Alamofire/AlamofireImage) in the framework itself, so you don't need to add anything in the Podfile.
	* **ResponseSerialization**: Contains the `DataResponse` extension of Alamofire: it provides a common response for http calls that return an object instead of a json; json parsing is done in this extension (see source file for detail). Notice that this extension uses [Argo](https://github.com/thoughtbot/Argo) for json parsing. 
	* **Resource**: and enum that maps the response of https calls.
	* **Error**: the class/struct that maps http errors (both client and server) 
	* **Routers**: Routers are responsible to know api's endpoints and to create a `urlRequest` that are used by **Services** to perform http calls.
	* **Services**: Services perform http calls, using the request created by routers.
	* **Models**: Simple classes/structs that maps the server json response. 

<br>

### Domain
It's layer in which there is business logic; it's a kind of bridge that connect **Presentation** and **Data** layers without without couple them. No `UIKit` classes in this layer!

<img src="readme-res/domain_layer.png" width=50% />

Here you'll put interactors that contain all business logic; presenters use this interactor to communicate with **data** layer.

## Authors

**Rico Crescenzio** - [Linkedin](https://www.linkedin.com/in/quirico-crescenzio-810263b9/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
