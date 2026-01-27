import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: loginRoot
    anchors.fill: parent
    color: "#000000"
    z: 9999 // Always on top

    signal unlocked()

    Gradient {
        anchors.fill: parent
        GradientStop { position: 0.0; color: "#050505" }
        GradientStop { position: 1.0; color: "#1a1a1a" }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30
        width: 300

        // Shield Logo
        Image {
            source: "qrc:/assets/logo.png"
            sourceSize: Qt.size(80, 80)
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: isSetupMode ? "Create Vault PIN" : "Unlock Aegis Vault"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Status Message
        Text {
            id: statusMsg
            text: isSetupMode ? "Enter a new 4-digit PIN" : "Enter your PIN to decrypt"
            color: "#888"
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }

        // PIN Input
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "#1E1E1E"
            border.color: highlightColor
            border.width: 1
            radius: 8

            TextInput {
                id: pinInput
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.pixelSize: 24
                echoMode: TextInput.Password
                maximumLength: 8
                focus: true
                
                onAccepted: submitPin()
            }
        }

        Button {
            text: isSetupMode ? "Set PIN" : "Unlock"
            Layout.fillWidth: true
            height: 45
            
            background: Rectangle {
                color: pinInput.text.length >= 4 ? "#00FF00" : "#333"
                radius: 8
            }
            contentItem: Text {
                text: parent.text
                color: pinInput.text.length >= 4 ? "black" : "gray"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }
            enabled: pinInput.text.length >= 4
            onClicked: submitPin()
        }
    }

    property bool isSetupMode: false
    property color highlightColor: "#333"

    Component.onCompleted: {
        isSetupMode = !privacyCore.hasPinSet()
    }

    function submitPin() {
        if (isSetupMode) {
            privacyCore.setPin(pinInput.text)
            // C++ signal will unlock
        } else {
            var success = privacyCore.checkPin(pinInput.text)
            if (!success) {
                statusMsg.text = "❌ Incorrect PIN"
                statusMsg.color = "red"
                highlightColor = "red"
                pinInput.text = ""
                shakeAnimation.start()
            }
        }
    }

    Connections {
        target: privacyCore
        function onUnlocked() {
            loginRoot.visible = false
        }
    }

    // Shake animation for wrong password
    SequentialAnimation {
        id: shakeAnimation
        NumberAnimation { target: loginRoot; property: "anchors.horizontalCenterOffset"; to: 10; duration: 50 }
        NumberAnimation { target: loginRoot; property: "anchors.horizontalCenterOffset"; to: -10; duration: 50 }
        NumberAnimation { target: loginRoot; property: "anchors.horizontalCenterOffset"; to: 10; duration: 50 }
        NumberAnimation { target: loginRoot; property: "anchors.horizontalCenterOffset"; to: 0; duration: 50 }
    }
}
