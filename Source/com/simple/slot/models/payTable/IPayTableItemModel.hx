package com.simple.slot.models.payTable;
import IBaseModel;
interface IPayTableItemModel extends IPayTableItemModelImmutable extends IBaseModel{
    function calculatePayout(lineSymbolList:Array<String>, lineId:String):Int;
    function reset():IPayTableItemModel;
}
