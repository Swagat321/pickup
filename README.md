# pickup

A new Flutter project.

# Fixes:

- [x] Reset myUser to null when logged out. <- Just did it. Test it out.

- [ ] Disallow currently joined users from joining the same game/chat.

- [ ] Occational GameService error when logged out. Figure out why??? <-- Might just be because I changed some things and reloaded, causing the internal state of the app to be different than expected. <- It's also always the first time right after loggin in.

# Plan: (as of March 24th)

- [x] Access contact information
- [ ] Send message to a contact "down to play pickup on (Date) at (Time)? [link]" 
- [x] Auto-refresh 
- [ ] Current Game or Finished Game Dashboard.
<!-- - [ ] Send message to add player to group chat. -->

# Todos: (by end of Friday)
Discover:
* Large UserNames should elipse

* Improve GameCard Widget

* Impl change userName and changePicture functionalities in Menu

* Add change location type feature to menu.

* Add Review Feedback.


Create:

* Maybe Improve the UI

* Plug it into the Game Collection in Frebase


Chat:

* Add a "PickUp" functionality to ChatScreen

* Calculate and store avgRating


GameCard: 

* Display all information about the game.

* Add a "Join" button to join the Group Chat and the game.

