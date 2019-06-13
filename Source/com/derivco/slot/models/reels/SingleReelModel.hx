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

    public function spin(fixedResult:FixedResultVo = null):ISingleReelModel {

        var displacement:Int = 0;

        if (fixedResult == null)
        {
            displacement = Math.floor(Math.random() * _symbolList.length);
        } else
        {
            displacement = _symbolList.indexOf(fixedResult.symbolId);

            shuffle(displacement);

            displacement = -fixedResult.index;
        }

        shuffle(displacement);

        return this;
    }

    private function shuffle(displacement:Int):Void
    {
        var result:Array<Dynamic> = _symbolList.slice(0, displacement);
        _symbolList = _symbolList.splice(displacement, _symbolList.length).concat(result);
    }
}
