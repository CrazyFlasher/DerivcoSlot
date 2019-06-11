package com.derivco.slot.controller;
import com.derivco.slot.models.app.AppModelEvent;
import openfl.events.Event;
import openfl.utils.AssetLibrary;
import haxe.Json;
import com.derivco.slot.models.payTable.IPayTableModel;
import com.derivco.slot.models.reels.IReelsModel;
import com.derivco.slot.models.app.IAppModel;
import com.derivco.slot.context.IAppContext;
import openfl.utils.Assets;
import openfl.events.EventDispatcher;
class AppController extends EventDispatcher implements IAppController {
    public var library(get, never):AssetLibrary;

    private var appModel:IAppModel;
    private var reelsModel:IReelsModel;
    private var payTableModel:IPayTableModel;

    private var _library:AssetLibrary;

    public function new(context:IAppContext) {
        super();

        appModel = context.appModel;
        reelsModel = context.reelsModel;
        payTableModel = context.payTableModel;
    }

    public function loadResources():IAppController {
        var path:String = "assets/config.json";

        Assets.loadText(path).onComplete(function(text:String){
            var config:Dynamic = Json.parse(text);

            appModel.setJsonData(config);
            reelsModel.setJsonData(config);
            payTableModel.setJsonData(config);

            loadAssets();
        });

        return this;
    }

    private function loadAssets():Void
    {
        var future = Assets.loadLibrary ("assets/ui.bundle");
        future.onComplete (library_onComplete);
    }

    private function library_onComplete (library:AssetLibrary):Void {
        _library = library;

        dispatchEvent(new Event(AppControllerEventType.RESOURCES_LOADED));
    }

    public function startSpin():IAppController {

        return this;
    }

    function get_library():AssetLibrary {
        return _library;
    }

}
