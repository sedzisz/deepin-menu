import QtQuick 2.0

import "MenuItem.js" as MenuItemJs

Component {
    Rectangle {
        id: itemArea
        width: ListView.view.width
        height: componentText.text == "" ? verticalPadding * 2 + 2 : componentText.implicitHeight + verticalPadding * 2
        color: Qt.rgba(0, 0, 0, 0)

        property bool isSep: itemText == ""
        property int verticalPadding: ListView.view.verticalPadding
        property int horizontalPadding: ListView.view.horizontalPadding
        property int textLeftMargin: ListView.view.textLeftMargin
        property int textRightMargin: ListView.view.textRightMargin
        property int textSize: ListView.view.textSize
        property color textColor: ListView.view.textColor
        property bool isDockMenu: ListView.view.isDockMenu

        property string componentId: itemId
        property string componentSubMenu: itemSubMenu
        property bool componentActive: isActive
        property bool componentCheckable: isCheckable
        property bool componentChecked: checked
        property string componentShortcut: itemShortcut
        property string iconNormal: itemIcon
        property string iconHover: itemIconHover
        property string iconInactive: itemIconInactive

        property alias itemTextColor: componentText.color
        property alias itemExtraColor: componentExtraInfo.color
        property alias itemArrowPic: componentIndicator.source
        property alias itemIconPic: componentImage.source

        Connections {
            target: itemArea.ListView.view

            onItemChecked: {
                var thisInfo = itemArea.componentId.split(":")
                // implys that this item is part of a radio group
                if (thisInfo.length == 3) {
                    var itemInfo = item.componentId.split(":")
                    var itemGroupId = itemInfo[0]
                    var itemGroupType = itemInfo[1]
                    var itemItemId = itemInfo[2]

                    if (itemGroupType=="radio" && itemGroupId==thisInfo[0] && idx != index) {
                        componentChecked = false
                        itemIconPic = iconNormal
                        itemArea.ListView.view.itemUnchecked(idx, itemArea)
                    }
                }
            }

            onSelectItemPrivate: {
                if (index == idx) {
                    MenuItemJs.onEntered(index, itemArea, menu)
                }
            }
        }

        function _get_check_icon(state) {
            if (isDockMenu) {
                return "images/check_dark_" + state + ".png"
            } else {
                return "images/check_light_" + state + ".png"
            }
        }

        function checkThis() {
            if (showCheckmark) {
                iconNormal = _get_check_icon("normal")
                iconHover = _get_check_icon("hover")
                iconInactive = _get_check_icon("inactive")
            }
        }

        function undoCheckThis() {
            if (showCheckmark) {
                iconNormal = ""
                iconHover = ""
                iconInactive = ""
            }
        }

        onComponentCheckedChanged: {
            if (componentCheckable) {
                if (componentChecked ) {
                    checkThis()
                } else {
                    undoCheckThis()
                }
            }
        }

        Image {
            id: componentImage
            /* visible: itemIcon != "" */
            source: componentActive ? iconNormal : iconInactive
            anchors.left: parent.left
            anchors.leftMargin: horizontalPadding
            anchors.rightMargin: horizontalPadding
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: componentText
            visible: itemText != ""
            text: itemText
            color: componentActive ? textColor : textColorNotActive
            font.pixelSize: 12

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: parent.textLeftMargin
        }

        Text {
            id: componentExtraInfo
            text: itemExtra
            color: extraColor
            font.pixelSize: 12

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: componentIndicator.implicitWidth + parent.horizontalPadding
        }

        Image {
            id: componentIndicator
            visible: JSON.parse(componentSubMenu).items.length != 0 && componentSubMenu != undefined && !isSep
            source: parent.isDockMenu ? parent.ListView.view.arrowDark : parent.ListView.view.arrowLight

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.horizontalPadding
        }

        Rectangle{
            visible: parent.isSep
            anchors.centerIn: parent
            width: parent.width
            height: 2
            color: Qt.rgba(0, 0, 0, 0)
            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0)
                Rectangle {
                    id: itemSeparator1
                    width: 1
                    height: itemArea.ListView.view.width - 4

                    transformOrigin: Item.Center
                    rotation: 90
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.2) }
                        GradientStop { position: 0.5; color: Qt.rgba(0, 0, 0, 0.25) }
                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.2) }
                    }

                    anchors.centerIn: parent
                }
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0)
                Rectangle {
                    id: itemSeparator
                    width: 1
                    height: itemArea.ListView.view.width - 4

                    transformOrigin: Item.Center
                    rotation: 90
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.1)}
                        GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.15) }
                        GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.1) }
                    }

                    anchors.centerIn: parent
                }
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            id: mouseArea
            visible: !parent.isSep
            anchors.fill: parent
            hoverEnabled: true

            onClicked: MenuItemJs.onClicked(index, parent, menu)
            onEntered: MenuItemJs.onEntered(index, parent, menu)
        }
    }
}
