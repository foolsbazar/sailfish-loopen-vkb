import QtQuick 2.6;

Item {
    //visible: pathData !== ""
    onPathDataChanged: {
        lastUpdate = Date.now()
        if (toggle) {
            if (!imgBusy2) {
                pathDataCache1 = pathData;
                toggle = false;
            }
        }
        else {
            if (!imgBusy1) {
                pathDataCache2 = pathData;
                toggle = true;
            }
        }
    }


    Timer {
        id:eraseTimer
        interval: 600
        repeat: false
        running: false
    }
    Timer {
        interval: 50
        repeat: true
        running: true
        onTriggered: {
            var now = Date.now()
            if (now - lastUpdate > 100) {
                paint.opacity -= baseOpacity / 4
            } else {
                paint.opacity = baseOpacity
            }
            if (paint.opacity <= 0.01){
                tempPath = ""
                pathData = ""
                pathDataCache1 = ""
                pathDataCache2 = ""
                pathVertecesX = []
                pathVertecesY = []
            }
        }
    }

    property real baseOpacity: 1
    property bool canErase: false
    property real lastUpdate: Date.now()
    property int    lineSize  : 2;
    property color  lineColor : "blue";

    property var pathVertecesX: []
    property var pathVertecesY: []
    property string tempPath: ""
    property bool modifyingPath: false
    function addPointToPath (x,y) {
        pathVertecesX.push(x)
        pathVertecesY.push(y)
        var vertecesNbr = pathVertecesX.length
        var contrPointx
        var contrPointy
        var midPointx
        var midPointy
        if (vertecesNbr > 2) {
            contrPointx = pathVertecesX[vertecesNbr-2]
            contrPointy = pathVertecesY[vertecesNbr-2]
            midPointx = contrPointx+(pathVertecesX[vertecesNbr-1]-contrPointx)/2
            midPointy = contrPointy+(pathVertecesY[vertecesNbr-1]-contrPointy)/2
            tempPath += "Q%1,%2 %3,%4".arg (contrPointx).arg (contrPointy)
                                      .arg (midPointx).arg (midPointy)
            if (!eraseTimer.running && vertecesNbr > 3) {
                pathVertecesX.splice(0,1)
                pathVertecesY.splice(0,1)
                tempPath = tempPath.slice(tempPath.indexOf("L"))
                tempPath = tempPath.slice(tempPath.indexOf("Q")+1)
                tempPath = tempPath.slice(tempPath.indexOf("Q"))
                midPointx = pathVertecesX[0]+(pathVertecesX[1]-pathVertecesX[0])/2
                midPointy = pathVertecesY[0]+(pathVertecesY[1]-pathVertecesY[0])/2
                tempPath = "M%1,%2".arg (pathVertecesX[0]).arg (pathVertecesY[0]) +
                           "L%1,%2".arg (midPointx).arg (midPointy) + tempPath
            }
        } else if (vertecesNbr === 2) {
            midPointx = pathVertecesX[0]+(pathVertecesX[1]-pathVertecesX[0])/2
            midPointy = pathVertecesY[0]+(pathVertecesY[1]-pathVertecesY[0])/2
            tempPath += "L%1,%2".arg (midPointx).arg (midPointy)
        } else {
            tempPath = "M%1,%2".arg (pathVertecesX[0]).arg (pathVertecesY[0])
            eraseTimer.restart()
        }
        pathData = tempPath
    }

    property string pathData  : "";
    property string pathDataCache1 : "";
    property string pathDataCache2 : "";

    property bool toggle   : false;
    property bool imgBusy1 : false;
    property bool imgBusy2 : false;

    Repeater {
        model: 2;
        delegate: Image {
            source: 'data:image/svg+xml,<?xml version="1.0" encoding="utf-8"?><svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="%1" height="%2"><path d="%3" fill="none" stroke="%4" stroke-width="%5" /></svg>'.arg (width).arg (height).arg (parent ["pathDataCache" + num]).arg (lineColor).arg (lineSize);
            cache: false;
            mipmap: false;
            smooth: true;
            opacity: (toggle
                      ? (model.index ? 0 : 1)
                      : (model.index ? 1 : 0));
            fillMode: Image.Pad;
            antialiasing: true;
            asynchronous: false;
            anchors.fill: parent;
            onStatusChanged: { parent ["imgBusy" + num] = (status === Image.Loading); }

            readonly property string num : (model.index +1).toString ();
        }
    }
}
