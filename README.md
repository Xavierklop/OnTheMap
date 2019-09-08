# OnTheMap
The On The Map app allows users to share their location and a URL with their fellow friends. To visualize this data, On The Map uses a map with pins for location and pin annotations for user names and URLs, allowing users to place themselves “on the map,” so to speak. 

First, the user logs in to the app using their Udacity username and password. After login, the app downloads locations and links previously posted by other users. These links can point to any URL that a user chooses. 

After viewing the information posted by other users, a user can post their own location and link. The locations are specified with a string and forward geocoded. They can be as specific as a full street address or as generic as “Duisburg, Germany.”
## Prerequisites
Xcode 10.1+

Swift 4.2.1+

iOS 11.0+
## Installing
`git clone https://github.com/Xavierklop/OnTheMap.git`
## Overview
The following features are provided by this app:

 1. Log in using Udacity credentials.
 2. Allows users to see the locations of other users in two formats: table view or on the map.  
 3. Allows the users post their own locations and links.
### Main View controllers
#### LoginViewController
The LoginViewController accepts the email address and password that users use to login to the Udacity site. 

When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers. Clicking on the Sign Up link will open Safari to the Udacity sign-up page.

If the connection is made and the email and password are good, the app will segue to the Map and Table Tabbed View, which  has two tabs at the bottom: one specifying a map, and the other a table. 

If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.
#### MapViewController
The MapViewController displays a map with pins specifying the last 100 locations posted by students. The user is able to zoom and scroll the map to any location using standard pinch and drag gestures.

When the user taps a pin, it displays the pin annotation popup, with the user’s name (pulled from their Udacity profile) and the link associated with the user’s pin. Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin. Tapping outside of the annotation will dismiss/hide it.
#### ListViewController
When the ListViewController selected, the most recent 100 locations posted by users are displayed in a table. Each row displays the name from the user’s Udacity profile. Tapping on the row launches Safari and opens the link associated with the user.

The rightmost bar button will be a refresh button. Clicking on the button will refresh the entire data set by downloading and displaying the most recent 100 posts made by users.
#### PostLocationViewController
The PostLocationViewController allows users to input their own data. 

When the Information Posting View is modally presented, the user sees two text fields: one asks for a location and the other asks for a link.

When the user clicks on the “Find Location” button, the app will forward geocode the string. If the forward geocode fails, the app will display an alert view notifying the user. Likewise, an alert will be displayed if the link is empty.
#### PostFinishViewController
If the forward geocode succeeds then text fields will be hidden, and a map in PostFinishViewController showing the entered location will be displayed. Tapping the “Finish” button will post the location and link to the server.

If the submission fails to post the data to the server, then the user should see an alert with an error message describing the failure.

If at any point the user clicks on the “Cancel” button, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View.

Likewise, if the submission succeeds, then the Information Posting View should be dismissed, returning the app to the Map and Table Tabbed View.
## Technical features
- Use Udacity API to login and logout: authenticate Udacity API requests and delete the session ID to "logout".
- Use Udacity API is to retrieve some basic user information 
- Use Udacity OnTheMap API to get, put and post user location.
- Use URLSession to manager all API request.
- Use Decodable to parse JSON.
## License
This code may be used free of cost for a non-commercial purpose, provided the intended usage is notified to the owner via the below email address.
Any questions, please email wuhaocll@gmail.com
