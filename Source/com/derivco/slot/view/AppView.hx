package com.derivco.slot.view;

import com.derivco.slot.view.ui.WinLinesUI;
import com.derivco.slot.context.IAppContextImmutable;
import com.derivco.slot.models.app.AppModelEventType;
import com.derivco.slot.models.app.IAppModelImmutable;
import com.derivco.slot.models.payTable.IPayTableItemModelImmutable;
import com.derivco.slot.models.payTable.IPayTableModelImmutable;
import com.derivco.slot.models.payTable.PayTableModelEventType;
import com.derivco.slot.models.reels.IReelsModelImmutable;
import com.derivco.slot.models.reels.ISingleReelModelImmutable;
import com.derivco.slot.models.reels.ReelsModelEventType;
import com.derivco.slot.view.ui.ButtonUI;
import com.derivco.slot.view.ui.PayTableUI;
import com.derivco.slot.view.ui.PayTableUIEventType;
import com.derivco.slot.view.ui.ReelUI;
import com.derivco.slot.view.ui.ReelUIEventType;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.utils.Assets;
import Std;

using Lambda;

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
    private var payTableUI:PayTableUI;
    private var linesUI:WinLinesUI;

    private var highLightItemIndex:Int;
    private var highLightedSymbolIdList:Array<String> = new Array<String>();

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

        reelsModel.addEventListener(ReelsModelEventType.SPIN, showResult);
        payTableModel.addEventListener(PayTableModelEventType.RESETED, updateValues);
        appModel.addEventListener(AppModelEventType.LOCKED_UPDATED, appLockedUpdated);
        appModel.addEventListener(AppModelEventType.BALANCE_UPDATED, updateValues);

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

        createReels();
        createPaytable();
        createWinLines();

        updateValues();
    }

    private function createWinLines():Void
    {
        linesUI = new WinLinesUI(getSprite("winLines"));
    }

    private function appLockedUpdated(event:Event):Void
    {
        container.mouseEnabled = container.mouseChildren = !appModel.isLocked;

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

    private function createPaytable():Void
    {
        payTableUI = new PayTableUI(getSprite("paytableHolder"), payTableModel);
        payTableUI.addEventListener(PayTableUIEventType.HIGHLIGHT_COMPLETE, payTableUIHighLightComplete);
    }

    private function createReels():Void
    {
        var reelUI:ReelUI;
        var modelList:Array<ISingleReelModelImmutable> = reelsModel.reelListImmutable;
        var index:Int;

        for (singleReelModel in modelList)
        {
            index = modelList.indexOf(singleReelModel);
            reelUI = new ReelUI(getSprite("reel_" + index), singleReelModel);
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
        if (!appModel.isLocked)
        {
            balanceValueTf.text = Std.string(appModel.balance);
            spinCostValueTf.text = Std.string(appModel.spinCost);
            payoutValueTf.text = Std.string(payTableModel.payout);

            if (payTableModel.payout > 0)
            {
                startHighLight();
            }
        } else
        {
            payTableUI.reset();

            for (reelUI in reelUIList)
            {
                reelUI.reset();
            }

            linesUI.reset();
        }
    }

    private function startHighLight():Void
    {
        highLightItemIndex = 0;

        highLightNext();
    }

    private function highLightNext():Void
    {
        var model:IPayTableItemModelImmutable = payTableModel.itemListWithPayout[highLightItemIndex];
        payTableUI.highLightItem(model);

        untyped highLightedSymbolIdList.length = 0;

        for (reelUI in reelUIList)
        {
            reelUI.reset();

            var highLightedSymbolId:String = reelUI.highLightSymbol(model.symbolIdList, model.lastWinLine, highLightedSymbolIdList);
            if (highLightedSymbolId != null)
            {
                highLightedSymbolIdList.push(highLightedSymbolId);
            }
        }

        linesUI.showLine(model.lastWinLine);
    }

    private function payTableUIHighLightComplete(event:Event):Void
    {
        if (highLightItemIndex < payTableModel.itemListWithPayout.length - 1)
        {
            highLightItemIndex++;
        } else
        {
            highLightItemIndex = 0;
        }

        highLightNext();
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
