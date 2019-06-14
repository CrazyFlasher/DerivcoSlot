package com.simple.slot.models.reels;
import com.simple.slot.models.common.IBaseModel;
interface ISingleReelModel extends ISingleReelModelImmutable extends IBaseModel {
    function spin(fixedResult:FixedResultVo = null):ISingleReelModel;
}
