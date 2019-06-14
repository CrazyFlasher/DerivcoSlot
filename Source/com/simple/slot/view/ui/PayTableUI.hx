package com.simple.slot.view.ui;

import com.simple.slot.models.payTable.IPayTableItemModelImmutable;
import com.simple.slot.models.payTable.IPayTableModelImmutable;
import flash.text.TextFieldAutoSize;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;
import openfl.utils.Timer;

class PayTableUI extends UIClip
{

    private var model:IPayTableModelImmutable;

    private var itemUIList:Array<PayTableItemUI>;

    private var highLightTimer:Timer;

    public function new(assets:Sprite, model:IPayTableModelImmutable)
    {
        this.model = model;

        super(assets);
    }

    override private function init():Void
    {
        super.init();

        highLightTimer = new Timer(1000, 1);
        highLightTimer.addEventListener(TimerEvent.TIMER_COMPLETE, highLightTimerComplete);

        itemUIList = new Array<PayTableItemUI>();

        var itemUI:PayTableItemUI;
        var nextY:Float = 0;
        for (itemModel in model.payTableListImmutable)
        {
            itemUI = new PayTableItemUI(new Sprite(), itemModel);
            itemUI.assets.y = nextY;

            _assets.addChild(itemUI.assets);
            itemUIList.push(itemUI);

            nextY += itemUI.assets.height;
        }
    }

    private function highLightTimerComplete(event:TimerEvent):Void
    {
        dispatchEvent(new Event(PayTableUIEventType.HIGHLIGHT_COMPLETE));
    }

    public function reset():Void
    {
        highLightTimer.reset();

        for (itemUI in itemUIList)
        {
            itemUI.showHighLight(false);
        }
    }

    public function highLightItem(model:IPayTableItemModelImmutable):Void
    {
        reset();

        for (itemUI in itemUIList)
        {
            if (itemUI.model == model)
            {
                itemUI.showHighLight(true);

                highLightTimer.start();

                break;
            }
        }
    }
}

class PayTableItemUI extends UIClip
{
    public var model(get, never):IPayTableItemModelImmutable;

    private var _model:IPayTableItemModelImmutable;

    private var highLightRect:Sprite;

    private var _showHighLight:Bool;

    private var blinkTimer:Timer;

    public function new(assets:Sprite, model:IPayTableItemModelImmutable)
    {
        _model = model;

        super(assets);
    }

    override private function init():Void
    {
        super.init();

        blinkTimer = new Timer(250);
        blinkTimer.addEventListener(TimerEvent.TIMER, onTimer);

        var tf:TextField;
        var bitmap:Bitmap;
        var nextX:Float = 0;
        var symbolId:String;
        for (i in 0..._model.symbolIdList.length)
        {
            symbolId = _model.symbolIdList[i];
            bitmap = new Bitmap(Assets.getBitmapData("assets/reels/" + symbolId + ".png"));
            bitmap.smoothing = true;
            bitmap.scaleX = bitmap.scaleY = 0.3;

            _assets.addChild(bitmap);

            bitmap.x = nextX;
            nextX += bitmap.width;

            if (i < _model.symbolIdList.length - 1)
            {
                tf = getNewTf("+");
                _assets.addChild(tf);

                tf.x = nextX;
                nextX += tf.width;
            }
        }

        tf = getNewTf("on " + (_model.lineId == null ? "any" : _model.lineId) + " line = " + _model.payout);
        _assets.addChild(tf);

        tf.x = nextX;

        createHighLight();
    }

    private function createHighLight():Void
    {
        highLightRect = new Sprite();

        var graphics:Graphics = highLightRect.graphics;
        graphics.lineStyle(2, 0xff0000);
        graphics.drawRect(0, 0, _assets.width, _assets.height);
        graphics.endFill();

        _assets.addChild(highLightRect);
        highLightRect.visible = false;
    }

    private function getNewTf(text:String):TextField
    {

        var tf:TextField = new TextField();
        tf.defaultTextFormat = new TextFormat("Arial", 18);
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.text = text;

        return tf;
    }

    public function showHighLight(value:Bool):Void
    {
        _showHighLight = value;

        value ? blinkTimer.start() : blinkTimer.reset();

        hideOrShowHighLight();
    }

    private function onTimer(event:TimerEvent):Void
    {
        hideOrShowHighLight();
    }

    private function hideOrShowHighLight():Void
    {
        highLightRect.visible = !highLightRect.visible && _showHighLight;
    }

    private function get_model():IPayTableItemModelImmutable
    {
        return _model;
    }
}
