import QtQuick 2.0

import "MenuItem.js" as MenuItemJs

Rectangle {
    id: fullscreen_bg
	/* focus: true */
    width: _injection.getScreenWidth()
    height: _injection.getScreenHeight()
	
	Image {
		anchors.fill: parent
		source: "/home/hualet/Pictures/wallpapers-collect/test.jpg"
	}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: {
			/* mouse.accepted = false */
			/* _injection.postMouseEvent(mouse.x, mouse.y, 1) */
            _application.quit()
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Escape) {
            _application.quit()
        }
    }
	
	Component.onCompleted: {
		var component
		var component_bg
		var component_border_color
		var component_font_color
		var component_blur_radius
		
		if (_menu_view.withCorner) {
			component = Qt.createComponent("DockMenu.qml")
			component_bg = Qt.rgba(0, 0, 0, 0.8)
			component_border_color = Qt.rgba(1, 1, 1, 0.15)
			component_blur_radius = 16
			component_font_color = Qt.rgba(1, 1, 1, 1)
		} else {
			component = Qt.createComponent("RectMenu.qml")
			component_bg = Qt.rgba(1, 1, 1, 0.9)			
			component_border_color = Qt.rgba(0, 0, 0, 0.15)
			component_blur_radius = 8			
			component_font_color = Qt.rgba(0, 0, 0, 1)			
		}
        component.createObject(fullscreen_bg, {"x": _menu_view.x, "y": _menu_view.y,
											   "fillColor": component_bg, "fontColor": component_font_color,
											   "borderColor": component_border_color,
											   "blurWidth": component_blur_radius,
                                               "menuItems": _menu_view.menuJsonContent, "fullscreenBg": fullscreen_bg});
	}
}