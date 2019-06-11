package com.derivco.slot.models.payTable;
import com.derivco.slot.models.reels.IReelsModelImmutable;
import com.derivco.slot.models.common.IBaseModel;
interface IPayTableModel extends IPayTableModelImmutable extends IBaseModel{
    function calculateWin(reelsModel:IReelsModelImmutable):IPayTableModel;
}
