package com.simple.slot.view.ui;

import openfl.utils.Dictionary;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

class WinLinesUI extends UIClip {

    private var lineMap:Dictionary<String, DisplayObject>;

    public function new(assets:Sprite) {
        super(assets);
    }

    override private function init():Void {
        super.init();

        lineMap = new Dictionary();

        lineMap.set("top", _assets.getChildByName("line_1"));
        lineMap.set("center", _assets.getChildByName("line_2"));
        lineMap.set("bottom", _assets.getChildByName("line_3"));

        reset();
    }

    public function reset():Void
    {
        for (line in lineMap)
        {
            lineMap.get(line).visible = false;
        }
    }

    public function showLine(lineId:String):Void
    {
        reset();

        lineMap.get(lineId).visible = true;
    }

}
