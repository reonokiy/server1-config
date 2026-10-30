import IBus from 'gi://IBus';

import * as IBusManager from 'resource:///org/gnome/shell/misc/ibusManager.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class StableIBusCandidates extends Extension {
    enable() {
        this._popup = IBusManager.getIBusManager()._candidatePopup;
        this._area = this._popup._candidateArea;
        this._originalGeometry = this._popup._setDummyCursorGeometry;
        this._originalOrientation = this._area.setOrientation;
        this._requestedOrientation = this._area._orientation;

        const extension = this;
        this._geometryOverride = function (x, y, width, height) {
            // Each new popup follows the cursor once, then holds that anchor.
            if (!this.visible)
                extension._originalGeometry.call(this, x, y, width, height);
        };
        this._orientationOverride = function (orientation) {
            extension._requestedOrientation = orientation;
            extension._originalOrientation.call(this, IBus.Orientation.HORIZONTAL);
        };

        this._popup._setDummyCursorGeometry = this._geometryOverride;
        this._area.setOrientation = this._orientationOverride;
        this._originalOrientation.call(this._area, IBus.Orientation.HORIZONTAL);
    }

    disable() {
        if (this._popup?._setDummyCursorGeometry === this._geometryOverride)
            this._popup._setDummyCursorGeometry = this._originalGeometry;
        if (this._area?.setOrientation === this._orientationOverride) {
            this._area.setOrientation = this._originalOrientation;
            this._originalOrientation.call(this._area, this._requestedOrientation);
        }
        this._popup = null;
        this._area = null;
        this._originalGeometry = null;
        this._originalOrientation = null;
        this._geometryOverride = null;
        this._orientationOverride = null;
    }
}
