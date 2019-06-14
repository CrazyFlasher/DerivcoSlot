package com.simple.slot.controller;

import com.simple.slot.context.IAppContext;
import com.simple.slot.models.app.IAppModel;
import com.simple.slot.models.payTable.IPayTableModel;
import com.simple.slot.models.reels.FixedResultVo;
import com.simple.slot.models.reels.IReelsModel;
import haxe.Json;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.utils.Assets;

class AppController extends EventDispatcher implements IAppController
{
    private var appModel:IAppModel;
    private var reelsModel:IReelsModel;
    private var payTableModel:IPayTableModel;

    public function new(context:IAppContext)
    {
        super();

        appModel = context.appModel;
        reelsModel = context.reelsModel;
        payTableModel = context.payTableModel;
    }

    public function loadResources():IAppController
    {
        var path:String = "assets/config.json";

        Assets.loadText(path).onComplete(function(text:String):Void
        {
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
        var future = Assets.loadLibrary("ui").onComplete(function(_):Void
        {
            dispatchEvent(new Event(AppControllerEventType.RESOURCES_LOADED));
        });
    }

    public function spin(fixedDataList:Array<FixedResultVo>):IAppController
    {

        if (appModel.hasEnoughMoney)
        {
            payTableModel.reset();
            appModel.setBalance(appModel.balance - appModel.spinCost);
            appModel.setLocked(true);

            reelsModel.spin(fixedDataList);
            payTableModel.calculatePayout(reelsModel.reelListImmutable);
            appModel.setBalance(appModel.balance + payTableModel.payout);
        }

        return this;
    }

    public function resultsShown():IAppController
    {
        appModel.setLocked(false);

        return this;
    }

    public function updateBalance(value:Int):IAppController
    {
        appModel.setBalance(value);

        return this;
    }

    public function updateSpinCost(value:Int):IAppController
    {
        appModel.setSpinCost(value);

        return this;
    }

}
