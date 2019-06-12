package com.derivco.slot.models.payTable;
import com.derivco.slot.models.common.IBaseModel;
import com.derivco.slot.models.reels.ISingleReelModelImmutable;
interface IPayTableModel extends IPayTableModelImmutable extends IBaseModel{
    function reset():IPayTableModel;
    function calculatePayout(reelList:Array<ISingleReelModelImmutable>):IPayTableModel;
}
