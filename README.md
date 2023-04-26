# Characters App

## Overview

This project is a sample iOS application that fetches and displays character data from a DuckDuckGo's RESTful Web API. The app is written in Swift using UIKit and follows an MVC architecture. It supports both portrait and landscape orientations on iPhones and iPads.

## Features
- Fetches character data from a RESTful Web API
- Displays a vertically scrollable list of character names
- Offers search functionality to filter characters by name or description
- Presents character details, including image, name, and description
- Utilizes a shared codebase to create two app variants with different names, package names, and data sources

## Libraries Used 

I used the Swift Package Manager to add the follow libraries

1. SDWebImage: A popular library for asynchronous image downloading and caching. 

  https://github.com/SDWebImage/SDWebImage

## Building and Running the Project

1. Clone the repository to your local machine
2. Open the project in Xcode 14 or higher
3. Choose the desired app variant scheme (Simpsons Character Viewer or The Wire Character Viewer)

<img width="300" alt="Screenshot 2023-04-25 at 10 05 48 PM" src="https://user-images.githubusercontent.com/75696759/234447534-ec2f4f17-1d26-4690-8af2-960b887e35ff.png">

4. Build and run the project on an iPhone or iPad simulator or a physical device
5. View commit history to see my thought process - https://github.com/davidrazmadzeExtra/CharactersApp/commits/main

## Screenshots

<img width="300" alt="Screenshot 2023-04-25 at 10 06 28 PM" src="https://user-images.githubusercontent.com/75696759/234447652-051db068-6f2e-4427-abd1-62d0bcfb07e8.png">

<img width="300" alt="Screenshot 2023-04-25 at 10 06 32 PM" src="https://user-images.githubusercontent.com/75696759/234447642-819a0961-5607-4c80-a4b0-5e71167e63df.png">

<img width="700" alt="Screenshot 2023-04-25 at 10 07 17 PM" src="https://user-images.githubusercontent.com/75696759/234447741-57fc34b5-54c7-4980-8364-672d17127c9b.png">

## Improvements

1. Pagination - to handle large datasets efficiently. Improves the performance and UX
2. Offline Support - Add `CoreData` and save all the data locally for offline usage
3. Accessibility - adhere to users who visual, auditory, or motor impairments
4. Localization - add more langauges to make it widely accepted
5. Unit and UI Tests - Increase test coverage to ensure the apps stability and reliability
6. Dark Mode - should work fine for now but optimizations
7. Error handling - handle more errors and display them to the user. Test under various conditions (slow network speeds, API not working, etc.)
8. Design improvements - for a first version it will do but a UI/UX designer should create a better design that I can 👨‍💻
