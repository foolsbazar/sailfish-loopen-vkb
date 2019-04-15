import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../sailfish-loopen-vkb"

DefaultLooPen4 {
    letterCaptions:
    {
                "45-left":   ["n", "m", "f", "!"],
                "45-right":  ["o", "u", "v", "w"],
                "135-left":  ["e", "l", "k", "@"],
                "135-right": ["i", "h", "j", ","],
                "225-left":  ["t", "c", "z", "."],
                "225-right": ["s", "d", "g", "'"],
                "315-left":  ["y", "b", "p", "q"],
                "315-right": ["a", "r", "x", "?"]
    }
    capitalCaptions:
    {
                "45-left":   ["N", "M", "F", "!"],
                "45-right":  ["O", "U", "V", "W"],
                "135-left":  ["E", "L", "K", "@"],
                "135-right": ["I", "H", "J", ","],
                "225-left":  ["T", "C", "Z", "."],
                "225-right": ["S", "D", "G", "'"],
                "315-left":  ["Y", "B", "P", "Q"],
                "315-right": ["A", "R", "X", "?"]
    }
    accentCaption: {
                "45-left":   ["",  " ", " ", " "],
                "45-right":  ["",  " ", " ", " "],
                "135-left":  ["",  " ", " ", " "],
                "135-right": ["^", " ", " ", " "],
                "225-left":  ["~", "'", " ", " "],
                "225-right": ["`", "°", " ", " "],
                "315-left":  ["´", "¨", " ", " "],
                "315-right": ["¸", "", " ", " "]
    }

    // UNCOMMENT THE FOLLOWING 4 LINES FOR DIFFERENT FUNCTIONS IN SECTORS
//    sectorOptions: [
//        ["accent"   ,"backspace","symbol" ,"space"      ],
//        ["downArrow","leftArrow","upArrow","rightArrow",]
//    ]

    // Firts line for the sectorFunction activated with a single swipe
    // Second line refer to sectors seen as a botton

    // For ALL possible cases, and to modify different other pages of the
    // layout see the file "pen8_example.qml"
}

//                \      /
//                 \  3 /
//                  \  /
//                   \/   4
//               2   /\
//                  /  \
//                 / 1  \
//                /      \
