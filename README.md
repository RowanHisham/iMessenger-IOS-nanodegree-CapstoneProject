# iMessenger
This is the final capstone project app for Udacity iOS Developer Nanodegree. This is a messanger clone app, it allows
the user to sign up for an account, login using their email and password, view all of the users on the app, send
and recieve messages in real-time. Planning on adding other features in the future like push-notifications and sending images 
and videos.

 * [Project Rubric](https://review.udacity.com/#!/rubrics/1991/view)

## This project focused on
* Design and build an app from the ground up
* Build sophisticated and polished user interfaces with UIKit components
* Downloading data from network resources
* Using Firebase Framework for Authenticationa and Real-Time Database
* Persisting state on the device using Firebase Local Persistance
* Using NSCache to reduce the need to download reused data

## App Structure
iMessenger is following the MVC pattern, and utilizing Firebase Non-relational Database with the following structure

<img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessenger.png" alt="alt text" width="800" height="500" >
<img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessenger0.png" alt="alt text" width="500" height="500" >



## Implementation
### Login Screen 
Allows the user to log in using their email and password, when the user taps the Login button, the app will attempt to authenticate through Firebase.
If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.

<p align="center">
<img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessenger1.png" alt="alt text" width="300" height="550" >
</p>

### Sign up Screen
Allows the user to create a new account, and add a profile picture. If the email is already regiestered with another account
an alert is displayed. and after the account is created the user is notified and returned to the login screen.

<p align="center">
<img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessanger2.png" alt="alt text" width="300" height="550" ><img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessanger3.png" alt="alt text" width="300" height="550" >
</p>


### Messages Screen - New Message Screen
All the user's messages are loaded and and stored in a table view. The Controller observes any changes in the database and
when a new message is sent to the user the table view is updated and the message with its timestamp is displayed. The user can
send a new message in two ways, either through the Messages screen by tapping the row, or through the new message button 
in the navigation bar that shows a new table view with all the users regiestered in the app. Custom table view cells are used. 
A NSCache is used to store all the images locally to reduce the need to download similar profile images througout the app.

<p align="center">
<img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessanger4.png" alt="alt text" width="300" height="550" ><img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessanger5.png" alt="alt text" width="300" height="550" >
</p>

### Chat Screen
The chat screen send and recieves messages in real-time, and displays the messages and the profile image of the chat partner.
Custom table view cells are used.

<p align="center">
<img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessanger7.png" alt="alt text" width="300" height="550" ><img src="https://github.com/RowanHisham/iMessenger-IOS-nanodegree-CapstoneProject/blob/master/images/imessanger6.png" alt="alt text" width="300" height="550" >
</p>



## Environment
This app was created with the following environment in mind:

* XCode 10.1
* Swift 4.2

#### Cocoa Pods
This project uses CocoaPods for it's dependencies. To initalize the project you should first install CocoaPods and then initialize the dependencies by running

```console
pod install
```

After that, open the project using the iMessenger.xcworkspace created by CocoaPods.


## Frameworks
UIKit

Firebase Authentication

Firebase Database

Firebase Storage
