package com.simple.slot.models.reels;
import IBaseModel;
interface IReelsModel extends IBaseModel extends IReelsModelImmutable {
    var reelList(get, never):Array<ISingleReelModel>;

    function spin(fixedDataList:Array<FixedResultVo>):IReelsModel;
}
