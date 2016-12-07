# HOW WE DEVELOP MOBILE APPLICATIONS - Part 3
## Fleshing out the App

### Outline
* Fleshing out the Storyboard
  * Build storyboard from http://collectiveidea.com/blog/archives/2016/11/04/how-we-develop-mobile-applications
  * Why do we start w/ an empty Storyboard
    * Because it gets the app idea in client's hands sooner
    * Sooner means better feedback
    * Failing faster means failing cheaper for Client

* Test driving the storyboard w/ Integration Tests
  * Why test the UI?
    * So we know when we break things
    * They will evolve over time

### Fleshing out the workflow
* Build from the reference wireframe in part 1
  * http://collectiveidea.com/blog/archives/2016/11/04/how-we-develop-mobile-applications
* Open up `Donuts-iOS/Views/Main.storyboard` ![Main.Storyboard](main-storyboard.png)
  * Add "Welcome" screen
    * Rename `Donuts-iOS/Controllers/ViewController.swift` to `WelcomeViewController.swift`
    * Change class name to `WelcomeViewController.swift`
    * Change class used in Interface Builder to `WelcomeViewController`
    
  * Add "Success" screen
  * Add "Confirm" screen

  * Link "Welcome" -> "Success"


### Writing tests around the workflow
