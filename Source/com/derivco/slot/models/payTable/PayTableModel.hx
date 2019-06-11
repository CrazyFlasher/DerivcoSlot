package com.derivco.slot.models.payTable;
import com.derivco.slot.models.reels.ISingleReelModelImmutable;
import com.derivco.slot.models.reels.IReelsModelImmutable;
import com.derivco.slot.models.common.BaseModel;
class PayTableModel extends BaseModel implements IPayTableModel{
    private var _payTableList:Array<IPayTableItemModel> = new Array<IPayTableItemModel>();

    private var _lastWin:Int;

    public function new() {
        super();
    }

    override public function setJsonData(json:Dynamic):Void {
        super.setJsonData(json);

        untyped _payTableList.length = 0;

        var payTableJsonList:Array<Dynamic> = cast (json.payTableList, Array<Dynamic>);

        for (payTableItemJson in payTableJsonList)
        {
            var model:IPayTableItemModel = new PayTableItemModel();
            model.setJsonData(payTableItemJson);

            _payTableList.push(model);
        }
    }

    public function calculateWin(reelsModel:IReelsModelImmutable):IPayTableModel {
        var reelList:Array<ISingleReelModelImmutable> = reelsModel.reelListImmutable;

        _lastWin = 0;

        for (model in _payTableList)
        {
            _lastWin += model.getWin(getLineSymbolList(1, reelList), "top");
            _lastWin += model.getWin(getLineSymbolList(2, reelList), "center");
            _lastWin += model.getWin(getLineSymbolList(3, reelList), "bottom");
        }

        trace(_lastWin);

        return this;
    }

    private function getLineSymbolList(lineIndex:Int, reelList:Array<ISingleReelModelImmutable>):Array<String>
    {
        return [reelList[0].symbolList[lineIndex], reelList[1].symbolList[lineIndex], reelList[2].symbolList[lineIndex]];
    }

}
