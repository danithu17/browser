import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#1E1E1E"
    anchors.fill: parent

    signal requestSearch(string text)
    signal requestUrl(string url)

    // Background Gradient (Cyberpunk Style)
    Gradient {
        id: bgGradient
        GradientStop { position: 0.0; color: "#000000" }
        GradientStop { position: 1.0; color: "#1a1a1a" }
    }
    gradient: bgGradient

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.7
        spacing: 40

        // --- Logo & Clock ---
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Image {
                source: "qrc:/assets/logo.png"
                sourceSize: Qt.size(120, 120)
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: Qt.formatTime(new Date(), "hh:mm")
                color: "white"
                font.pixelSize: 64
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "Good " + (new Date().getHours() < 12 ? "Morning" : new Date().getHours() < 18 ? "Afternoon" : "Evening") + ", User."
                color: "#00FF00"
                font.pixelSize: 24
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // --- Search Box ---
        Rectangle {
            Layout.fillWidth: true
            height: 50
            radius: 25
            color: "#2C2C2C"
            border.color: "#00FF00"
            border.width: 1

            TextInput {
                anchors.fill: parent
                anchors.margins: 20
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 16
                text: ""
                
                Text {
                    anchors.fill: parent
                    visible: parent.text === ""
                    text: "Search DuckDuckGo or type a URL..."
                    color: "gray"
                    verticalAlignment: Text.AlignVCenter
                }

                onAccepted: {
                    root.requestSearch(text)
                }
            }
        }

        // --- Shortcuts (Cards) ---
        GridLayout {
            columns: 4 // Maximum 4 items per row
            rowSpacing: 20
            columnSpacing: 20
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            // Reusable Delegate
            Component {
                id: shortcutDelegate
                Rectangle {
                    width: 120
                    height: 100
                    color: "#252525"
                    radius: 10
                    border.color: hoverHandler.hovered ? "#00FF00" : "#333"
                    property string label: ""
                    property string icon: ""
                    property string url: ""

                    HoverHandler { id: hoverHandler }

                    ColumnLayout {
                        anchors.centerIn: parent
                        Text { text: icon; font.pixelSize: 32; Layout.alignment: Qt.AlignHCenter }
                        Text { text: label; color: "white"; font.pixelSize: 14; Layout.alignment: Qt.AlignHCenter }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.requestUrl(url)
                    }
                }
            }

            // Items
            Loader { sourceComponent: shortcutDelegate; onLoaded: { item.label="YouTube"; item.icon="📺"; item.url="https://youtube.com" } }
            Loader { sourceComponent: shortcutDelegate; onLoaded: { item.label="Twitter"; item.icon="🐦"; item.url="https://twitter.com" } }
            Loader { sourceComponent: shortcutDelegate; onLoaded: { item.label="GitHub"; item.icon="🐙"; item.url="https://github.com" } }
            Loader { sourceComponent: shortcutDelegate; onLoaded: { item.label="Reddit"; item.icon="👽"; item.url="https://reddit.com" } }
        }
    }

    // --- Stats Bar (Bottom) ---
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 40
        color: "#111"
        
        RowLayout {
            anchors.centerIn: parent
            spacing: 30
            
            Text { text: "🛡️ 140 Trackers Blocked"; color: "orange" }
            Text { text: "⚡ 12MB Bandwidth Saved"; color: "#00FF00" }
            Text { text: "⏱️ 5s Time Saved"; color: "cyan" }
        }
    }
}
