package com.simple.slot.models.payTable;

import Array;
import com.simple.slot.models.common.BaseModel;

class PayTableItemModel extends BaseModel implements IPayTableItemModel
{
    public var winLineId(get, never):String;

    public var lastPayout(get, never):Int;
    public var lastWinLineList(get, never):Array<String>;

    public var lineId(get, never):String;
    public var symbolIdList(get, never):Array<Dynamic>;
    public var payout(get, never):Int;

    private var _lineId:String;
    private var _symbolIdList:Array<Dynamic>;
    private var _payout:Int;

    private var _lastPayout:Int;
    private var _lastWinLineList:Array<String> = new Array<String>();

    private var winLineIndex:Int;

    public function new()
    {
        super();
    }

    override public function setJsonData(json:Dynamic):Void
    {
        super.setJsonData(json);

        _lineId = json.lineId;
        _symbolIdList = cast (json.symbolIdList, Array<Dynamic>);
        _payout = json.payout;
    }

    public function reset():IPayTableItemModel
    {
        winLineIndex = 0;
        _lastPayout = 0;
        untyped _lastWinLineList.length = 0;

        return this;
    }

    public function updateWinLineIndex():IPayTableItemModel
    {
        if (winLineIndex < _lastWinLineList.length - 1)
        {
            winLineIndex++;
        } else
        {
            winLineIndex = 0;
        }

        return this;
    }

    public function calculatePayout(lineSymbolList:Array<String>, lineId:String):Int
    {
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

            _lastPayout = _payout;
            _lastWinLineList.push(lineId);

            return _payout;
        }

        return 0;
    }

    private function get_lineId():String
    {
        return _lineId;
    }

    private function get_symbolIdList():Array<Dynamic>
    {
        return _symbolIdList;
    }

    private function get_payout():Int
    {
        return _payout;
    }

    private function get_lastPayout():Int
    {
        return _lastPayout;
    }

    private function get_lastWinLineList():Array<String>
    {
        return _lastWinLineList;
    }

    public function get_winLineId():String {
        return _lastWinLineList[winLineIndex];
    }
}
