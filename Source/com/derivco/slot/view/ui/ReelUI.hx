package com.derivco.slot.view.ui;

import openfl.display.Graphics;
import com.derivco.slot.models.reels.ISingleReelModelImmutable;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.utils.Dictionary;

class ReelUI extends UIClip {
    private var model:ISingleReelModelImmutable;

    private var symbolMap:Dictionary<String, Sprite>;
    private var symbolList:Array<Sprite>;

    private var placeHolder:Sprite;
    private var symbolY:Float;

    public function new(assets:Sprite, model:ISingleReelModelImmutable) {
        this.model = model;

        super(assets);
    }

    override private function init():Void
    {
        super.init();

        symbolMap = new Dictionary();
        symbolList = new Array<Sprite>();

        placeHolder = cast(_assets.getChildByName("placeHolder"), Sprite);

        symbolY = 0;
        for (i in 0...3)
        {
            createSymbols(i == 1);
        }

        showResult(0);
    }

    public function reset():Void
    {
        for (symbolId in symbolMap)
        {
            var symbol:Sprite = symbolMap.get(symbolId);
            symbol.getChildByName("rect").visible = false;
        }
    }

    public function highLightSymbol(symbolId:String, position:Int):Bool
    {
        reset();

        if (symbolList[position + 1] == symbolId)
        {
            symbolList[position + 1].getChildByName("rect").visible = true;

            return true;
        }

        return false;
    }

    private function createSymbols(storeToMap:Bool):Void
    {
        var symbol:Sprite;
        for (symbolId in model.symbolList)
        {
            symbol = getSymbol("assets/reels/" + symbolId + ".png");

            placeHolder.addChild(symbol);
            if (storeToMap)
            {
                symbolMap.set(symbolId, symbol);
                symbolList.push(symbol);
            }

            symbol.y = symbolY;
            symbolY += symbol.height;
        }
    }

    private function getSymbol(assetId:String):Sprite
    {
        var sym:Sprite = new Sprite();
        var bitmap:Bitmap = new Bitmap(Assets.getBitmapData(assetId));

        sym.addChild(bitmap);

        var rect:Sprite = new Sprite();
        rect.visible = false;
        rect.name = "rect";

        var g:Graphics = rect.graphics;
        g.lineStyle(10, 0xff0000);
        g.drawRect(0, 0, sym.width, sym.height);
        g.endFill();

        sym.addChild(rect);

        return sym;
    }

    public function showResult(spinTime:Float):Void
    {
        var symbol:DisplayObject = symbolMap.get(model.symbolList[0]);
        var firstSymbolY:Float = symbol.y + symbol.height / 2;
        placeHolder.y = -firstSymbolY;

        if (spinTime > 0)
        {
            animate(spinTime);
        }
    }

    private function animate(spinTime:Float):Void
    {
        _assets.addEventListener(Event.ENTER_FRAME, enterFrame);

        Lib.setTimeout(function():Void{
            _assets.removeEventListener(Event.ENTER_FRAME, enterFrame);

            var symbol:DisplayObject = symbolMap.get(model.symbolList[0]);
            var firstSymbolY:Float = symbol.y + symbol.height / 2;

            if (firstSymbolY - placeHolder.y > symbol.height * model.symbolList.length)
            {
                firstSymbolY -= symbol.height * model.symbolList.length;
            }

            Actuate.tween(placeHolder, 0.5, {y: -firstSymbolY}).onComplete(
                function():Void
                {
                    showResult(0);

                    dispatchEvent(new Event(ReelUIEventType.REEL_STOPPED));
                }
            );
        }, Std.int(spinTime * 1000));
    }

    private function enterFrame(event:Event):Void
    {
        placeHolder.y += 35;
        if (placeHolder.y > 0)
        {
            placeHolder.y = -10 * 121;
        }
    }
}
