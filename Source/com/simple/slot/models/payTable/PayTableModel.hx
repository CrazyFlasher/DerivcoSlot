package com.simple.slot.models.payTable;
import com.simple.slot.models.reels.ISingleReelModelImmutable;
import com.simple.slot.models.common.BaseModel;
import openfl.events.Event;
class PayTableModel extends BaseModel implements IPayTableModel
{
    public var payout(get, never):Int;
    public var payTableListImmutable(get, never):Array<IPayTableItemModelImmutable>;
    public var itemListWithPayout(get, never):Array<IPayTableItemModelImmutable>;

    private var _payTableList:Array<IPayTableItemModel> = new Array<IPayTableItemModel>();
    private var _payTableListImmutable:Array<IPayTableItemModelImmutable> = new Array<IPayTableItemModelImmutable>();
    private var _itemListWithPayout:Array<IPayTableItemModelImmutable> = new Array<IPayTableItemModelImmutable>();

    private var _payout:Int = 0;

    public function new()
    {
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
        untyped _itemListWithPayout.length = 0;

        for (model in _payTableList)
        {
            model.reset();
        }

        dispatchEvent(new Event(PayTableModelEventType.RESETED));

        return this;
    }

    public function calculatePayout(reelList:Array<ISingleReelModelImmutable>):IPayTableModel {
        _payout = 0;
        untyped _itemListWithPayout.length = 0;

        var itemPayout:Int;
        for (model in _payTableList)
        {
            itemPayout = 0;

            itemPayout += model.calculatePayout(getLineSymbolList(1, reelList), "top");
            itemPayout += model.calculatePayout(getLineSymbolList(2, reelList), "center");
            itemPayout += model.calculatePayout(getLineSymbolList(3, reelList), "bottom");

            if (itemPayout > 0)
            {
                _itemListWithPayout.push(model);
            }

            _payout += itemPayout;
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

    private function get_itemListWithPayout():Array<IPayTableItemModelImmutable> {
        return _itemListWithPayout;
    }
}
