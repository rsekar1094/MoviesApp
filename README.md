# Movies List App

## Overview
This app allows the user to view a list of watched, to watch and favorites movies. The app features include:
- Horizontal scroll on favorite movies list if the number of movies exceeds the screen width.
- API integration to fetch movie data.
- When a movie is selected, its details page shows all the synced information about the movie.
- If a movie is selected in the favorite list, the corresponding movie in the Watched/To Watch list is also selected and vice versa.
- Movies are sorted based on rating. If two movies have the same rating, they are sorted based on the name.

## Requirements
- iOS 16.0+
- Xcode 14.0+
- Swift 5.0+

## Installation
1. Clone or download the repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or a physical device.

## API Documentation
The app uses the following APIs to fetch movie data:
- `/movies/list`: Returns a list of all movies.
- `/movies/favorites`: Returns a list of favorite movies.

## Libraries Used
- Combine: Used for reactive programming.
- Kingfisher: Used for loading images from URLs and caching them.

## Unit Test cases
- Achieved 75% overral test coverrage and 100% test coverage on both screen viewmodels

<img width="1059" alt="Screenshot 2023-04-10 at 16 11 41" src="https://user-images.githubusercontent.com/28526677/230922242-e4a70ba9-e386-40ba-b5b5-3296477a2e82.png">

## Theme and Orientation
- Supported both light and dark Theme and both portrait and landscape modes
![Simulator Screen Shot - iPhone 14 Pro - 2023-04-10 at 16 03 30](https://user-images.githubusercontent.com/28526677/230922440-95f2ae5b-34fd-4c8b-aab2-5441d1e213b6.png)
![Simulator Screen Shot - iPhone 14 Pro - 2023-04-10 at 16 03 41](https://user-images.githubusercontent.com/28526677/230922463-09ddd48b-df0d-4f29-a50f-63714d770507.png)



https://user-images.githubusercontent.com/28526677/230923586-71ea1710-ce1f-4a43-94e8-cbaf76667809.mp4


