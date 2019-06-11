package com.derivco.slot.view.ui;

import openfl.utils.AssetLibrary;
import openfl.display.Sprite;

class ReelUI extends Sprite {
    private var lib:AssetLibrary;

    public function new(lib:AssetLibrary) {
        super();

        this.lib = lib;

        init();
    }

    private function init():Void
    {
        buildReel();
    }

    private function buildReel():Void
    {

    }
}
