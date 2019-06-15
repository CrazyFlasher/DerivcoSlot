package com.simple.slot.view;

import com.simple.slot.models.payTable.IPayTableItemModelImmutable;
import com.simple.slot.models.reels.ISingleReelModelImmutable;
import com.simple.slot.models.payTable.IPayTableModelImmutable;
import com.simple.slot.models.reels.IReelsModelImmutable;
import com.simple.slot.models.app.IAppModelImmutable;
import com.simple.slot.context.IAppContextImmutable;
import com.simple.slot.models.app.AppModelEventType;
import com.simple.slot.models.payTable.PayTableModelEventType;
import com.simple.slot.models.reels.FixedResultVo;
import com.simple.slot.models.reels.ReelsModelEventType;
import com.simple.slot.view.ui.ButtonUI;
import com.simple.slot.view.ui.FixedModeUI;
import com.simple.slot.view.ui.PayTableUI;
import com.simple.slot.view.ui.PayTableUIEventType;
import com.simple.slot.view.ui.ReelUI;
import com.simple.slot.view.ui.ReelUIEventType;
import com.simple.slot.view.ui.WinLinesUI;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.utils.Assets;
import Std;

class AppView extends EventDispatcher
{
    public var highLightItemIndex(get, never):Int;

    public var fixedDataList(get, never):Array<FixedResultVo>;
    public var newBalanceValue(get, never):Int;
    public var newSpinCostValue(get, never):Int;

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
    private var fixedModelUI:FixedModeUI;

    private var _highLightItemIndex:Int;
    private var highLightedSymbolIdList:Array<String> = new Array<String>();

    private var _newBalanceValue:Int;
    private var _newSpinCostValue:Int;

    public function new(context:IAppContextImmutable, root:DisplayObjectContainer)
    {
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
        appModel.addEventListener(AppModelEventType.SPIN_COST_UPDATED, updateValues);

        container = new Sprite();
        root.addChild(container);

        assets = Assets.getMovieClip("ui:assets");
        container.addChild(assets);

        spinBtn = new ButtonUI(getSprite("spinBtn"));
        spinBtn.assets.addEventListener(MouseEvent.CLICK, spinBtnClick);

        balanceValueTf = getTextField("balanceValueTf");
        balanceValueTf.addEventListener(FocusEvent.FOCUS_OUT, balanceValueTfChanged);

        spinCostValueTf = getTextField("spinCostValueTf");
        spinCostValueTf.addEventListener(FocusEvent.FOCUS_OUT, spinCostValueTfChanged);

        payoutValueTf = getTextField("payoutValueTf");

        spinCostValueTf.restrict = balanceValueTf.restrict = "0-9";

        createReels();
        createPaytable();
        createWinLines();
        createFixedMode();

        updateValues();
    }

    private function createFixedMode():Void
    {
        fixedModelUI = new FixedModeUI(getSprite("fixedModePlaceHolder"));
    }

    private function spinCostValueTfChanged(event:FocusEvent):Void
    {
        _newSpinCostValue = Std.parseInt(spinCostValueTf.text);

        dispatchEvent(new Event(AppViewEventType.CHANGE_SPIN_COST));
    }

    private function balanceValueTfChanged(event:FocusEvent):Void
    {
        _newBalanceValue = Std.parseInt(balanceValueTf.text);

        dispatchEvent(new Event(AppViewEventType.CHANGE_BALANCE));
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

    private function spinBtnClick(event:Event):Void
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

        spinBtn.enabled = appModel.hasEnoughMoney;
    }

    private function startHighLight():Void
    {
        _highLightItemIndex = 0;

        highLightNext();
    }

    private function highLightNext():Void
    {
        var model:IPayTableItemModelImmutable = payTableModel.itemListWithPayout[_highLightItemIndex];
        payTableUI.highLightItem(model);

        untyped highLightedSymbolIdList.length = 0;

        for (reelUI in reelUIList)
        {
            reelUI.reset();

            var highLightedSymbolId:String = reelUI.highLightSymbol(model.symbolIdList, model.winLineId, highLightedSymbolIdList);
            if (highLightedSymbolId != null)
            {
                highLightedSymbolIdList.push(highLightedSymbolId);
            }
        }

        linesUI.showLine(model.winLineId);

        dispatchEvent(new Event(AppViewEventType.PAYTABLE_ITEM_HIGHLIGHTED));
    }

    private function payTableUIHighLightComplete(event:Event):Void
    {
        if (_highLightItemIndex < payTableModel.itemListWithPayout.length - 1)
        {
            _highLightItemIndex++;
        } else
        {
            _highLightItemIndex = 0;
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

    private function get_newBalanceValue():Int {
        return _newBalanceValue;
    }

    private function get_newSpinCostValue():Int {
        return _newSpinCostValue;
    }

    private function get_fixedDataList():Array<FixedResultVo> {
        return fixedModelUI.fixedDataList;
    }

    private function get_highLightItemIndex():Int
    {
        return _highLightItemIndex;
    }
}
