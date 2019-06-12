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

    public function calculatePayout(lineSymbolList:Array<String>, lineId:String):Int {

        var currentLineSymbols:Array<String> = lineSymbolList.copy();

        if (_lineId == null || _lineId == lineId)
        {
            for (symbolId in _symbolIdList)
            {
                if (currentLineSymbols.indexOf(symbolId) == -1)
                {
                    return 0;
                }

                currentLineSymbols.remove(symbolId);
            }

            trace("payout: " + lineSymbolList + ": " + lineId + ": value " + _payout);

            return _payout;
        }

        return 0;
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
