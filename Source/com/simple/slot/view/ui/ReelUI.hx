package com.simple.slot.view.ui;

import ISingleReelModelImmutable;
import ISingleReelModelImmutable;
import Array;
import flash.geom.Rectangle;
import motion.Actuate;
import motion.easing.Back;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.utils.Dictionary;

class ReelUI extends UIClip {
    private var model:ISingleReelModelImmutable;

    private var symbolMap:Dictionary<String, Sprite>;
    private var symbolList:Array<Sprite>;
    private var visibleSymbolList:Array<Sprite>;

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
        visibleSymbolList = new Array<Sprite>();

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
        for (symbol in visibleSymbolList)
        {
            symbol.getChildByName("rect").visible = false;
        }
    }

    public function highLightSymbol(symbolIdList:Array<Dynamic>, lineId:String, shownSymbolList:Array<String>):String
    {
        reset();

        var symboldIndex:Int = 0;

        if (lineId == "center")
        {
            symboldIndex = 1;
        } else
        if (lineId == "bottom")
        {
            symboldIndex = 2;
        }

        for (symbolId in symbolIdList)
        {
            if (visibleSymbolList[symboldIndex].name == symbolId && !allSymbolsShown(shownSymbolList, symbolIdList, symbolId))
            {
                visibleSymbolList[symboldIndex].getChildByName("rect").visible = true;

                return symbolId;
            }
        }

        return null;
    }

    private function allSymbolsShown(shownSymbolList:Array<String>, allSymbolIdList:Array<Dynamic>, symbolId:String):Bool
    {
        var totalCount:Int = 0;
        var shownCount:Int = 0;

        for (shownId in shownSymbolList)
        {
            if (shownId == symbolId)
            {
                shownCount++;
            }
        }

        for (symId in allSymbolIdList)
        {
            if (symId == symbolId)
            {
                totalCount++;
            }
        }

        return shownCount == totalCount;
    }

    private function createSymbols(storeToMap:Bool):Void
    {
        var symbol:Sprite;
        for (symbolId in model.symbolList)
        {
            symbol = getSymbol("assets/reels/" + symbolId + ".png");
            symbol.name = symbolId;

            placeHolder.addChild(symbol);

            if (storeToMap)
            {
                symbolMap.set(symbolId, symbol);
            }

            symbolList.push(symbol);

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
        reset();

        var symbol:DisplayObject = symbolMap.get(model.symbolList[0]);
        var firstSymbolY:Float = symbol.y + symbol.height / 2;
        placeHolder.y = -firstSymbolY;

        untyped visibleSymbolList.length = 0;

        for (symbol in symbolList)
        {
            var bounds:Rectangle = symbol.getBounds(placeHolder);
            if (bounds.topLeft.y + placeHolder.y >= 0 && bounds.bottomRight.y + placeHolder.y < symbol.height * 4)
            {
                visibleSymbolList.push(symbol);
            }
        }

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

            Actuate.tween(placeHolder, 0.4, {y: -firstSymbolY}).onComplete(
                function():Void
                {
                    showResult(0);

                    dispatchEvent(new Event(ReelUIEventType.REEL_STOPPED));
                }
            ).ease(Back.easeOut);
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
