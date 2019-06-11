package com.derivco.slot.view;

import com.derivco.slot.context.IAppContextImmutable;
import com.derivco.slot.models.IAppModelImmutable;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.EventDispatcher;

class AppView extends EventDispatcher {

    private var context:IAppContextImmutable;
    private var root:DisplayObjectContainer;

    private var container:Sprite;

    private var appModel:IAppModelImmutable;

    public function new(context:IAppContextImmutable, root:DisplayObjectContainer) {
        super();

        this.context = context;
        this.root = root;

        init();
    }

    private function init():Void
    {
        appModel = context.appModelImmutable;

        container = new Sprite();
        root.addChild(container);
    }
}
