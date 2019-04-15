// Copyright (C) 2013 Jolla Ltd.
// Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>

import QtQuick 2.0
import com.meego.maliitquick 1.0
import Sailfish.Silica 1.0
import com.jolla.keyboard 1.0
import org.nemomobile.configuration 1.0
import org.nemomobile.systemsettings 1.0
import ".."

Item {
    id: keyboardLayout
    width: parent ? parent.width : 0
    height: topItemOffset + rowHeight //centralItemWidth + 8 * characterHeight
    property int characterHeight: Theme.fontSizeMedium
    property int characterDiagonal: characterHeight * 1.1
    property alias centralItemWidth: centerDot.width
    property alias rowHeight: bigRow.height

    property string type
    property bool portraitMode
    property int keyHeight
    property int punctuationKeyWidth
    property int punctuationKeyWidthNarrow
    property int shiftKeyWidth
    property int functionKeyWidth
    property int shiftKeyWidthNarrow
    property int symbolKeyWidthNarrow
    property QtObject attributes: visible ? keyboard : keyboard.nextLayoutAttributes
    property string languageCode
    property string inputMode
    property int avoidanceWidth
    property bool splitActive
    property bool splitSupported
    property bool useTopItem: (keyboard.inputHandler.preedit !== undefined)
    property bool capsLockSupported: true
    property int layoutIndex: -1
    property bool allowSwipeGesture: true
    property bool isLandscape

    property real topItemOffset: useTopItem ? Theme.itemSizeSmall : 0

    signal flashLanguageIndicator()

    property var accentMap: ({})

    property var moveSerie: []
    property var fullMoveSerie: []

    property bool accentActive: false
    property bool emojiActive: false
    property bool wasShifted: false
    property var centerLetterMove: accentActive ? accentCaption :
                                       emojiActive ? (attributes.inSymView2 ? emoji2Caption : emojiCaption) :
                                           attributes.inSymView ? (attributes.inSymView2 ? specialCaption : numCaption) :
                                               ((attributes.isShifted || wasShifted) !== capitalMove ) ? capitalCaptions : letterCaptions

    property var armLength: { //num of chars in a sector arm
        var arms = Object.keys(centerLetterMove)
        return centerLetterMove[arms[0]].length
    }
    property var letterCaptions: ({})
    property var capitalCaptions: ({})
    property var numCaption:({})
    property var specialCaption:({})
    property var accentCaption:({})
    property var emojiCaption:({})
    property var emoji2Caption:({})
    property var sectorOptions:[]

    property string selection: ""
    property bool capitalMove: false
    property int selectionNumber: -1
    property bool allowSwipingFunction: false
    property bool committed: false
    property string lastCommited: ""
    property string lastAccentMerge: ""

    Component.onCompleted: {
        updateSizes()
        if (!componentSearchCompleted) searchParentsChild()
    }
    onWidthChanged: updateSizes()
    onPortraitModeChanged: updateSizes()
    onVisibleChanged: {
        if (!componentSearchCompleted) searchParentsChild()
        accentActive = false
        emojiActive = false
        wasShifted = false
    }

    ConfigurationValue {
        id: useMouseEvents
        key: "/sailfish/text_input/use_mouse_events"
        defaultValue: false
    }
    ConfigurationValue {
        id: commitSpaceAfterRelease
        key: "/apps/sailfish-loopen-vkb/commitSpaceAfterRelease"
        defaultValue: false
    }
    property bool isLoopen: true
    property Item languageSelectionItem
    property Item childToBeDisabled
    property bool componentSearchCompleted: false
    function searchParentsChild(){
        // Hack to find child MultiPointTouchArea of KeybardBase{}
        var multiPointTouchArea_idx = -1
        var languageSelectionPopup_idx = -1
        for (var i=0; i<keyboard.children.length; ++i){
         // seaching for the child 'MultiPointTouchArea' by looking at all the properties a MultiPointTouchArea has
         if ( (keyboard.children[i].maximumTouchPoints !== undefined) && (keyboard.children[i].minimumTouchPoints !== undefined) &&
                    (keyboard.children[i].mouseEnabled !== undefined) && (keyboard.children[i].touchPoints !== undefined))
             multiPointTouchArea_idx = i;
         // seaching for the child 'LanguageSelectionPopup'
         if ( (keyboard.children[i].activeCell !== undefined) && (keyboard.children[i].inInitialPosition !== undefined) &&
                    (keyboard.children[i].pointId !== undefined) && (keyboard.children[i].opening !== undefined))
             languageSelectionPopup_idx = i;
        }
        if (languageSelectionPopup_idx != -1) languageSelectionItem = keyboard.children[languageSelectionPopup_idx]
        if (multiPointTouchArea_idx != -1) childToBeDisabled = keyboard.children[multiPointTouchArea_idx]
        if (multiPointTouchArea_idx !== -1 && languageSelectionPopup_idx !== -1){
            componentSearchCompleted = true
            console.info('Conponents research executed')
        }
    }
    states: State {
        name: "swipeProtectedArea"
        PropertyChanges {
            target: keyboard
            swipeEnabled: false
        }
        PropertyChanges {
            target: childToBeDisabled
            enabled: keyboard.layout.isLooop === undefined
        }
    }

    property real xCenter: centerDot.x + centerDot.width / 2
    property real yCenter: centerDot.y + centerDot.height / 2

    property var branchAngles: {
        var ret = []
        var keys = Object.keys(centerLetterMove)
        for (var i = 0; i < keys.length; i++) {
            var angle = parseInt(keys[i].split("-")[0])
            if (ret.indexOf(angle) === -1) {
                for (var j = 0; j < ret.length; j++) {
                    if (ret[j] > angle) {
                        ret.splice(j,0,angle)
                        break
                    }
                }
                if (ret.indexOf(angle) === -1) {
                    ret.push(angle)
                }
            }
        }
        return ret
    }

    Loader {
        // Expose "keyboardLayout" to the context of the loaded TopItem
        readonly property Item keyboardLayout: keyboardLayout

        active: useTopItem && (layoutIndex >= 0)
        // sourceComponent is evaluated even when active is false, so we need the ternary operator here
        sourceComponent: active ? keyboard.getInputHandler(keyboardLayout).topItem : null
        width: parent.width
        visible: active
        clip: keyboard.transitionRunning
        asynchronous: false
        opacity: (canvas.activeIndex === keyboardLayout.layoutIndex) ? 1.0 : 0.0
        Behavior on opacity { FadeAnimator {}}
    }

    Row {
        id: bigRow
        y: topItemOffset
        width: parent.width
        Column {
            id:spacerColumn
            width: functionKeyWidth / 2.5
            Item {
                id: pasteContainer
                width: parent.width
                height: pasteIcon.height
                PasteButtonPersonal {
                    id: pasteItem
                    enabled: !useTopItem
                    width: pasteIcon.width
                    height: pasteIcon.height
                    Image {
                        id: pasteIcon
                        visible: !useTopItem
                        anchors.centerIn: parent
                        source: "image://theme/icon-m-clipboard"
                                + (pasteItem.highlighted ? ("?" + Theme.highlightColor) : Clipboard.hasText ? ("?" + Theme.highlightBackgroundColor) : "")
                    }
                }
            }
            Item {
                id: spacer
                width: parent.width
                height: keyboardLayout.height - pasteContainer.height - buttonForSpaceAfterRealease.height - topItemOffset
            }
            Item {
                width: parent.width
                height: width * 2.5 / 2
                BackgroundItem {
                    id: buttonForSpaceAfterRealease
                    anchors.fill: parent
                    property bool activated: commitSpaceAfterRelease.value
                    onClicked: {
                        commitSpaceAfterRelease.value = !activated
                        commitSpaceAfterRelease.sync()
                    }
                    Image {
                        anchors.centerIn: parent
                        source: "image://theme/icon-s-task" + (buttonForSpaceAfterRealease.highlighted ? ("?" + Theme.highlightColor) : "")
                        opacity: commitSpaceAfterRelease.value ? 1 : 0.35
                    }
                    Image {
                        anchors.centerIn: parent
                        source: "image://theme/icon-uninstall-app" + (buttonForSpaceAfterRealease.highlighted ? ("?" + Theme.highlightColor) : "")
                        visible: !commitSpaceAfterRelease.value
                    }
                }
            }
        }
        Item {
            id: centralArea
            width: keyboardLayout.width - spacerColumn.width - functionKeyWidth
            height: parent.height
            Rectangle {
                id: centerDot
                anchors.centerIn: parent
                width: portraitMode ? ((Theme.itemSizeLarge+Theme.itemSizeExtraLarge)/2) * (1+(branchAngles.length - 4)/8.5)  + characterDiagonal * 0.4 :
                                      Theme.itemSizeMedium + characterHeight * 0.4
                height: width
                color: selection === "-1" ? Theme.highlightBackgroundColor : Theme.primaryColor
                opacity: selection === "-1" ? 0.6 : 0.07
                radius: width / 2
            }
            Repeater {
                id: niceSeparator
                model: branchAngles
                delegate: Image {
                    source: "../graphic-keyboard-highlight-top.png"
                    x: centerDot.x + centerDot.radius - width/2
                    y: centerDot.y + centerDot.height + 0.1 * characterDiagonal
                    transform: Rotation{origin.x: width/2; origin.y: - centerDot.radius - 0.1 * characterDiagonal; angle: modelData-90}
                    // should scale based on pixel density
                    width: geometry.scaleRatio >= 2 ? 2 : 1
                    height: parent.height/2 - centerDot.height/2
                    fillMode: Image.TileHorizontally// Math.abs(angles/90) === 1 ? Image.TileVertically :
                }
            }

            Text {
                id: textField
                anchors.centerIn: centerDot
                width: centerDot.width / 2
                height: centerDot.height / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: languageCode
                color: Theme.primaryColor
                opacity: 0.4
                font.pixelSize: Theme.fontSizeSmall
                fontSizeMode: Text.Fit
            }

            Timer {
                id: languageSwitchTimer
                interval: 1000
                onTriggered: {
                    var point = new Object
                    point.pointId = 1
                    point.x = xCenter
                    point.y = yCenter - topItemOffset
                    point.startX = xCenter
                    point.startY = yCenter - topItemOffset
                    point.pressedKey = centerDot
                    point.initialKey = null
                    languageSelectionItem.show(point)
                }
            }

            Repeater {
                id: sectorsDesign
                model: Object.keys(centerLetterMove)
                delegate: Item {
                    id: branch
                    anchors.centerIn: centerDot;
                    property string  key: modelData
                    property real angle: (parseInt (key.split ("-") [0].toString ()) * Math.PI / 180)
                    property real sin: Math.sin(angle)
                    property real cos: Math.cos(angle)
                    property int side: (key.indexOf("left") !== -1 ? -1 : 1)
                    property bool selected: selection !== "-1" && selection !== "-2"
                                            && (selection.indexOf("-") !== -1
                                                ? selection === key
                                                : (key.indexOf("right") !== -1
                                                   ? keyboardLayout.branchAngles[parseInt(selection)] === parseInt (key.split("-")[0])
                                                   : keyboardLayout.branchAngles[(parseInt(selection) + 1) % keyboardLayout.branchAngles.length] === parseInt (key.split("-")[0])))

                    Repeater {
                        model: centerLetterMove[key]
                        delegate: Item {
                            width: 1
                            height: 1
                            anchors {
                                centerIn: parent;
                                horizontalCenterOffset: (branch.cos * radius) - characterHeight * 0.55 * side * branch.sin
                                verticalCenterOffset:   (branch.sin * radius) + characterHeight * 0.55 * side * branch.cos
                            }

                            readonly property real radius : (centerDot.radius + (model.index + 0.55) * characterDiagonal);

                            Text {
                                id: charText
                                anchors.verticalCenter: parent.top
                                anchors.horizontalCenter: parent.left
                                text: modelData
                                font.family: Theme.fontFamily
                                font.bold: branch.selected && selectionNumber === index ? true : false
                                font.pixelSize: characterHeight
                                color: branch.selected ? Theme.highlightColor : Theme.primaryColor
                            }
                        }
                    }
                }
            }

            MultiPointTouchArea {
                id: swipingArea
                anchors.fill: parent
                maximumTouchPoints: 1
                enabled: keyboardLayout.visible && !useMouseEvents.value && keyboardLayout.componentSearchCompleted

                onPressed: keyboardLayout._handlePressed(touchPoints)
                onUpdated: keyboardLayout._handleUpdated(touchPoints)
                onReleased: keyboardLayout._handleReleased(touchPoints)
            }

        }
        Column {
            height: parent.height
            width: functionKeyWidth

            property int nbrItem: 4

            SymbolKey {
                visible: !useTopItem
                id: symbolKey
                height: parent.height / parent.nbrItem
                implicitWidth: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                caption: emojiActive ? "☺" : attributes.inSymView ? symbolCaption : "?123"
                property bool emojiActivated: false
                MultiPointTouchArea {
                    anchors.fill: symbolKey
                    maximumTouchPoints: 1
                    onPressed: {
                        symbolKey.pressed = true
                        if (!emojiActive) emojiTimer.start()
                        buttonPressEffect.play()
                        SampleCache.play("/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav")
                        symbolKey.emojiActivated = false
                    }
                    onReleased: {
                        if (!keyboard.gestureInProgress && !layoutRow.transitionRunning){
                            if (!symbolKey.emojiActivated) {
                                symbolKey.clicked()
                                emojiActive = false
                            }
                        }
                        emojiTimer.stop()
                        symbolKey.pressed = false
                        accentActive = false
                    }
                }
            }
            Timer {
                id: emojiTimer
                repeat: false
                interval: 600
                onTriggered: {
                    if (!keyboard.gestureInProgress && !layoutRow.transitionRunning){
                        symbolKey.clicked()
                        accentActive = false
                        emojiActive = true
                        symbolKey.emojiActivated = emojiActive
                        if (!attributes.inSymView)
                            symbolKey.clicked()
                    }
                }
            }
            FunctionKey {
                id:backspaceKey
                icon.source: "image://theme/icon-m-backspace" + (pressed ? ("?" + Theme.highlightColor) : "")
                repeat: true
                key: Qt.Key_Backspace
                height: parent.height / parent.nbrItem
                implicitWidth: parent.width
                background.visible: false
                anchors.horizontalCenter: parent.horizontalCenter

                MultiPointTouchArea {
                    anchors.fill: backspaceKey
                    maximumTouchPoints: 1
                    onPressed: {
                        backspaceKey.pressed = true
                        startAutorepeatTimer.start()
                        buttonPressEffect.play()
                        SampleCache.play("/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav")
                    }

                    onReleased: {
                        backspaceKey.pressed = false
                        accentActive = false
                        moveSerie = []
                        if (startAutorepeatTimer.running) {
                            startAutorepeatTimer.stop()
                            backspaceFunction()
                        }
                    }
                }

                Timer {
                    // adding a second timer solved a problem with the backspace button (it was too easy to produce double click)
                    id: startAutorepeatTimer
                    repeat: false
                    interval: 350

                    onTriggered: {
                        if (backspaceKey.pressed) {
                            autorepeatTimer.start()
                        } else {
                            moveSerie = []
                        }
                    }
                }

                Timer {
                    id: autorepeatTimer
                    repeat: true
                    interval: 70

                    onTriggered: {
                        if (!keyboard.gestureInProgress && !layoutRow.transitionRunning){
                            if (backspaceKey.pressed) {
                                backspaceFunction()
                            } else {
                                stop()
                                moveSerie = []
                            }
                        }
                    }
                }
            }

            ShiftKey {
                id: shiftKey
                height: parent.height / parent.nbrItem
                implicitWidth: shiftKeyWidth * 1.5
                anchors.horizontalCenter: parent.horizontalCenter
                property bool pressed_: false
                icon.source: attributes.inSymView ? ""
                                                  : ((attributes.isShifted || pressed_) && !attributes.isShiftLocked  ? "image://theme/icon-m-autocaps"
                                                                                                       : "image://theme/icon-m-capslock")
                                                  + (pressed_ ? ("?" + Theme.highlightColor) : "")
                MultiPointTouchArea {
                    anchors.fill: shiftKey
                    maximumTouchPoints: 1
                    onPressed: {
                        shiftKey.pressed_ = true
                        keyboard.inputHandler._handleKeyPress(shiftKey)
                        buttonPressEffect.play()
                        SampleCache.play("/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav")
                    }
                    onReleased: {
                        if (!keyboard.gestureInProgress && !layoutRow.transitionRunning)
                            shiftKey.clicked()
                        keyboard.inputHandler._handleKeyRelease(shiftKey)
                        shiftKey.pressed_ = false
                    }
                }
            }

            SymbolKey {
                visible: useTopItem
                height: parent.height / parent.nbrItem
                implicitWidth: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                caption: emojiActive ? "☺" : attributes.inSymView ? symbolCaption : "?123"
                MultiPointTouchArea {
                    anchors.fill: parent
                    maximumTouchPoints: 1
                    onPressed: {
                        parent.pressed = true
                        if (!emojiActive) emojiTimer.start()
                        buttonPressEffect.play()
                        SampleCache.play("/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav")
                        symbolKey.emojiActivated = false
                    }
                    onReleased: {
                        if (!keyboard.gestureInProgress && !layoutRow.transitionRunning){
                            if (!symbolKey.emojiActivated) {
                                symbolKey.clicked()
                                emojiActive = false
                            }
                        }
                        emojiTimer.stop()
                        parent.pressed = false
                        accentActive = false
                    }
                }
            }
            FunctionKey {
                id: enterKey
                icon.source: MInputMethodQuick.actionKeyOverride.icon
                caption:  MInputMethodQuick.actionKeyOverride.label
                key: Qt.Key_Return
                enabled: MInputMethodQuick.actionKeyOverride.enabled
                background.opacity: pressed ? 0.6 : MInputMethodQuick.actionKeyOverride.highlighted ? 0.4 : 0.17
                height: parent.height / parent.nbrItem
                implicitWidth: parent.width
                background.visible: true
                anchors.horizontalCenter: parent.horizontalCenter

                MultiPointTouchArea {
                    anchors.fill: enterKey
                    maximumTouchPoints: 1
                    onPressed: {
                        enterKey.pressed = true
                        buttonPressEffect.play()
                        SampleCache.play("/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav")
                    }

                    onReleased: {
                        if (!keyboard.gestureInProgress && !layoutRow.transitionRunning)
                            keyboard.inputHandler._handleKeyClick(enterKey)
                        enterKey.pressed = false
                        accentActive = false
                        moveSerie = []
                    }
                }
            }
        }
    }

    Timer {
        // This allows to not commit a letter in each sector when swiping is fast.
        // The input will be processed only if you stop in a sector for a while.
        id: fastSwipingTimer
        interval: 300
        repeat: false
        onTriggered: {
            processInput()
            //committed = true
        }
    }

    Paint {
        id: paint
        anchors.fill: parent
        lineColor: Theme.primaryColor
        lineSize: Theme.iconSizeExtraSmall/5
        baseOpacity: 0.2
    }

    function _handlePressed(touchPoints) {
        // Disable swiping between layouts
        keyboardLayout.state = "swipeProtectedArea"

        allowSwipingFunction = false
        sectorSymbolActivated = false
        moveSerie = []
        fullMoveSerie = []
        var touchpoint = touchPoints[0]
        var pos = getPos(touchpoint.x, touchpoint.y)
        pushMove(pos)
        evaluateSelection()
        paint.pathVertecesX = []
        paint.pathVertecesY = []
        paint.addPointToPath(Math.round(touchpoint.x + centralArea.x),Math.round(touchpoint.y+topItemOffset))
        if (pos === -1)
            languageSwitchTimer.start()
    }
    property bool lettersAreOver: false
    property bool sectorSymbolActivated: false
    function _handleUpdated(touchPoints) {
        var touchpoint = touchPoints[0]
        if (languageSelectionItem.visible) {
            var point = new Object
            point.pointId = 1
            point.x = touchpoint.x
            point.y = touchpoint.y - topItemOffset
            point.startX = xCenter
            point.startY = yCenter - topItemOffset
            point.pressedKey = centerDot
            point.initialKey = null
            languageSelectionItem.handleMove(point)
            return
        }
        var pos = getPos(touchpoint.x, touchpoint.y)
        if (pos !== moveSerie[moveSerie.length - 1]) {
            fastSwipingTimer.stop()
            var startIdx = (capitalMove ? 0 : 1)
            if (moveSerie.length > 1 && pos === moveSerie[moveSerie.length - 2] && !lettersAreOver) {
                moveSerie.splice(-1,1)
                if (moveSerie.length !== startIdx + 1 && pos !== -1){ // going back need to erase and rewrite
                    backspaceFunction()
                    processInput()
                } else if ( pos !== -1 ) { // unless you're back in the first sector, where you don't have to rewrite
                    backspaceFunction()
                } else if (fullMoveSerie.length >= 2 && fullMoveSerie[fullMoveSerie.length -2] === -1){ // or when you're back in the center
                    if (allowSwipingFunction){
                        sectorsFuntion(fullMoveSerie[fullMoveSerie.length -1],0)
                        allowSwipingFunction = false
                    }
                }
                fullMoveSerie.push(pos)
                playSound(pos)
            } else {
                if (pos === -1) {
                    if (!committed)
                        processInput()
                    wasShifted = false
                    committed = false
                    accentActive = false
                    allowSwipingFunction = false
                    if (attributes.inSymView && sectorSymbolActivated)
                        symbolKey.clicked()
                    sectorSymbolActivated = false
                    moveSerie = []
                    pushMove(pos)
                } else {
                    // this allows to write the letters while selecting them
                    if (moveSerie.length < startIdx + 1 + armLength) {
                        pushMove(pos)
                        if (moveSerie.length !== startIdx + 1) {
                            if (committed){
                                if (moveSerie.length !== startIdx + 2) {
                                    backspaceFunction()
                                }
                                processInput()
                            } else fastSwipingTimer.restart()
                        }
                    } else {// The arm has finished the letters
                        if(!committed){
                            processInput()
                            //committed=true
                        }
                        lettersAreOver = true
                    }
                }
            }
        } else lettersAreOver = false
        evaluateSelection()
        paint.addPointToPath(Math.round(touchpoint.x + centralArea.x),Math.round(touchpoint.y+topItemOffset))
    }

    function _handleReleased(touchPoints) {        
        var touchpoint = touchPoints[0]
        paint.addPointToPath(Math.round(touchpoint.x + centralArea.x),Math.round(touchpoint.y+topItemOffset))

        if (languageSelectionItem.visible) {
            canvas.switchLayout(languageSelectionItem.activeCell)
            languageSelectionItem.hide()
        } else if (fullMoveSerie.length === 1) {
            // allows the usage of sectors as buttons
            if (moveSerie[0] === -1) {
                spaceFuntion()
                playSound(-10)
                accentActive = false
            } else sectorsFuntion(moveSerie[0],1)
        }

        fastSwipingTimer.stop()
        if (!committed)
            processInput()

        if (moveSerie[moveSerie.length - 1] === -1) {
            if (commitSpaceAfterRelease.value && fullMoveSerie.length > 2)
                spaceFuntion()
            accentActive = false
            if (attributes.inSymView && emojiActive)
                symbolKey.clicked()
            emojiActive = false
        }

        wasShifted = false
        committed = false
        keyboard.applyAutocaps()
        moveSerie = []
        fullMoveSerie = []
        evaluateSelection()
        languageSwitchTimer.stop()

        // Enable again swiping between layouts
        keyboardLayout.state = ""
    }

    function pushMove(pos) {
        languageSwitchTimer.stop()
        moveSerie.push(pos)
        fullMoveSerie.push(pos)
        playSound(pos)
    }
    function playSound(pos) {
        if ( pos !== fullMoveSerie[fullMoveSerie.length -2] &&
                ( pos === -1 || fullMoveSerie[fullMoveSerie.length -2] === -1 ) &&
                    fullMoveSerie.length > 1 ) {
            buttonPressEffect.play()
            SampleCache.play("/usr/share/sounds/jolla-ambient/stereo/keyboard_letter.wav")
        }
    }

    function processInput() {
        if (keyboard.isShifted)
            wasShifted = true
        var letter = ""
        var startIdx = (capitalMove ? 0 : 1)
        if ((moveSerie.length >= 3 && moveSerie[0] === -1) || (moveSerie.length >= 2 && moveSerie[0] !== -1)) {
            var direction = moveSerie[startIdx + 1] === (moveSerie[startIdx] + 1) % branchAngles.length ? "left" : "right"
            var branchAngle = branchAngles[(direction === "left" ? (moveSerie[startIdx] + 1) : moveSerie[startIdx]) % branchAngles.length]
            var branchKey = branchAngle + "-" + direction
            var branch = centerLetterMove[branchKey]
            letter = branch[(moveSerie.length - (2 + startIdx)) % 4]
        }
        commitText(letter)
        if (letter !== "")
            committed = true
    }

    function commitText(text) {
        inputKey.text=text
        var previousChar
        if (keyboard.inputHandler.preedit !== undefined && keyboard.inputHandler.preedit !== "")
            previousChar = keyboard.inputHandler.preedit[keyboard.inputHandler.preedit.length -1]
        else
            previousChar = MInputMethodQuick.surroundingText.charAt(MInputMethodQuick.cursorPosition - 1)
        var merge
        if (previousChar in accentMap && inputKey.text in accentMap[previousChar]) {
            merge = accentMap[previousChar][inputKey.text]
            lastAccentMerge = previousChar //+ inputKey.text
            keyboard.inputHandler._handleKeyClick(backspaceKey)
            inputKey.text = merge
        } else if (previousChar === "" && lastCommited in accentMap && inputKey.text in accentMap[lastCommited]) {
            merge = accentMap[lastCommited][inputKey.text]
            lastAccentMerge = lastCommited //+ inputKey.text
            keyboard.inputHandler._handleKeyClick(backspaceKey)
            inputKey.text = merge
        } else {
            lastCommited = inputKey.text
            lastAccentMerge = ""
        }
        keyboard.inputHandler._handleKeyClick(inputKey)
        keyboard.inputHandler._handleKeyRelease(inputKey)
    }

    KeyBase {
        id: inputKey
        keyType: KeyType.PopupKey
    }
    function backspaceFunction() {
        keyboard.inputHandler._handleKeyClick(backspaceKey)
        if (lastAccentMerge !== "") {
            inputKey.text = lastAccentMerge
            keyboard.inputHandler._handleKeyClick(inputKey)
            lastCommited = lastAccentMerge
            lastAccentMerge = ""
        }
    }
    function spaceFuntion() {
        inputKey.key = Qt.Key_Space
        commitText(" ")
        inputKey.key = Qt.Key_unknown
    }

    function getPos(x, y) {
        var xDistFromCenter = x - xCenter
        var yDistFromCenter = y - yCenter
        var distFromCenter = Math.sqrt(Math.pow(xDistFromCenter,2)+Math.pow(yDistFromCenter,2))

        if (distFromCenter <= centerDot.radius)
            return -1
        else if (distFromCenter >= centerDot.radius + characterDiagonal)
            allowSwipingFunction = true

        var rad = Math.atan2(yDistFromCenter, xDistFromCenter);
        var angle = (rad * (180 / Math.PI) + 360) % 360
        for (var i = 0; i < branchAngles.length; i++) {
            if (branchAngles[i] > angle) {
                return (i + branchAngles.length - 1) % branchAngles.length
            }
        }
        return (i - 1) % branchAngles.length
    }

    function evaluateSelection () {
        if (moveSerie.length === 1) {
            selection = moveSerie[0]
            selectionNumber = -1
        } else if (moveSerie[0] === -1 && moveSerie.length === 2) {
            selection = moveSerie[1]
            selectionNumber = -1
        } else if (moveSerie.length > 1) {
            var startIndex = 0
            if (moveSerie[0] === -1)
                startIndex = 1
            var direction = moveSerie[1 + startIndex] === (moveSerie[startIndex] + 1) % branchAngles.length ? "left" : "right"
            var branchAngle = branchAngles[(direction === "left" ? (moveSerie[startIndex] + 1) : moveSerie[startIndex]) % branchAngles.length]
            selection = branchAngle + "-" + direction
            selectionNumber = moveSerie.length - startIndex - 2
        } else {
            selection = -2
            selectionNumber = -1
        }
        if (moveSerie.length < 1 || moveSerie[0] === -1) {
            capitalMove = false
        } else {
            capitalMove = true
        }
    }

    function sectorsFuntion(sector,type) {
        // type is equal to 0 for the swipe gesture
        // and equal to 1 for the button gesture
        if (sectorOptions[type][sector] === "") {
            // in case using a particular sector as function is not activated, return immidiately
            return
        }
        switch(sectorOptions[type][sector]) {
        case "space":
            spaceFuntion()
            break;
        case "backspace":
            backspaceFunction()
            break;
        case "symbol":
            symbolKey.clicked()
            emojiActive = false
            sectorSymbolActivated = true
            break;
        case "shift":
            shiftKey.clicked()
            break;
        case "accent":
            accentActive = !accentActive
            break;
        case "emoji":
            symbolKey.clicked()
            emojiActive = !emojiActive
            break;
        case "enter":
            commitText("\n")
            break;
        case "enterKey":
            keyboard.inputHandler._handleKeyClick(enterKey)
            break;
        case "leftArrow":
            spaceFuntion()
            MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)
            MInputMethodQuick.sendKey(Qt.Key_Left, 0, "", Maliit.KeyClick)
            break;
        case "rightArrow":
            spaceFuntion()
            MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)
            MInputMethodQuick.sendKey(Qt.Key_Right, 0, "", Maliit.KeyClick)
            break;
        case "upArrow":
            spaceFuntion()
            MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)
            MInputMethodQuick.sendKey(Qt.Key_Up, 0, "", Maliit.KeyClick)
            break;
        case "downArrow":
            spaceFuntion()
            MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)
            MInputMethodQuick.sendKey(Qt.Key_Down, 0, "", Maliit.KeyClick)
            break;
        default:
            console.info("Sorry, option '"+sectorOptions[type][sector]+"' is not listed")
            break;
        }
        return
    }

    Connections {
        target: keyboard
        onSplitEnabledChanged: updateSizes()
        onCharacterKeyCounterChanged: keyboard.characterKeyCounter = 0
    }

    Binding on portraitMode {
        when: MInputMethodQuick.active
        value: keyboard.portraitMode
    }

    Connections {
        target: MInputMethodQuick
        onActiveChanged: {
            if (MInputMethodQuick.active) {
                accentActive = false
                emojiActive = false
                wasShifted = false
            }
        }

    }
    function updateSizes () {
        if (width === 0) {
            return
        }

        if (portraitMode) {
            isLandscape = false
            keyHeight = geometry.keyHeightPortrait
            punctuationKeyWidth = geometry.punctuationKeyPortait
            punctuationKeyWidthNarrow = geometry.punctuationKeyPortraitNarrow
            shiftKeyWidth = geometry.shiftKeyWidthPortrait
            functionKeyWidth = geometry.functionKeyWidthPortrait
            shiftKeyWidthNarrow = geometry.shiftKeyWidthPortraitNarrow
            symbolKeyWidthNarrow = geometry.symbolKeyWidthPortraitNarrow
            avoidanceWidth = 0
            splitActive = false
        } else {
            isLandscape = true
            keyHeight = geometry.keyHeightLandscape
            punctuationKeyWidth = geometry.punctuationKeyLandscape
            punctuationKeyWidthNarrow = geometry.punctuationKeyLandscapeNarrow
            functionKeyWidth = geometry.functionKeyWidthLandscape

            var shouldSplit = keyboard.splitEnabled && splitSupported
            if (shouldSplit) {
                avoidanceWidth = geometry.middleBarWidth
                shiftKeyWidth = geometry.shiftKeyWidthLandscapeSplit
                shiftKeyWidthNarrow = geometry.shiftKeyWidthLandscapeSplit
                symbolKeyWidthNarrow = geometry.symbolKeyWidthLandscapeNarrowSplit
            } else {
                avoidanceWidth = 0
                shiftKeyWidth = geometry.shiftKeyWidthLandscape
                shiftKeyWidthNarrow = geometry.shiftKeyWidthLandscapeNarrow
                symbolKeyWidthNarrow = geometry.symbolKeyWidthLandscapeNarrow
            }
            splitActive = shouldSplit
        }
    }

}
