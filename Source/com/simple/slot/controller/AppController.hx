package com.simple.slot.controller;

import hex.di.IInjectorContainer;
import com.simple.slot.context.IAppContext;
import com.simple.slot.models.app.IAppModel;
import com.simple.slot.models.payTable.IPayTableModel;
import com.simple.slot.models.reels.FixedResultVo;
import com.simple.slot.models.reels.IReelsModel;
import haxe.Json;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.utils.Assets;

class AppController extends EventDispatcher implements IInjectorContainer
{
    private var appModel:IAppModel;
    private var reelsModel:IReelsModel;
    private var payTableModel:IPayTableModel;

    @Inject("coolInt")
    @Optional(true)
    public var coolInt:Int;

    @Inject("coolBool")
    public var coolBool:Bool;

    @Inject
    public var arr:Array<String>;

    @Inject
    public var context:IAppContext;

    public function new()
    {
        super();
    }

    @PostConstruct
    public function init():Void
    {
        trace("arr " + arr);
        trace("coolInt " + coolInt);
        trace("coolBool " + coolBool);

        appModel = context.appModel;
        reelsModel = context.reelsModel;
        payTableModel = context.payTableModel;
    }

    public function loadResources():AppController
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

    public function spin(fixedDataList:Array<FixedResultVo>):AppController
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

    public function resultsShown():AppController
    {
        appModel.setLocked(false);

        return this;
    }

    public function updateBalance(value:Int):AppController
    {
        if (value > 5000) value = 5000;
        if (value < 1) value = 1;

        appModel.setBalance(value);

        return this;
    }

    public function updateSpinCost(value:Int):AppController
    {
        appModel.setSpinCost(value);

        return this;
    }

    public function updatePaytableItemWinLineIndex(value:Int):AppController
    {
        payTableModel.updatePaytableItemWinLineIndex(value);

        return this;
    }
}
