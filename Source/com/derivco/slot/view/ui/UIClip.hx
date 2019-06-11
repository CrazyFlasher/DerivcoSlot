package com.derivco.slot.view.ui;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;

class UIClip extends EventDispatcher {

    public var assets(get, never):Sprite;

    private var _assets:Sprite;

    public function new(assets:Sprite) {
        super();

        _assets = assets;

        init();
    }

    private function init():Void
    {
    }

    private function get_assets():Sprite {
        return _assets;
    }
}
