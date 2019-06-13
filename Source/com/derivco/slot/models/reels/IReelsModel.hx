package com.derivco.slot.models.reels;
import com.derivco.slot.models.common.IBaseModel;
interface IReelsModel extends IBaseModel extends IReelsModelImmutable {
    var reelList(get, never):Array<ISingleReelModel>;

    function spin(fixedDataList:Array<FixedResultVo>):IReelsModel;
}
