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

    // --- Main Content Area ---
    Item {
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        
        // 1. Web Engine View
        WebEngineView {
            id: webView
            anchors.fill: parent
            visible: url !== "about:blank" // Hide when on new tab
            url: "about:blank" // Start empty to show home page
            backgroundColor: "#1E1E1E"
            
            onUrlChanged: {
                urlInput.text = url
            }
        }

        // 2. New Tab Page (Overlay)
        Loader {
            id: homePageLoader
            anchors.fill: parent
            visible: webView.url == "about:blank" || webView.url == ""
            source: "HomePage.qml"
            onLoaded: {
                item.onRequestSearch.connect((text) => {
                     webView.url = "https://duckduckgo.com/?q=" + text
                })
                item.onRequestUrl.connect((url) => {
                     webView.url = url
                })
            }
        }
    }

    // --- Privacy Dashboard (Drawer) ---
    Drawer {
        id: privacyDrawer
        // ... (Keep existing drawer code from previous file if possible, or fully replace)
        // Since replace_file_content replaces blocks, I will rewrite the essential drawer + Download Panel parts.
        width: 300
        height: parent.height
        edge: Qt.RightEdge
        background: Rectangle { color: "#252525" }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: "Control Center"
                color: "white"
                font.bold: true
                font.pixelSize: 22
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#444" }

            // NUCLEAR OPTION
            Button {
                Layout.fillWidth: true
                height: 50
                background: Rectangle { color: "#FF3333"; radius: 8 }
                contentItem: Text { text: "☢️ NUCLEAR WIPE"; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                onClicked: { privacyCore.nuclearOption(); privacyDrawer.close() }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#444" }

            // -- Downloads Section --
            Text { text: "Recent Downloads"; color: "#AAAAAA"; font.bold: true }

            ListView {
                id: downloadList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: ListModel { id: downloadsModel }
                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    color: "#333"
                    radius: 5
                    border.color: "#444"
                    
                    Column {
                        anchors.centerIn: parent
                        Text { text: name; color: "white"; font.pixelSize: 12 }
                        Text { text: Math.round(progress * 100) + "%"; color: "#00FF00"; font.pixelSize: 10 }
                    }
                }
            }
        }
    }
    
    // Connect C++ Download Signals to UI
    Connections {
        target: privacyCore
        function onDownloadStarted(name) {
            downloadsModel.append({ "name": name, "progress": 0 })
            notificationRef.text = "⬇️ Downloading: " + name
            notificationPopup.open()
            privacyDrawer.open() // access to downloads
        }
        function onDownloadProgress(received, total) {
             if (downloadsModel.count > 0) {
                 downloadsModel.setProperty(downloadsModel.count - 1, "progress", received/total)
             }
        }
        function onDownloadFinished(name) {
             notificationRef.text = "✅ Finished: " + name
             notificationPopup.open()
             if (downloadsModel.count > 0) {
                 downloadsModel.setProperty(downloadsModel.count - 1, "progress", 1.0)
             }
        }
    }

    // --- Notification Popup ---
    Popup {
        id: notificationPopup
        anchors.centerIn: parent
        width: 300
        height: 60
        modal: false
        closePolicy: Popup.CloseOnEscape
        background: Rectangle { color: "#333333"; border.color: "#00FF00"; radius: 10 }
        Text { id: notificationRef; anchors.centerIn: parent; color: "white" }
    }

    // --- Secure Vault Login ---
    LoginScreen {
        id: loginOverlay
    }
}

