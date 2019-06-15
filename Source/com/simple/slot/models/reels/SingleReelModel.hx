package com.simple.slot.models.reels;

import com.simple.slot.models.common.BaseModel;

class SingleReelModel extends BaseModel implements ISingleReelModel
{
    public var symbolList(get, never):Array<Dynamic>;

    private var _symbolList:Array<Dynamic>;

    private var replacedWithNoneSymbol:String;

    public function new()
    {
        super();
    }

    override public function setJsonData(json:Dynamic):Void
    {
        super.setJsonData(json);

        _symbolList = cast (json, Array<Dynamic>);
    }

    private function get_symbolList():Array<Dynamic>
    {
        return _symbolList;
    }

    public function spin(fixedResult:FixedResultVo = null):ISingleReelModel
    {
        replaceNoneWithNormalSymbol();

        var displacement:Int = 0;

        if (fixedResult == null)
        {
            displacement = Math.floor(Math.random() * _symbolList.length);
        } else
        {
            displacement = _symbolList.indexOf(fixedResult.symbolId);

            shuffle(displacement);

            var extra:Int = -fixedResult.index;
            if (fixedResult.index > 1)
            {
                extra += 1;
            }

            displacement = extra;
        }

        shuffle(displacement, (fixedResult == null && Math.random() > 0.5) || (fixedResult != null && fixedResult.index == 2));

        return this;
    }

    private function replaceNoneWithNormalSymbol():Void
    {
        if (replacedWithNoneSymbol != null)
        {
            for (i in 0..._symbolList.length)
            {
                if (_symbolList[i] == "NONE")
                {
                    _symbolList[i] = replacedWithNoneSymbol;

                    break;
                }
            }

            replacedWithNoneSymbol = null;
        }
    }

    private function shuffle(displacement:Int, replaceWithNone:Bool = false):Void
    {
        var result:Array<Dynamic> = _symbolList.slice(0, displacement);
        _symbolList = _symbolList.splice(displacement, _symbolList.length).concat(result);

        if (replaceWithNone)
        {
            replacedWithNoneSymbol = _symbolList[2];
            _symbolList[2] = "NONE";
        }
    }

    public function containsNone():Bool
    {
        return replacedWithNoneSymbol != null;
    }
}
