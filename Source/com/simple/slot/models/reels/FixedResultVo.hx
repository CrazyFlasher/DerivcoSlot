package com.simple.slot.models.reels;
class FixedResultVo
{
    public var symbolId(get, never):String;
    public var index(get, never):Int;

    private var _symbolId:String;
    private var _index:Int;

    public function new(symbolId:String, index:Int)
    {
        _symbolId = symbolId;
        _index = index;
    }

    private function get_symbolId():String {
        return _symbolId;
    }

    private function get_index():Int {
        return _index;
    }
}
