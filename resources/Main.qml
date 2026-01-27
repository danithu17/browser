import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
import Aegis.Core 1.0

ApplicationWindow {
    id: window
    width: 1280
    height: 800
    visible: true
    title: "Aegis Privacy Browser"
    color: "#1E1E1E"

    PrivacyCore {
        id: privacyCore
        onPrivacyStatsUpdated: (msg) => {
            notificationText.text = msg
            notificationPopup.open()
        }
    }

    // --- Modern Top Bar ---
    Rectangle {
        id: topBar
        width: parent.width
        height: 60
        color: "#2C2C2C"
        z: 10

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 15

            // Navigation Controls
            Button {
                text: "←"
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "←"; color: "white"; font.pixelSize: 20 }
                onClicked: webView.goBack()
            }

            Button {
                text: "→"
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "→"; color: "white"; font.pixelSize: 20 }
                onClicked: webView.goForward()
            }

            Button {
                text: "↻"
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "↻"; color: "white"; font.pixelSize: 20 }
                onClicked: webView.reload()
            }

            // Omni-Bar (URL)
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 8
                color: "#121212"
                border.color: "#3A3A3A"

                TextInput {
                    id: urlInput
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    color: "#E0E0E0"
                    font.pixelSize: 14
                    text: webView.url
                    selectByMouse: true
                    onAccepted: {
                        var input = text.trim()
                        if (input.indexOf("http") !== 0) {
                            // Default to DuckDuckGo (De-googled search)
                            webView.url = "https://duckduckgo.com/?q=" + input
                        } else {
                            webView.url = input
                        }
                    }
                }
            }

            // Privacy Dashboard Button
            Button {
                text: "🛡️"
                background: Rectangle {
                    color: "#333333"
                    radius: 5
                }
                contentItem: Text { text: "🛡️"; color: "#00FF00"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                onClicked: privacyDrawer.open()
            }
        }
    }

    // --- Main Browser View ---
    WebEngineView {
        id: webView
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        url: "https://duckduckgo.com" // Default safe start
        backgroundColor: "#1E1E1E"
    }

    // --- Privacy Dashboard (Drawer) ---
    Drawer {
        id: privacyDrawer
        width: 300
        height: parent.height
        edge: Qt.RightEdge
        background: Rectangle { color: "#252525" }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: "Privacy Dashboard"
                color: "white"
                font.bold: true
                font.pixelSize: 22
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: "#444"
            }

            // Shield Animator
            Rectangle {
                width: 100
                height: 100
                radius: 50
                color: "transparent"
                border.color: "#00FF00"
                border.width: 3
                Layout.alignment: Qt.AlignHCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "100%"
                    color: "#00FF00"
                    font.pixelSize: 20
                }
            }

            Text {
                text: "Google Safe Browsing: ❌ Blocked\nUser Agent: 🕶️ Generic\nTracker Blocking: ✅ Active"
                color: "#AAAAAA"
                lineHeight: 1.5
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }

            Item { Layout.fillHeight: true } // Spacer

            // NUCLEAR OPTION
            Button {
                Layout.fillWidth: true
                height: 50
                background: Rectangle {
                    color: parent.down ? "#800000" : "#FF3333"
                    radius: 8
                }
                contentItem: Text {
                    text: "☢️ NUCLEAR OPTION"
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    privacyCore.nuclearOption()
                    privacyDrawer.close()
                }
            }
        }
    }

    // --- Notification Popup ---
    Popup {
        id: notificationPopup
        anchors.centerIn: parent
        width: 300
        height: 100
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle {
            color: "#333333"
            border.color: "#00FF00"
            radius: 10
        }

        Text {
            id: notificationText
            anchors.centerIn: parent
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
