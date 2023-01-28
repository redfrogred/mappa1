# NOTES.md

This is where I am at with this project...

LEFT OFF ( version "1.0.a.001" )
* copied map page from other project

NEXT
* ?

FUTURE
* ?

NOTES
* Map Styling
    + used this article https://medium.com/@matthiasschuyten/google-maps-styling-in-flutter-5c4101806e83  
    + plus JSON to String here: https://tools.knowledgewalls.com/json-to-string

* PERMISSIONS FOR HTML, GEOLOCATION, AND GOOGLE MAP
1. 	android/app/build.gradle
		compileSdkVersion 33
2.	(same)		
		minSdkVersion 21
3.	(same)
		multiDexEnabled true
4.	android/app/src/main/AndroidManifest.xml
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/> 			
5.	(same)
		~ add API key ~	like:
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="~API KEY HERE~" /> 	    