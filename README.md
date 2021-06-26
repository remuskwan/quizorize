# Quizorize
## Overview
Quizorize is a gamified flashcard iOS application that aims to improve the learning and memorising experience of its users, leveraging on the use of 'Spaced Repetition' and 'Active Recall' studying techniques. 

This iOS application is targeted towards students aged 14 and above that wishes to leverage on good revision techniques to remember content taught in school. With a gamification features such as achievements and a leveling system, students are incentivised to spend more time on the app while ensuring productivity is met.

## Getting started

### TestFlight (on iOS devices)

To request a copy of the current Pre-Alpha build of Quizorize on your iOS device, please head over to this link [here](https://forms.gle/QB14gRb8jx5TJTKe8).

Note: Supports iPhone and iPad running iOS 14 and later.

### Local Test (on your Mac)
Requirements: Mac running macOS 11 BigSur, [Xcode 12](https://developer.apple.com/xcode/)

To run quizorize locally, first clone this repository.

```bash
git clone https://github.com/remuskwan/quizorize.git
``` 

Then, run the following command in the root directory of the cloned repository

```bash
pod install
```

Open, the workspace file 'Quizorize.xcworkspace' to view the code and run its build.

## Documentation

Please refer to our Milestone README [here](https://docs.google.com/document/d/1BBVJUarCBF2qy_ZWbH6zZka4ebhrtTBtQnHnmGUuizE/edit?ts=60afa18d).

## Launching the App

1. On the home screen of your iOS device (running on iOS 14.0 or later), tap the app icon
2. You will be presented with the Launch Screen of our app.
3. Pressing "Get Started." will bring you to the login page


<p align="left"><img src="public/ReadMeImgs/startView.png" width="25%"/></p>

## User Login
1. Type in your email address and password to login
2. You can click on 'Register' to create an account if you do not have one.
3. You may also sign in using your Apple or Google account
4. After successful login, you will be presented with the Homepage of our app.

<img src = "public/ReadMeImgs/login1.png" width ="25%" /> <img src = "public/ReadMeImgs/login2.png" width ="25%" /> <img src = "public/ReadMeImgs/login3.png" width ="25%" />

## Registration
1. Type in your particulars into the text fields provided
2. Ensure that the validity checks of the fields are met
3. Create account

<img src = "public/ReadMeImgs/register1.png" width ="25%" /> <img src = "public/ReadMeImgs/register2.png" width ="25%" /> <img src = "public/ReadMeImgs/register3.png" width ="25%" />

## Homepage ("Decks screen")
1. Houses user-created decks, which can be accessed from any of the user's devices on which they are logged-in
2. Users can create new decks by tapping the "New" icon.
3. Users can access a deck's preview screen by tapping on its icon.
4. Users can edit a deck or delete a deck by tapping on its title.
5. Tapping the bell icon on the top left of the page will bring up the Activity page, which is currently work-in-progress. It will house the user's notifications and reminders to revise their decks according to the spaced repetition algorithm.

## Deck Creation
1. Tap "New" to create a new deck.
2. Enter the deck's title and the flashcards' prompts and answers. Each deck must contain a minimum of two flashcards. 
3. Swipe left on a flashcard to remove it from the deck.
4. Tap "Create" to finish creating the deck.

## Deck Preview
1. The deck's flashcards are displayed in a carousel at the top of the screen. 
2. Tap a flashcard to flip it (prompt on the front, answer on the back)
3. Swipe left and right to navigate between flashcards.
4. Tap "Practice" to access Practice mode.

## Practice Mode
1. The deck of flashcards are displayed as an interactive deck in the middle of the screen.
2. Swipe left or right to navigate to the next flashcard. The counter and progress bar increments with each swipe.
3. A summary screen is shown when "Practice" is complete. Tapping the "Reset" button resets the page.
4. Tap the "X" in the top left corner to exit Practice mode
5. Tapping the optional "Shuffle" button shuffles the deck of flashcards

## Search
1. Tap the "Search" icon in the tab bar to access the Search page.
2. Enter a decks name into the search field to search for a deck.
3. Tap on the deck's icon to view its preview screen.

## Profile
1. Currently "Work-in-Progress". Will show user's profile details as well as level and achievements.
3. Pressing "Sign out" will sign the user out of their account and bring them back to the Launch Screen

## Planned Features
1. Spaced Repetition Algorithm
4. Favoriting decks and flashcards (for ease-of-access)
5. Level and achievement system
6. Leaderboard system
7. Settings (to edit profile, app settings)

## Known Bugs
1. If you are running Quizorize on a simulator from Xcode, the secure fields (Password and Confirm password) will sometimes show 'Strong Password' 
