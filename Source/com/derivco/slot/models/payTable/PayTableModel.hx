package com.derivco.slot.models.payTable;
import com.derivco.slot.models.common.BaseModel;
class PayTableModel extends BaseModel implements IPayTableModel{
    private var _payTableList:Array<IPayTableItemModel> = new Array<IPayTableItemModel>();

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

}
