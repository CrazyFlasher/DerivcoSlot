package com.derivco.slot.models.payTable;
import openfl.events.Event;
import com.derivco.slot.models.common.BaseModel;
import com.derivco.slot.models.reels.ISingleReelModelImmutable;
class PayTableModel extends BaseModel implements IPayTableModel{
    public var payout(get, never):Int;
    public var payTableListImmutable(get, never):Array<IPayTableItemModelImmutable>;

    private var _payTableList:Array<IPayTableItemModel> = new Array<IPayTableItemModel>();
    private var _payTableListImmutable:Array<IPayTableItemModelImmutable> = new Array<IPayTableItemModelImmutable>();

    private var _payout:Int;

    public function new() {
        super();
    }

    override public function setJsonData(json:Dynamic):Void {
        super.setJsonData(json);

        untyped _payTableList.length = 0;
        untyped _payTableListImmutable.length = 0;

        var payTableJsonList:Array<Dynamic> = cast (json.payTableList, Array<Dynamic>);

        for (payTableItemJson in payTableJsonList)
        {
            var model:IPayTableItemModel = new PayTableItemModel();
            model.setJsonData(payTableItemJson);

            _payTableList.push(model);
            _payTableListImmutable.push(model);
        }
    }

    public function reset():IPayTableModel {
        _payout = 0;

        dispatchEvent(new Event(PayTableModelEventType.RESETED));

        return this;
    }

    public function calculatePayout(reelList:Array<ISingleReelModelImmutable>):IPayTableModel {
        _payout = 0;

        for (model in _payTableList)
        {
            _payout += model.calculatePayout(getLineSymbolList(1, reelList), "top");
            _payout += model.calculatePayout(getLineSymbolList(2, reelList), "center");
            _payout += model.calculatePayout(getLineSymbolList(3, reelList), "bottom");
        }

        return this;
    }

    private function getLineSymbolList(lineIndex:Int, reelList:Array<ISingleReelModelImmutable>):Array<String>
    {
        return [reelList[0].symbolList[lineIndex], reelList[1].symbolList[lineIndex], reelList[2].symbolList[lineIndex]];
    }

    private function get_payout():Int {
        return _payout;
    }

    private function get_payTableListImmutable():Array<IPayTableItemModelImmutable> {
        return _payTableListImmutable;
    }
}
