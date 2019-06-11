package com.derivco.slot.view.ui;

import openfl.Lib;
import motion.Actuate;
import openfl.events.Event;
import openfl.utils.Dictionary;
import com.derivco.slot.models.reels.ISingleReelModelImmutable;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

class ReelUI extends UIClip {
    private var model:ISingleReelModelImmutable;

    private var symbolMap:Dictionary<String, DisplayObject>;

    private var placeHolder:Sprite;
    private var symbolY:Float;

    public function new(assets:Sprite) {
        super(assets);
    }

    override private function init():Void
    {
        super.init();

        placeHolder = cast(_assets.getChildByName("placeHolder"), Sprite);
    }

    public function update(model:ISingleReelModelImmutable):Void
    {
        clear();

        this.model = model;

        symbolY = 0;
        for (i in 0...3)
        {
            createSymbols(i == 1);
        }

        showResult(0);
    }

    private function createSymbols(storeToMap:Bool):Void
    {
        var symbol:Bitmap;
        for (symbolId in model.symbolList)
        {
            symbol = new Bitmap(Assets.getBitmapData("assets/reels/" + symbolId + ".png"));
            placeHolder.addChild(symbol);
            if (storeToMap)
            {
                symbolMap.set(symbolId, symbol);
            }

            symbol.y = symbolY;
            symbolY += symbol.height;
        }
    }

    public function showResult(spinTime:Float):Void
    {
        var symbol:DisplayObject = symbolMap.get(model.symbolList[0]);
        var firstSymbolY:Float = symbol.y + symbol.height / 2;
        placeHolder.y = -firstSymbolY;

        animate(spinTime);
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

            Actuate.tween(placeHolder, 0.5, {y: -firstSymbolY});
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

    private function clear():Void
    {
        symbolMap = new Dictionary();

        for (symbol in symbolMap)
        {
            placeHolder.removeChild(symbolMap.get(symbol));
        }
    }
}
