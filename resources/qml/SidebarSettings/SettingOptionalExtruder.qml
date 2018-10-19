// Copyright (c) 2016 Ultimaker B.V.
// Uranium is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 2.0

import UM 1.1 as UM
import Cura 1.0 as Cura
import GuideTheme 1.0 as GuideThemeNS

SettingItem
{
    id: base
    property var focusItem: control

    contents: ComboBox
    {
        id: control
        anchors.fill: parent

        model: Cura.ExtrudersModel
        {
            onModelChanged: control.color = getItem(control.currentIndex).color
            addOptionalExtruder: true
        }

        textRole: "name"

        property string color: "#fff"



        indicator: UM.RecolorImage
        {
            id: downArrow
            x: control.width - width - control.rightPadding
            y: control.topPadding + Math.round((control.availableHeight - height) / 2)

            source: UM.Theme.getIcon("arrow_bottom")
            width: UM.Theme.getSize("standard_arrow").width
            height: UM.Theme.getSize("standard_arrow").height
            sourceSize.width: width + 5 * screenScaleFactor
            sourceSize.height: width + 5 * screenScaleFactor

            color: GuideThemeNS.Colors.getColor("setting_control_text");
        }

        background: Rectangle
        {
            color:
            {
                if (!enabled)
                {
                    return GuideThemeNS.Colors.getColor("setting_control_disabled");
                }
                if (control.hovered || control.activeFocus)
                {
                    return GuideThemeNS.Colors.getColor("setting_control_highlight");
                }
                return GuideThemeNS.Colors.getColor("setting_control");
            }
            border.width: UM.Theme.getSize("default_lining").width
            border.color:
            {
                if (!enabled)
                {
                    return GuideThemeNS.Colors.getColor("setting_control_disabled_border")
                }
                if (control.hovered || control.activeFocus)
                {
                    return GuideThemeNS.Colors.getColor("setting_control_border_highlight")
                }
                return GuideThemeNS.Colors.getColor("setting_control_border")
            }
        }

        contentItem: Label
        {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: UM.Theme.getSize("setting_unit_margin").width
            anchors.right: downArrow.left
            rightPadding: swatch.width + UM.Theme.getSize("setting_unit_margin").width

            text: control.currentText
            renderType: Text.NativeRendering
            font: UM.Theme.getFont("default")
            color: enabled ? GuideThemeNS.Colors.getColor("setting_control_text") : GuideThemeNS.Colors.getColor("setting_control_disabled_text")

            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter

            background: Rectangle
            {
                id: swatch
                height: Math.round(UM.Theme.getSize("setting_control").height / 2)
                width: height

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Math.round(UM.Theme.getSize("default_margin").width / 4)

                border.width: UM.Theme.getSize("default_lining").width
                border.color: enabled ? GuideThemeNS.Colors.getColor("setting_control_border") : GuideThemeNS.Colors.getColor("setting_control_disabled_border")
                radius: Math.round(width / 2)

                color: control.color
            }
        }

        popup: Popup {
            y: control.height - UM.Theme.getSize("default_lining").height
            width: control.width
            implicitHeight: contentItem.implicitHeight
            padding: UM.Theme.getSize("default_lining").width

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: control.popup.visible ? control.delegateModel : null
                currentIndex: control.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                color: GuideThemeNS.Colors.getColor("setting_control")
                border.color: GuideThemeNS.Colors.getColor("setting_control_border")
            }
        }

        delegate: ItemDelegate
        {
            width: control.width - 2 * UM.Theme.getSize("default_lining").width
            height: control.height
            highlighted: control.highlightedIndex == index

            contentItem: Label
            {
                text: model.name
                renderType: Text.NativeRendering
                color:
                {
                    if (model.enabled) {
                        GuideThemeNS.Colors.getColor("setting_control_text")
                    } else {
                        GuideThemeNS.Colors.getColor("action_button_disabled_text");
                    }
                }
                font: UM.Theme.getFont("default")
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                rightPadding: swatch.width + UM.Theme.getSize("setting_unit_margin").width

                background: Rectangle
                {
                    id: swatch
                    height: Math.round(UM.Theme.getSize("setting_control").height / 2)
                    width: height

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: Math.round(UM.Theme.getSize("default_margin").width / 4)

                    border.width: UM.Theme.getSize("default_lining").width
                    border.color: enabled ? GuideThemeNS.Colors.getColor("setting_control_border") : GuideThemeNS.Colors.getColor("setting_control_disabled_border")
                    radius: Math.round(width / 2)

                    color: control.model.getItem(index).color
                }
            }

            background: Rectangle
            {
                color: parent.highlighted ? GuideThemeNS.Colors.getColor("setting_control_highlight") : "transparent"
                border.color: parent.highlighted ? GuideThemeNS.Colors.getColor("setting_control_border_highlight") : "transparent"
            }
        }
    }
}
