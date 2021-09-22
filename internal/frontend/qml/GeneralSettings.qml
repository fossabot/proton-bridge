// Copyright (c) 2021 Proton Technologies AG
//
// This file is part of ProtonMail Bridge.
//
// ProtonMail Bridge is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// ProtonMail Bridge is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ProtonMail Bridge.  If not, see <https://www.gnu.org/licenses/>.

import QtQuick 2.13
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import Proton 4.0

SettingsView {
    id: root

    property bool _isAdvancedShown: false
    property var notifications

    Label {
        colorScheme: root.colorScheme
        text: qsTr("Settings")
        type: Label.Heading
        Layout.fillWidth: true
    }

    SettingsItem {
        id: autoUpdate
        colorScheme: root.colorScheme
        text: qsTr("Automatic updates")
        description: qsTr("Bridge will automatically update in the background.")
        type: SettingsItem.Toggle
        checked: root.backend.isAutomaticUpdateOn
        onClicked: root.backend.toggleAutomaticUpdate(!autoUpdate.checked)
    }

    SettingsItem {
        id: autostart
        colorScheme: root.colorScheme
        text: qsTr("Automatically start Bridge")
        description: qsTr("The app will autostart everytime you reset your device.")
        type: SettingsItem.Toggle
        checked: root.backend.isAutostartOn
        onClicked: {
            autostart.loading = true
            root.backend.toggleAutostart(!autoUpdate.checked)
        }
        Connections{
            target: root.backend
            onToggleAutostartFinished: {
                autostart.loading = false
            }
        }
    }

    SettingsItem {
        id: beta
        colorScheme: root.colorScheme
        text: qsTr("Enable Beta access")
        description: qsTr("Be the first one to see new features.")
        type: SettingsItem.Toggle
        checked: root.backend.isBetaEnabled
        onClicked: {
            if (!beta.checked) {
                root.notifications.askEnableBeta()
            } else {
                root.notifications.askDisableBeta()
            }
        }
    }

    RowLayout {
        ColorImage {
            Layout.alignment: Qt.AlignTop

            source: root._isAdvancedShown ? "icons/ic-chevron-up.svg" : "icons/ic-chevron-down.svg"
            color: root.colorScheme.interaction_norm
            height: root.colorScheme.body_font_size
            sourceSize.height: root.colorScheme.body_font_size
            MouseArea {
                anchors.fill: parent
                onClicked: root._isAdvancedShown = !root._isAdvancedShown
            }
        }

        Label {
            id: advSettLabel
            colorScheme: root.colorScheme
            text: qsTr("Advanced settings")
            color: root.colorScheme.interaction_norm
            type: Label.Body

            MouseArea {
                anchors.fill: parent
                onClicked: root._isAdvancedShown = !root._isAdvancedShown
            }
        }
    }

    SettingsItem {
        id: doh
        visible: root._isAdvancedShown
        colorScheme: root.colorScheme
        text: qsTr("Alternative routing")
        description: qsTr("If Proton’s servers are blocked in your location, alternative network routing will be used to reach Proton.")
        type: SettingsItem.Toggle
        checked: root.backend.isDoHEnabled
        onClicked: root.backend.toggleDoH(!doh.checked)
    }

    SettingsItem {
        id: ports
        visible: root._isAdvancedShown
        colorScheme: root.colorScheme
        text: qsTr("Default ports")
        actionText: qsTr("Change")
        description: qsTr("Choose which ports are used by default.")
        type: SettingsItem.Button
        onClicked: root.parent.showPortSettings()
    }

    SettingsItem {
        id: smtp
        visible: root._isAdvancedShown
        colorScheme: root.colorScheme
        text: qsTr("SMTP connection mode")
        actionText: qsTr("Change")
        description: qsTr("Change the protocol Bridge and your client use to connect.")
        type: SettingsItem.Button
        onClicked: root.parent.showSMTPSettings()
    }

    SettingsItem {
        id: cache
        visible: root._isAdvancedShown
        colorScheme: root.colorScheme
        text: qsTr("Local cache")
        actionText: qsTr("Configure")
        description: qsTr("Configure Bridge's local cache settings.")
        type: SettingsItem.Button
        onClicked: root.parent.showLocalCacheSettings()
    }

    SettingsItem {
        id: reset
        visible: root._isAdvancedShown
        colorScheme: root.colorScheme
        text: qsTr("Reset Bridge")
        actionText: qsTr("Reset")
        description: qsTr("Remove all accounts, clear cached data, and restore the original settings.")
        type: SettingsItem.Button
        onClicked: {
            root.notifications.askResetBridge()
        }
    }

    onBack: root.parent.showAccount()
}