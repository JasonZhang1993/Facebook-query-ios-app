# Facebook-query-ios-app
An ios app that uses Facebook graph API and IOS SDK to enable users to make queries about users, pages, events, places and groups. The interface also enable users to view query details about user posts and albums, or to edit favorite contents and share on users Facebook account.

# Files

Root Directory:

1. AppDelegate.swift: Add several lines to set up Facebook IOS SDK

2. FB Search-Bridging-Header.h: bridge header file that import libraries of SWRevealViewController and Facebook IOS SDK modules

3. SearchKeyword.swift: singleton class to carry necessary global variables

4. Views: all table view cell classes

	a. MenuTableViewCell: table view cell class for sliding menu

	b. SearchTableViewCell: table view cell class for search result tables

	c. AlbumTableViewCell: table view cell class for detail album tables

	d. PostTableViewCell: table view cell class for detail post tables

5. Controllers: all controller classes

	a. About: about me view controller

	b. Home: the search home page view controller

	c. Menu: the slide menu view controller

	d. Search_Results: all controllers belonging to search results

	1) SearchTable.swift: the tab bar controller controlling 5 search result controllers

	2) ***ViewController.swift: controller classes for 5 types results

	e. Favorites: all controllers belonging to favorites

	1) FavoriteTable.swift: the tab bar controller controlling 5 favorite controllers

	2) ***FavoriteController.swift: controller classes for 5 types results

	f. Detail_Results: all controllers belonging to detail results
		
	1) DetailResults.swift: the tab bar controller controlling 2 detail controllers and the option button

	2) Album/PostViewController.swift: controller classes for albums/posts results
