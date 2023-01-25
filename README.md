# Mark Item As 

## Overview 

"Mark Item As" is a World of Warcraft (WoW) utility add-on that helps you mark & automatically sell items that you don't want to keep. 

## How It Works 

MarkItemAs (a.k.a. MIA) is easy to use. Mark any items you don't want to keep with the pre-defined (or a custom) click combo and when you visit a merchant, those items will be automatically sold. 

To use the click combo, just hover your mouse over the item you want to mark and activate the combo. 

If you have duplicate or multiple items, marking one item/stack will mark all items that are the same. Similarly, un-marking one item/stack will un-mark all other items that are the same. 

Another feature of MIA is that you can auto-sort your bags after marking, un-marking, and/or selling. 

## Options & Defaults 

There are 4 main groups of options: `Marking`, `Selling`, `Sorting`, and `Chat`. 

### Marking 

#### Combo Activator Key 

This is the main mouse button that you will use to trigger marking/un-marking your items. The possible options are:

1. `LeftButton` 
2. `RightButton` (*this is the default value*) 

#### Combo Modifier Key 

This is the supplementary keyboard modifier that you will use with the mouse click to mark/un-mark items. The possible options are:

1. `Alt` 
2. `Ctrl` (*this is the default value*) 
3. `Shift` 

#### Item Overlay & Border 

The overlay & border are visual indicators to help you identify which items you've marked. The overlay is a color mask that sits on top of the items artwork. And the border is a set of colored lines that surround the item/bag slot. The color of the overlay and border are customizable using a color picker which has an alpha/transparency setting. The thickness of the border can be adjusted using a slider. The following *default values* are:

Overlay Color:  `{ r = 0, g = 0, b = 0, a = 0.75 }` (this is black with a 75% opacity) 

Border Color:  `{ r = 0.4, g = 0.4, b = 0.4, a = 1 }` (this is a dark-medium gray with 100% opacity) 

Border Thickness: `2` (the slider has a min value of 0 and a max value of 3) 

#### Marker Icon 

When you mark an item, a small icon will appear on top of the item and the overlay. The location and the type of icon are customizable via dropdown menus where you can select different values. The possible options are: 

##### Icon Image 

1. `Coin` (this is similar to the coin icon that Scrap displays) 
2. `Stack` 
3. `Trash` (*this is the default value*) 

##### Icon Location 

1. `Top Left` 
2. `Top Center` (a.k.a. TOP) 
3. `Top Right` 
4. `Center Left` (a.k.a. LEFT) 
5. `Center` 
6. `Center Right` (a.k.a. RIGHT) 
7. `Bottom Left` (*this is the default value*) 
8. `Bottom Center` (a.k.a. BOTTOM) 
9. `Bottom Right` 

#### Tooltip Text 

With this enabled, a line of text ("Marked as Junk - To be sold") will be added to the bottom of the item's tooltip after you mark it. 

This can be toggled `on` or `off` via a checkbox. It is `on` by *default*. 

### Selling 

#### Sale Summary 

After visiting a merchant, and selling your items, MIA will display a summary of the items you sold. The summary includes the following info: 

- A breakdown list of each item (or stack) sold: 
   - How much each item/stack was sold for 
   - The total amount made from that item/stack 
- A total summary of: 
   - How much money you made overall 
   - How many unique items were sold 
   - How many total items were sold 
   - A list of all items as `ItemLink`'s (to easily hover and see the in-game tooltip info) 

This can be toggled `on` or `off` via a checkbox. It is `on` by *default*. 

#### Sale Limit 

By *default*, MIA will limit the sale of marked items to 12, which is the most buyback items a merchant can hold at any one time. The items sold are determined by their place in the bags. 

MIA will start with the backpack and then will work its way up until it reaches the last (i.e. top most) bag. 

As it hits each bag, it will go through the bag slots from the top left corner down to the bottom right corner. 

Once it reaches a count of 12, it will stop selling. And if auto-sort is turned on, the items will re-arrange themselves. 

If the limit is disabled, everything marked gets sold. 

#### Auto Sell 

m 

### Sorting 

m 

### Chat 

m  

## Customization 

m 

## Screenshots 

coming soon...

## Support 

If you encounter any bugs or issues, please submit them on [GitHub](https://github.com/gflujan/mark-item-as/issues). 

You can leave comments on [CurseForge](https://www.curseforge.com/wow/addons/mark-item-as), and I'll check them periodically, but you're more likely to get a faster response on GitHub. 

## Future Features 

- Add support for Bagnon & Baggins add-ons 
- Add options to enable / disable the overlay & border 
- Add more icon options 
- Ability to mark items as "ready for auction" 
- Add bank, guild bank, and possibly void storage support 
- (potentially) Add support for other popular bag add-ons 
- (potentially) Add support for multiple user profiles 
- (potentially) Add more options for activator & modifier keys 

