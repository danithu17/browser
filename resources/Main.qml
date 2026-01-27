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
        height: 70
        color: "#2C2C2C"
        z: 10

        // Simulated Tab Bar (Since multi-tab is complex for basic steps)
        RowLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            spacing: 5
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 200
                height: 30
                color: "#1E1E1E"
                radius: 10
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    Image {
                        source: "qrc:/assets/logo.png"
                        sourceSize: Qt.size(16, 16)
                    }
                    Text {
                        text: webView.title || "New Tab"
                        color: "white"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: "✖"
                        color: "gray"
                        font.pixelSize: 10
                    }
                }
            }
            // Add Tab Button
            Rectangle {
                width: 30
                height: 30
                color: "transparent"
                Text { anchors.centerIn: parent; text: "+"; color: "white"; font.pixelSize: 18 }
            }
            Item { Layout.fillWidth: true } // Spacer
        }

        // URL Bar & Controls
        RowLayout {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5
            spacing: 15
            height: 35

            // Navigation Controls
            Button {
                padding: 5
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "←"; color: enabled ? "white" : "gray"; font.pixelSize: 20 }
                onClicked: webView.goBack()
                enabled: webView.canGoBack
            }

            Button {
                padding: 5
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "→"; color: enabled ? "white" : "gray"; font.pixelSize: 20 }
                onClicked: webView.goForward()
                enabled: webView.canGoForward
            }

            Button {
                padding: 5
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "↻"; color: "white"; font.pixelSize: 20 }
                onClicked: webView.reload()
            }

            // Omni-Bar (URL)
            Rectangle {
                Layout.fillWidth: true
                height: 32
                radius: 16
                color: "#121212"
                border.color: "#333"

                TextInput {
                    id: urlInput
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    verticalAlignment: Text.AlignVCenter
                    color: "#E0E0E0"
                    font.pixelSize: 13
                    text: webView.url == "about:blank" ? "" : webView.url
                    selectByMouse: true
                    onAccepted: {
                        var input = text.trim()
                        if (input.indexOf("http") === 0) {
                            webView.url = input
                        } else if (input.indexOf(".") > 0 && input.indexOf(" ") === -1) {
                            webView.url = "https://" + input
                        } else {
                            // Default to Google Search
                            webView.url = "https://www.google.com/search?q=" + encodeURIComponent(input)
                        }
                    }
                }
            }

            // Icons: Brave-like Shield & Menu
            Button {
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "🦁"; color: "orange"; font.pixelSize: 20 } // Shield Icon visual
                onClicked: notificationPopup.open()
                ToolTip.visible: hovered
                ToolTip.text: "Aegis Shields UP"
            }

            Button {
                background: Rectangle { color: "transparent" }
                contentItem: Text { text: "≡"; color: "white"; font.pixelSize: 20 }
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
        url: "https://www.google.com" // Default to Google
        backgroundColor: "#1E1E1E"
        
        onUrlChanged: {
            urlInput.text = url
        }
        
        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadStarted) {
                // Show loading indicator logic here
            }
        }
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
