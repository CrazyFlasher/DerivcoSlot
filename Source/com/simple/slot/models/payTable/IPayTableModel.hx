package com.simple.slot.models.payTable;

import com.simple.slot.models.common.IBaseModel;
import com.simple.slot.models.reels.ISingleReelModelImmutable;

interface IPayTableModel extends IPayTableModelImmutable extends IBaseModel
{
    function reset():IPayTableModel;
    function calculatePayout(reelList:Array<ISingleReelModelImmutable>):IPayTableModel;
}
