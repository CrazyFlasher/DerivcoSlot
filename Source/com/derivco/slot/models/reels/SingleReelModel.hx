package com.derivco.slot.models.reels;
import com.derivco.slot.models.common.BaseModel;
class SingleReelModel extends BaseModel implements ISingleReelModel{
    public var symbolList(get, never):Array<Dynamic>;

    private var _symbolList:Array<Dynamic>;

    public function new() {
        super();
    }

    override public function setJsonData(json:Dynamic):Void {
        super.setJsonData(json);

        _symbolList = cast (json, Array<Dynamic>);
    }

    private function get_symbolList():Array<Dynamic> {
        return _symbolList;
    }

    public function spin():ISingleReelModel {
        var displacement:Int = Math.floor(Math.random() * _symbolList.length);

        var result:Array<Dynamic> = _symbolList.slice(0, displacement);
        _symbolList = _symbolList.splice(displacement, _symbolList.length).concat(result);

        return this;
    }
}
