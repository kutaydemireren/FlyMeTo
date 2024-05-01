# FlyMeTo

Welcome to FlyMeTo!

FlyMeTo is an iOS application listing a set of locations, and revealing them in the 'Places' tab of Wikipedia iOS app. While doing so, the project tries to convey an idea of my approach.

Although it currently only targets Wikipedia, the project is tried to be structured to allow convenient adaptations for further changing requirements.

## Setup

To be able to run this project, you must have Xcode version 15.0 installed.

Application has a single scheme, `FlyMeTo`. 
You might simply use this scheme to test or run.

### Testing the application:
Testing does not require any additional installation.

To test the project, please select the scheme, and run 'Test' on Xcode.
    Please note that parallel execution is enabled, and thus, it is suggested to run the tests on a simulator.

### Running the application:
App should be ran without any additional installation. No third-party dependencies have been used in the project. 

To run the application, please select the scheme, the destination of simulator or device, and finally run 'Run' on Xcode.

### Install Wikipedia
FlyMeTo attempts to navigate the user to the 'Places' tab of Wikipedia, on a tap on a location from the list. However, the Wikipedia application by default does not support navigation to a custom location as we need.

For this feature to work, you must install Wikipedia application yourself from my forked repository: https://github.com/kutaydemireren/wikipedia-ios
Please follow the instructions there to be able to run Wikipedia on your Xcode. 

Once you successfully ran the forked version, you can use FlyMeTo application to let it fly you to the location. 

## Description

In its very core, FlyMeTo is basically an application around `Place`s.

In this single page application, `Place`s can be fetched remotely and be displayed on screen. Tapping on a `Place` opens its location on 'Places' tab of Wikipedia app.

### Design

The project design is heavily inspired by Clean Architecture. It tries to show what I think how the structure and communication could look like, given the requirements such as networking or redirecting user to another application.

Please keep in mind that although the project is monolithic, the boundaries are respected throughout the project and interactions between elements are carefully made.

Looking from a broad perspective, there are 2 layers defining FlyMeTo:
- Domain: where entities or requirements like repository live. Defines the essence of the application.
- Application: where interactors and use cases live. This is where all business logic comes together.

The rest of the layers are considered to be an addition to the core of the application. Meaning that, application logic should have nothing to do with them, and rather they must be adapting to the application logic. This is essentially important for the maintenance of external sources or platform specifics. These layers are:
- Presentation: where lives the views displayed on screen, or platform (iOS) specific files and logics.
- Repository: included to be able to feed the application through `Place`s. At the moment, only depends on `Network` to do so.
- Network: included to handle networking. At the moment, all the remote tasks application has can be found here.

### Flow 

If we divide the structure into a few actors and follow the flow:
1. `PlacesView` gets displayed on screen, alongside with its view model (`VM`).
2. `VM` requests to reload places from `PlacesInteractor` (`INT`).`
3. `INT` fetches the `Place` array, and present them using `PlacesPresenter` (`PRS`).
4. `PRS` displays the `Place`s on screen.

## Notes || Limitations

### No Cache Policy
No cache policy has decided to account for the content changes. This is simply achieved by `URLSession.noCache`.

However, you might also want to take advantage of local and/or remote caches. In that case, you can always inject a `URLSession` of yours to `NetworkManagerImp`. Please see `NetworkManagerImp` and `URLSession.noCache` for more.

#### Injection
For the sake of keeping the project clean but effective, injection is done simply via injecting default dependencies through `init`s. However, I acknowledge that this is most probably not enough for an enterprise application. For bigger cases, I believe injection is a 'must' to be tackled from early on. 

### Currently, `PlacesViewModel` is the `PlacesPresenter`. 
  This decision is made not to over-complicate the flow. However, I believe, while this is not necessarily wrong, it might also become the factor to decrease the quality over time. Thus, it is designed in a way that a change can still be easily achieved.
  Because the presenter is only a contract, if and when the requirements expands, it is always possible to separate the presenter. And that will happen in the context of further needs, rather than trying to anticipate them by now. Since the interactor - one carrying the major part of the business logic - is only aware of presenter, updating solely the way of presentation is possible without effecting the rest of the application.

### Coverage
Unit tests are added as a result of TDD. The purpose of the tests is to enable faster and consistent progress of mine, rather than 'for the sake of having a coverage'. In case curious, you can take a look at how each case is treated by following the git history.

That is also why in areas where I feel the above purpose is defeated, I prioritise implementation over coverage.
A good example is the UI code in this project. I believe unit testing UI is not practical so I tend not to write for them.

By their nature, any kind of `View` tend to be updated much more frequently than the application logic. For instance, while most probably `PlacesRepository` will continue to return places, `PlacesViews` might need to update how the cells looks like quite soon (I know it does not look good!), or update the background.
Additionally, UI can be verified quite easily - especially if it is SwiftUI, thanks to the previews.

In case project ever gets continued, and when UI starts to get not-easy to verify, alternative approaches that are more up to task of verifying UI can always be implemented, such as snapshot testing (only an example).

