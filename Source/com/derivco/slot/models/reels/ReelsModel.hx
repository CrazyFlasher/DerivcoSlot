package com.derivco.slot.models.reels;
import com.derivco.slot.models.common.BaseModel;
import openfl.events.Event;
class ReelsModel extends BaseModel implements IReelsModel {
    public var reelList(get, never):Array<ISingleReelModel>;
    public var reelListImmutable(get, never):Array<ISingleReelModelImmutable>;

    private var _reelList:Array<ISingleReelModel> = new Array<ISingleReelModel>();
    private var _reelListImmutable:Array<ISingleReelModelImmutable> = new Array<ISingleReelModelImmutable>();

    public function new() {
        super();
    }

    override public function setJsonData(json:Dynamic):Void {
        super.setJsonData(json);

        untyped _reelList.length = 0;
        untyped _reelListImmutable.length = 0;

        var reelJsonList:Array<Dynamic> = cast (json.reelList, Array<Dynamic>);

        for (reelJson in reelJsonList)
        {
            var reelModel:ISingleReelModel = new SingleReelModel();
            reelModel.setJsonData(reelJson);
            _reelList.push(reelModel);
            _reelListImmutable.push(reelModel);
        }

        dispatchEvent(new Event(ReelsModelEventType.POPULATED));
    }

    public function spin():IReelsModel {
        for (reelModel in _reelList)
        {
            reelModel.spin();
        }

        dispatchEvent(new Event(ReelsModelEventType.SPIN));

        trace(_reelList[0].symbolList);
        trace(_reelList[1].symbolList);
        trace(_reelList[2].symbolList);

        return this;
    }

    private function get_reelList():Array<ISingleReelModel> {
        return _reelList;
    }

    private function get_reelListImmutable():Array<ISingleReelModelImmutable> {
        return _reelListImmutable;
    }
}
