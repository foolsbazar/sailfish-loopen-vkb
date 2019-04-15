import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../sailfish-loopen-vkb"

DefaultLooPen4 {
    letterCaptions: {
                "45-left":   ["c", "m", "f", "@"],
                "45-right":  ["o", "p", "v", "w"],
                "135-left":  ["e", "l", "k", "j"],
                "135-right": ["i", "h", "!", ","],
                "225-left":  ["t", "g", "q", "."],
                "225-right": ["s", "d", "z", "'"],
                "315-left":  ["n", "b", "u", "y"],
                "315-right": ["a", "r", "?", "x"] 
    }
    capitalCaptions: {
                "45-left":   ["C", "M", "F", "@"],
                "45-right":  ["O", "P", "V", "W"],
                "135-left":  ["E", "L", "K", "J"],
                "135-right": ["I", "H", "!", ","],
                "225-left":  ["T", "G", "Q", "."],
                "225-right": ["S", "D", "Z", "'"],
                "315-left":  ["N", "B", "U", "Y"],
                "315-right": ["A", "R", "?", "X"]
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

