import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../sailfish-loopen-vkb"

DefaultLooPen6 {
    letterCaptions: {
                "0-left":    ["m", "p", ":"],
                "0-right":   ["u", "x", ";"],
                "60-left":   ["n", "f", "!"],
                "60-right":  ["o", "v", "w"],
                "120-left":  ["e", "k", "'"],
                "120-right": ["i", "j", ","],
                "180-left":  ["t", "z", "."],
                "180-right": ["s", "d", "&"],
                "240-left":  ["y", "b", "q"],
                "240-right": ["a", "r", "?"],
                "300-left":  ["c", "l", "@"],
                "300-right": ["h", "g", "#"]
    }
    capitalCaptions: {
                "0-left":    ["M", "P", ":"],
                "0-right":   ["U", "X", ";"],
                "60-left":   ["N", "F", "!"],
                "60-right":  ["O", "V", "W"],
                "120-left":  ["E", "K", "'"],
                "120-right": ["I", "J", ","],
                "180-left":  ["T", "Z", "."],
                "180-right": ["S", "D", "&"],
                "240-left":  ["Y", "B", "Q"],
                "240-right": ["A", "R", "?"],
                "300-left":  ["C", "L", "@"],
                "300-right": ["H", "G", "#"]
    }
    accentCaption:  {
                "0-left":    ["",  " ", " "],
                "0-right":   ["",  " ", " "],
                "60-left":   ["",  " ", " "],
                "60-right":  ["",  " ", " "],
                "120-left":  ["",  " ", " "],
                "120-right": ["",  " ", " "],
                "180-left":  ["",  " ", " "],
                "180-right": ["^", " ", " "],
                "240-left":  ["~", "'", " "],
                "240-right": ["`", "°", " "],
                "300-left":  ["´", "¨", " "],
                "300-right": ["¸", " ", " "]
    }

    // UNCOMMENT THE FOLLOWING 4 LINES FOR DIFFERENT FUNCTIONS IN SECTORS
//    sectorOptions: [
//    ["enter"   ,"accent"   ,"backspace","shift","symbol" ,"space"      ],
//    ["enterKey","downArrow","leftArrow","shift","upArrow","rightArrow",]
//    ]

    // Firts line for the sectorFunction activated with a single swipe
    // Second line refer to sectors seen as a botton

    // For ALL possible cases, and to modify different other pages of the
    // layout see the file "pen8_example.qml"
}

//                             \      /
//                              \  5 /
//                            4  \  /  6
//                         _______\/_______
//                                /\
//                            3  /  \  1
//                              / 2  \
//                             /      \
