
# HerShield 2.0

A little help notes in case there is an error

- ###  If some dependency changes are there and code does not works :-
    1.  cd into folder (hershield or backend_shield)
    2.  Clean all dependency
  ```Terminal
    flutter clean
  ```
    3.  Add all dependency
  ```Terminal
    flutter pub get
  ```

- ###  Google login is not working. Then you need to add your device SHA1 and SHA256 in Firebase (For android)  :-

    1.  cd to "hershield/android"
    2.  Run command "./gradlew signingReport" and it will take some time.
    ```Terminal
    ./gradlew signingReport
    ```
    3.  Go to "https://console.firebase.google.com/u/9/"
    4.  Open "HerShield"
    5.  Go to Project Setting.
    6.  Scroll down on General Tab.
    7.  Add both fingerprints.

  ### Now it should work hopefully

