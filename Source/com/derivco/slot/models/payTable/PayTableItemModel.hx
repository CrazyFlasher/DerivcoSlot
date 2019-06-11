package com.derivco.slot.models.payTable;
import com.derivco.slot.models.common.BaseModel;
class PayTableItemModel extends BaseModel implements IPayTableItemModel{

    public var lineId(get, never):String;
    public var symbolIdList(get, never):Array<Dynamic>;
    public var payout(get, never):Int;

    private var _lineId:String;
    private var _symbolIdList:Array<Dynamic>;
    private var _payout:Int;

    public function new() {
        super();
    }

    override public function setJsonData(json:Dynamic):Void {
        super.setJsonData(json);

        _lineId = json.lineId;
        _symbolIdList = cast (json.symbolIdList, Array<Dynamic>);
        _payout = json.payout;
    }

    private function get_lineId():String {
        return _lineId;
    }

    private function get_symbolIdList():Array<Dynamic> {
        return _symbolIdList;
    }

    private function get_payout():Int {
        return _payout;
    }
}
