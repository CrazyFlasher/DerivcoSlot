package com.derivco.slot.models.reels;
import com.derivco.slot.models.common.IBaseModel;
interface ISingleReelModel extends ISingleReelModelImmutable extends IBaseModel {
    function spin(fixedResult:FixedResultVo = null):ISingleReelModel;
}
