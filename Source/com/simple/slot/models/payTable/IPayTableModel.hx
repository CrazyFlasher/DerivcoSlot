package com.simple.slot.models.payTable;
import IBaseModel;
import ISingleReelModelImmutable;
interface IPayTableModel extends IPayTableModelImmutable extends IBaseModel{
    function reset():IPayTableModel;
    function calculatePayout(reelList:Array<ISingleReelModelImmutable>):IPayTableModel;
}
