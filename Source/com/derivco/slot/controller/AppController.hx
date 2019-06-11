package com.derivco.slot.controller;
import com.derivco.slot.context.IAppContext;
import com.derivco.slot.models.app.IAppModel;
import com.derivco.slot.models.payTable.IPayTableModel;
import com.derivco.slot.models.reels.IReelsModel;
import haxe.Json;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.utils.Assets;
class AppController extends EventDispatcher implements IAppController {
    private var appModel:IAppModel;
    private var reelsModel:IReelsModel;
    private var payTableModel:IPayTableModel;

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
        var future = Assets.loadLibrary("ui").onComplete(function(_):Void {
            dispatchEvent(new Event(Std.string(AppControllerEvent.RESOURCES_LOADED)));
        });
    }

    public function spin():IAppController {

        reelsModel.spin();

        return this;
    }

    public function calculateWin():IAppController {

        payTableModel.calculateWin(reelsModel);

        return this;
    }


}
