import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../sailfish-loopen-vkb"

DefaultLooPen4 {
    // Depending on the number of sectors and/or on the number of letters per arm you might
    // need a different height. Even centralItemWidth (the centra circle) can be changed
    height: centralItemWidth + 8 * characterHeight

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
    numCaption: {
                "45-left":   ["1", "8", "9", "€"],
                "45-right":  ["4", "5", "&", "$"],
                "135-left":  [";", ")", "]", "}"],
                "135-right": [":", "(", "[", "{"],
                "225-left":  ["3", "6", "7", "#"],
                "225-right": ["0", "2", "=", "/"],
                "315-left":  ["-", "*", "<", "\\"],
                "315-right": ["\"", "+", "_", ">"]
    }
    specialCaption: {
                "45-left":   ["",  " ", " ", " "],
                "45-right":  ["",  " ", " ", " "],
                "135-left":  ["",  " ", " ", " "],
                "135-right": ["",  " ", " ", " "],
                "225-left":  ["÷", "%", "|", "₹"],
                "225-right": ["@", "«", "‰", "¥"],
                "315-left":  ["&", "»", "~", "¿"],
                "315-right": ["§", "^", "°", "¡"]
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
    // Other types of alphabets will need a different accentMap
    accentMap: {
            "a": {"´": "á", "^": "â", "¨": "ä", "`": "à", "°": "å", "~": "ã"},
            "A": {"´": "Á", "^": "Â", "¨": "Ä", "`": "À", "°": "Å", "~": "Ã"},
            "e": {"´": "é", "^": "ê", "¨": "ë", "`": "è"},
            "E": {"´": "É", "^": "Ê", "¨": "Ë", "`": "È"},
            "o": {"´": "ó", "^": "ô", "¨": "ö", "`": "ò",           "~": "õ"},
            "O": {"´": "Ó", "^": "Ô", "¨": "Ö", "`": "Ò",           "~": "Õ"},
            "i": {"´": "í", "^": "î", "¨": "ï", "`": "ì"},
            "I": {"´": "Í", "^": "Î", "¨": "Ï", "`": "Ì"},
            "u": {"´": "ú", "^": "û", "¨": "ü", "`": "ù"},
            "U": {"´": "Ú", "^": "Û", "¨": "Ü", "`": "Ù"},
            "y": {"´": "ý",           "¨": "ÿ"},
            "Y": {"´": "Ý",           "¨": "Ϋ"},
            "n": {                                                  "~": "ñ"},
            "N": {                                                  "~": "Ñ"},
            "c": {"¸": "ç"},
            "C": {"¸": "Ç"}
    }
    emojiCaption: {
                "45-left":   ["😳", "😱", "😰", "😭"],
                "45-right":  ["👏", "👎", "🙏", "🏎"],
                "135-left":  ["🙈", "🙊", "🔝", "😄"],
                "135-right": ["😚", "😘", "😜", "😏"],
                "225-left":  ["👊", "👋", "😩", "☹"],
                "225-right": ["😂", "😃", "☺", "😝"],
                "315-left":  ["❤", "😊", "😉", "😅"],
                "315-right": ["👍", "💪", "😞", "😫"]
    }
    emoji2Caption: {
                "45-left":   ["😳", "😱", "😰", "😭"],
                "45-right":  ["👏", "👎", "🙏", "🏎"],
                "135-left":  ["🙈", "🙊", "🔝", "😄"],
                "135-right": ["😚", "😘", "😜", "😏"],
                "225-left":  ["👊", "👋", "😩", "☹"],
                "225-right": ["😂", "😃", "☺", "😝"],
                "315-left":  ["❤", "😊", "😉", "😅"],
                "315-right": ["👍", "💪", "😞", "😫"]
    }
    sectorOptions: [
        ["accent"   ,"backspace","symbol" ,"space"      ],
        ["downArrow","leftArrow","upArrow","rightArrow",]
    ]
    // Firts line for the sectorFunction activated with a single swipe
    // Second line refer to sectors seen as a botton
    //    Possible cases:
    //    "space"
    //    "backspace"
    //    "shift"
    //    "symbol"
    //    "accent"
    //    "emoji"
    //    "enter"            Enter charcter (\n), but no enter key function -- meant for typing only
    //    "enterKey"         Enter charcter (\n), works as the enter key -- meant for substitute enterKey
    //    "leftArrow"
    //    "rightArrow"
    //    "upArrow"
    //    "downArrow"

}
// Sectors order is strictly dependent on the angles order.
// Frist sector is the one after the first angle. Angles are clockwise in contrary as in standard trigonometry.
// For instance, as the two 8pen and loopen are defined the sectors order is the following
//                \      /                              \      /
//                 \  3 /                                \  5 /
//                  \  /                               4  \  /  6
//                   \/   4                         _______\/_______
//               2   /\                                    /\
//                  /  \                               3  /  \  1
//                 / 1  \                                / 2  \
//                /      \                              /      \
