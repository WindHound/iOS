# WindHound - Sailing Tracker and schedule organiser
Aim of a project is to develop an multi-cross platform application to organise schedules and analysis sailing. This part of a project specifically contains a development for an iOS application. This project is done during Year 2 of Computer Science undergraduate course at University of Bristol for SPE assignment.

<p align="center">
  <img src="https://github.com/WindHound/iOS/blob/master/images/Overall%20Architecture.png" width="500" title="Application architecture">
  <br>
  <sup>Overall architecture of iOS application</sup>
</p>

## Login
When an application is launched, a login page will first show up. It is possible to create a new acoount by using a signup page.
<p align="center">
  <img src="https://github.com/WindHound/iOS/blob/master/gpsTracker/Interface_screen_shot/IMG_0035.PNG" width="200" title="Login">
  <img src="https://github.com/WindHound/iOS/blob/master/images/Sign%20Up%20Page.png" width="200" title="Signup">
  <br>
  <sup>Login Page(Left) and Signup Page(Right)</sup>
</p>

## Organising schedules 
After logging in, both upcoming and past schedules are listed in one of three sections; Championships, Events and Races. Within a single championship, there can be multiple events, and within a single event, there can be multiple races. 
<p align="center">
  <img src="https://github.com/WindHound/iOS/blob/master/images/Upcoming.png" width="200" title="Upcoming">
  <br>
  <sup>Upcoming and past schedules displaying in three different sections(Championships, Events, Races)</sup>
</p>

It is possible to create a new championship/event/race by pressing + button and choose an administrator for a new championship/event/race. In addition, existing events/races can be added as part of a new championship/event. 
<p align="center">
  <img src="https://github.com/WindHound/iOS/blob/master/images/New%20Championship1.png" width="200" title="New Championship 1">
  <img src="https://github.com/WindHound/iOS/blob/master/images/Add%20administrator.png" width="200" title="Add administrator">
  <br>
  <sup>Creating new championship(Left) and administrator selection page(Right)</sup>
  <br>
  <img src="https://github.com/WindHound/iOS/blob/master/images/New%20Event1.png" width="200" title="New Event 1">
  <img src="https://github.com/WindHound/iOS/blob/master/images/New%20Event2.png" width="200" title="New Event 2">
  <br>
  <sup>Creating new event</sup>
  <br>
  <img src="https://github.com/WindHound/iOS/blob/master/images/New%20Race1.png" width="200" title="New Race 1">
  <img src="https://github.com/WindHound/iOS/blob/master/images/New%20Race2.png" width="200" title="New Race 2">
  <img src="https://github.com/WindHound/iOS/blob/master/images/Add%20Boat.png" width="200" title="Add boat">
  <br>
  <sup>Creating new race(Left) and assigning which boats will join a race(Right)</sup>
</p>

## Analyse
Once a race is finished, an application shows a replay of race.
<p align="center">
  <img src="https://github.com/WindHound/iOS/blob/master/images/Replay.gif" width="200" title="Replay">
  <br>
  <sup>Replay</sup>
