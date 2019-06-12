package com.derivco.slot.models.app;
import openfl.events.Event;
import com.derivco.slot.models.common.BaseModel;
class AppModel extends BaseModel implements IAppModel{
    public var balance(get, never):Int;
    public var spinCost(get, never):Int;
    public var isTampering(get, never):Bool;

    private var _balance:Int;
    private var _spinCost:Int;
    private var _isTampering:Bool;

    public function new() {
        super();
    }

    override public function setJsonData(json:Dynamic):Void {
        super.setJsonData(json);

        _balance = json.balance;
        _spinCost = json.spinCost;
        _isTampering = json.isTampering;
    }

    public function setIsTampering(value:Bool):IAppModel {
        _isTampering = value;

        dispatchEvent(new Event(AppModelEventType.IS_TAMPERING_UPDATED));

        return this;
    }

    public function setBalance(value:Int):IAppModel {
        dispatchEvent(new Event(AppModelEventType.BALANCE_UPDATED));

        return this;
    }

    public function setSpinCost(value:Int):IAppModel {
        dispatchEvent(new Event(AppModelEventType.SPIN_COST_UPDATED));

        return this;
    }

    private function get_balance():Int {
        return _balance;
    }

    private function get_spinCost():Int {
        return _spinCost;
    }

    private function get_isTampering():Bool {
        return _isTampering;
    }

}
