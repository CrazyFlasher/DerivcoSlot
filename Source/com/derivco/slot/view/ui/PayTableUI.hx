package com.derivco.slot.view.ui;
import com.derivco.slot.models.payTable.IPayTableItemModelImmutable;
import com.derivco.slot.models.payTable.IPayTableModelImmutable;
import flash.text.TextFieldAutoSize;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;
class PayTableUI extends UIClip {

    private var model:IPayTableModelImmutable;

    public function new(assets:Sprite, model:IPayTableModelImmutable) {
        this.model = model;

        super(assets);
    }

    override private function init():Void {
        super.init();

        var itemUI:PayTableItemUI;
        var nextY:Float = 0;
        for (itemModel in model.payTableListImmutable)
        {
            itemUI = new PayTableItemUI(new Sprite(), itemModel);
            itemUI.assets.y = nextY;

            _assets.addChild(itemUI.assets);

            nextY += itemUI.assets.height;
        }
    }
}

class PayTableItemUI extends UIClip
{
    private var model:IPayTableItemModelImmutable;

    public function new(assets:Sprite, model:IPayTableItemModelImmutable) {
        this.model = model;

        super(assets);
    }

    override private function init():Void {
        super.init();

        var tf:TextField;
        var bitmap:Bitmap;
        var nextX:Float = 0;
        var symbolId:String;
        for (i in 0...model.symbolIdList.length)
        {
            symbolId = model.symbolIdList[i];
            bitmap = new Bitmap(Assets.getBitmapData("assets/reels/" + symbolId + ".png"));
            bitmap.smoothing = true;
            bitmap.height = bitmap.width = 28;

            _assets.addChild(bitmap);

            bitmap.x = nextX;
            nextX += bitmap.width;

            if (i < model.symbolIdList.length - 1)
            {
                tf = getNewTf("+");
                _assets.addChild(tf);

                tf.x = nextX;
                nextX += tf.width;
            }
        }

        tf = getNewTf("on " + (model.lineId == null ? "any" : model.lineId) + " line = " + model.payout);
        _assets.addChild(tf);

        tf.x = nextX;
    }

    private function getNewTf(text:String):TextField {

        var tf:TextField = new TextField();
        tf.defaultTextFormat = new TextFormat("Arial", 16);
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.text = text;

        return tf;
    }
}
