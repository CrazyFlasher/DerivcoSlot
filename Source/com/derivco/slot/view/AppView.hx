package com.derivco.slot.view;

import com.derivco.slot.view.ui.ReelUIEventType;
import com.derivco.slot.models.payTable.PayTableModelEventType;
import com.derivco.slot.models.payTable.IPayTableModelImmutable;
import openfl.events.MouseEvent;
import com.derivco.slot.context.IAppContextImmutable;
import com.derivco.slot.models.app.IAppModelImmutable;
import com.derivco.slot.models.reels.IReelsModelImmutable;
import com.derivco.slot.models.reels.ISingleReelModelImmutable;
import com.derivco.slot.models.reels.ReelsModelEventType;
import com.derivco.slot.view.ui.ButtonUI;
import com.derivco.slot.view.ui.ReelUI;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.text.TextField;
import openfl.utils.Assets;
import Std;

class AppView extends EventDispatcher {

    private var assets:DisplayObjectContainer;

    private var context:IAppContextImmutable;
    private var root:DisplayObjectContainer;

    private var container:Sprite;

    private var appModel:IAppModelImmutable;
    private var reelsModel:IReelsModelImmutable;
    private var payTableModel:IPayTableModelImmutable;

    private var spinBtn:ButtonUI;
    private var balanceValueTf:TextField;
    private var spinCostValueTf:TextField;
    private var payoutValueTf:TextField;

    private var reelUIList:Array<ReelUI> = new Array<ReelUI>();

    public function new(context:IAppContextImmutable, root:DisplayObjectContainer) {
        super();

        this.context = context;
        this.root = root;

        init();
    }

    private function init():Void
    {
        appModel = context.appModelImmutable;
        reelsModel = context.reelsModelImmutable;
        payTableModel = context.payTableModelImmutable;

        reelsModel.addEventListener(ReelsModelEventType.POPULATED, updateReels);
        reelsModel.addEventListener(ReelsModelEventType.SPIN, showResult);
        payTableModel.addEventListener(PayTableModelEventType.RESETED, updateValues);

        container = new Sprite();
        root.addChild(container);

        assets = Assets.getMovieClip("ui:assets");
        container.addChild(assets);

        spinBtn = new ButtonUI(getSprite("spinBtn"));
        spinBtn.assets.addEventListener(MouseEvent.CLICK, spinBtnClick);

        balanceValueTf = getTextField("balanceValueTf");
        spinCostValueTf = getTextField("spinCostValueTf");
        payoutValueTf = getTextField("payoutValueTf");

        spinCostValueTf.restrict = balanceValueTf.restrict = "0-9";

        createReels(assets);

        updateValues();
    }

    private function spinBtnClick(event:MouseEvent):Void
    {
        dispatchEvent(new Event(AppViewEventType.SPIN));
    }

    private function showResult(event:Event):Void
    {
        var spinTime:Float = 2.0;
        for (reelUI in reelUIList)
        {
            reelUI.showResult(spinTime);

            spinTime += 0.5;
        }
    }

    private function updateReels(event:Event):Void
    {
        var index:Int;
        for (reelUI in reelUIList)
        {
            index = reelUIList.indexOf(reelUI);
            reelUI.update(reelsModel.reelListImmutable[index]);
        }
    }

    private function createReels(assets:DisplayObjectContainer):Void
    {
        var reelUI:ReelUI;
        var modelList:Array<ISingleReelModelImmutable> = reelsModel.reelListImmutable;
        var index:Int;

        for (singleReelModel in modelList)
        {
            index = modelList.indexOf(singleReelModel);
            reelUI = new ReelUI(cast (assets.getChildByName("reel_" + index), Sprite));
            reelUI.update(singleReelModel);
            reelUIList.push(reelUI);

            if (index == modelList.length - 1)
            {
                reelUI.addEventListener(ReelUIEventType.REEL_STOPPED, lastReelStopped);
            }
        }
    }

    private function lastReelStopped(event:Event):Void
    {
        updateValues();

        dispatchEvent(new Event(AppViewEventType.REELS_STOPPED));
    }

    private function updateValues(event:Event = null):Void
    {
        balanceValueTf.text = Std.string(appModel.balance);
        spinCostValueTf.text = Std.string(appModel.spinCost);
        payoutValueTf.text = Std.string(payTableModel.payout);
    }

    private function getSprite(name:String):Sprite
    {
        return cast (assets.getChildByName(name), Sprite);
    }

    private function getTextField(name:String):TextField
    {
        return cast (assets.getChildByName(name), TextField);
    }
}
