As our beloved Sailfish OS is trying to teach us, the touchscreen experience should be more about swiping than tapping and this keyboard finally brings any word to a swipe from your fingers! 
This very complicated keyboard will allow you to write without typos even on very small screens.
The Loopen Keyboard was created by Jimmy Huguet, inspired by the Android 8pen keyboard, generalizing the concept of the latter, which has 4 sectors, to an N-sectors keyboard!
As I started using the Loopen, I found the need to add many features, thus ending to fork the Loopen in the present work. 

It is quite hard to get use to this keyboard but, if you'll see it more like a game than a new frustrating habit, at the end you'll see it will be fun!
Trust me, even if your speed is never going to be comparable with a two finger typing, the comfort of using only one hand while you're standing in the metro or chilling on the couch, will never let you go back to normal keyboard.

Available layouts are only English (with both 4 and 6 sectors) and Italian (only 4 sectors), but if you want to see your language, just ask (and possibly draw me which should be the letters order) and I’ll add ASAP.

# How to use it
The keyboard is composed by a central disk and N-Sectors separated by N-arms, plus some additional (intuitive) buttons. For simplicity, consider only the case with 4 sectors.
The swipe gesture should starts from the central disk.
To type a letter swipe first in the sector where the letter is located (for instance, for the “s” letter it would mean from the center to the upper sector).
Once you are in the sector you can access to two set of letters, organized in two separated arms: one on the left of the sector and one on the right.
If the letter you choose is on the right arm, start swiping on the right (clockwise order), if it is on the left one, start swiping in anticlockwise order.
To choose the first letter of the arm cross with the swipe only one other sector (for the “s” letter it would mean from the upper sector to the left one)
To choose the second letter cross with the swipe two sectors (i.e. for the “d” letter it would mean from the upper sector, cross the left one and reach the bottom one)
Once you chose the proper letter, confirm by going back to the center or by releasing the touchscreen.

If the swipe gesture does not start from the center, you will commit Capital letters.

Each sector has two additional functions: One is activated if you swipe from the center to the sector and back to the center; the other one by tapping on the sector.
Because the typing experience depends on each one’s habit, I strongly encourage personalization of these functions, because not everyone might agree with me for what it is necessary or not. Anyway, by default they are: four arrows when tapping; space when swiping on the right; backspace on the left; accents view on the bottom; symbols view on the top.

In order to add an accented letter, just like the SailfishEase keyboard, first type the letter (for instance “A”) then type the symbol of the accent (for instance “`”) and the keyboard automatically substitutes the accented letter (“À” in the example).

The central disk works also as a normal spacebar.

There is also an emoji view that appears when keeping the symbol button pressed (maybe useless since SFOS 3).

From my personal experience (and thanks also to 247 feedback) I think there is a big difference when swiping with your thumb or with your index. If you use the thumb it’s useless to have a space character committed when releasing the touchscreen, while it becomes very useful when using the index. Therefore, I added a little button in the bottom left corner that shows a flag when the keyboard automatically commits the space character, or a cross otherwise, in order to easily switch between the two.

If you are interested is various views personalization give a look at the layout "loopen4_example.qml".

# Planned features
- left handed support
- nicer trace
- UI for personalizing sectors functions
- transparent layout