package com.derivco.slot.view.ui;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
class ButtonUI extends UIClip {
    public var enabled(get, set):Bool;

    private var _enabled:Bool = true;

    public function new(assets:Sprite) {
        super(assets);
    }

    override private function init():Void
    {
        super.init();

        _assets.addEventListener(MouseEvent.MOUSE_DOWN, down);
        _assets.addEventListener(MouseEvent.CLICK, click);
        _assets.addEventListener(MouseEvent.MOUSE_UP, up);
        _assets.addEventListener(MouseEvent.RELEASE_OUTSIDE, outside);
    }

    private function outside(e:Event):Void {
        _assets.scaleX = _assets.scaleY = 1.0;
    }

    private function click(e:Event):Void {
        _assets.scaleX = _assets.scaleY = 1.0;
    }

    private function down(e:Event):Void {
        _assets.scaleX = _assets.scaleY = 1.05;
    }

    private function up(e:Event):Void {
        _assets.scaleX = _assets.scaleY = 1.0;
    }

    private function get_enabled():Bool {
        return _enabled;
    }

    private function set_enabled(value:Bool):Bool {
        _assets.mouseEnabled = _assets.mouseChildren = value;

        return _enabled = value;
    }
}
