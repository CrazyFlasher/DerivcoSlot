package com.derivco.slot.context;
import com.derivco.slot.controller.AppController;
import com.derivco.slot.controller.AppControllerEvent;
import com.derivco.slot.controller.IAppController;
import com.derivco.slot.models.app.AppModel;
import com.derivco.slot.models.app.IAppModel;
import com.derivco.slot.models.app.IAppModelImmutable;
import com.derivco.slot.models.payTable.IPayTableModel;
import com.derivco.slot.models.payTable.IPayTableModelImmutable;
import com.derivco.slot.models.payTable.PayTableModel;
import com.derivco.slot.models.reels.IReelsModel;
import com.derivco.slot.models.reels.IReelsModelImmutable;
import com.derivco.slot.models.reels.ReelsModel;
import com.derivco.slot.view.AppView;
import com.derivco.slot.view.AppViewEvent;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
class AppContext implements IAppContext {
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

    private var controller:IAppController;

    private var view:AppView;

    public function new(viewRoot:DisplayObjectContainer) {
        this.viewRoot = viewRoot;

        init();
    }

    private function init():Void
    {
        _appModel = new AppModel();
        _reelsModel = new ReelsModel();
        _payTableModel = new PayTableModel();

        controller = new AppController(this);
        controller.addEventListener(Std.string(AppControllerEvent.RESOURCES_LOADED), createViews);

        controller.loadResources();
    }

    private function createViews(event:Event):Void
    {
        view = new AppView(this, viewRoot);
        view.addEventListener(Std.string(AppViewEvent.SPIN), function(e:Event):Void {
            controller.spin().calculateWin();
        });
    }

    function get_appModel():IAppModel {
        return _appModel;
    }

    function get_reelsModel():IReelsModel {
        return _reelsModel;
    }

    function get_payTableModel():IPayTableModel {
        return _payTableModel;
    }

    function get_appModelImmutable():IAppModelImmutable {
        return _appModel;
    }

    function get_reelsModelImmutable():IReelsModelImmutable {
        return _reelsModel;
    }

    function get_payTableModelImmutable():IPayTableModelImmutable {
        return _payTableModel;
    }
}
