package com.simple.slot.models.reels;
import IBaseModel;
interface ISingleReelModel extends ISingleReelModelImmutable extends IBaseModel {
    function spin(fixedResult:FixedResultVo = null):ISingleReelModel;
}
