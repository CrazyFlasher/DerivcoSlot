package com.simple.slot.context;

import hex.di.Injector;
import com.simple.slot.controller.AppController;
import com.simple.slot.controller.AppControllerEventType;
import com.simple.slot.models.app.AppModel;
import com.simple.slot.models.app.IAppModel;
import com.simple.slot.models.app.IAppModelImmutable;
import com.simple.slot.models.payTable.IPayTableModel;
import com.simple.slot.models.payTable.IPayTableModelImmutable;
import com.simple.slot.models.payTable.PayTableModel;
import com.simple.slot.models.reels.IReelsModel;
import com.simple.slot.models.reels.IReelsModelImmutable;
import com.simple.slot.models.reels.ReelsModel;
import com.simple.slot.view.AppView;
import com.simple.slot.view.AppViewEventType;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;

class AppContext implements IAppContext
{
    public var appModel(get, never):IAppModel;
    public var reelsModel(get, never):IReelsModel;
    public var payTableModel(get, never):IPayTableModel;

    public var appModelImmutable(get, never):IAppModelImmutable;
    public var reelsModelImmutable(get, never):IReelsModelImmutable;
    public var payTableModelImmutable(get, never):IPayTableModelImmutable;

    private var _appModel:IAppModel;
    private var _reelsModel:IReelsModel;
    private var _payTableModel:IPayTableModel;

    private var viewRoot:DisplayObjectContainer;

    private var controller:AppController;

    private var view:AppView;

    public function new(viewRoot:DisplayObjectContainer)
    {
        this.viewRoot = viewRoot;

        init();
    }

    private function init():Void
    {
        var factory:Injector = new Injector();
        factory.map(IAppContext).toValue(this);
        factory.map(AppController).toType(AppController);
        factory.mapClassName("Array<String>").toValue(["a", "b", "c"]);
        factory.mapClassName("Bool", "coolBool").toValue(true);

        _appModel = new AppModel();
        _reelsModel = new ReelsModel();
        _payTableModel = new PayTableModel();

        controller = factory.getInstance(AppController);
        controller.addEventListener(AppControllerEventType.RESOURCES_LOADED, createViews);

        controller.loadResources();
    }

    private function createViews(event:Event):Void
    {
        view = new AppView(this, viewRoot);

        view.addEventListener(AppViewEventType.SPIN, function(e:Event):Void
        {
            controller.spin(view.fixedDataList);
        });

        view.addEventListener(AppViewEventType.REELS_STOPPED, function(e:Event):Void
        {
            controller.resultsShown();
        });

        view.addEventListener(AppViewEventType.CHANGE_BALANCE, function(e:Event):Void
        {
            controller.updateBalance(view.newBalanceValue);
        });

        view.addEventListener(AppViewEventType.CHANGE_SPIN_COST, function(e:Event):Void
        {
            controller.updateSpinCost(view.newSpinCostValue);
        });

        view.addEventListener(AppViewEventType.PAYTABLE_ITEM_HIGHLIGHTED, function(e:Event):Void
        {
            controller.updatePaytableItemWinLineIndex(view.highLightItemIndex);
        });
    }

    function get_appModel():IAppModel
    {
        return _appModel;
    }

    function get_reelsModel():IReelsModel
    {
        return _reelsModel;
    }

    function get_payTableModel():IPayTableModel
    {
        return _payTableModel;
    }

    function get_appModelImmutable():IAppModelImmutable
    {
        return _appModel;
    }

    function get_reelsModelImmutable():IReelsModelImmutable
    {
        return _reelsModel;
    }

    function get_payTableModelImmutable():IPayTableModelImmutable
    {
        return _payTableModel;
    }
}
