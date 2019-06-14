package com.simple.slot.view.ui;
import haxe.ui.core.UIEvent;
import haxe.ui.components.OptionBox;
import openfl.events.Event;
import openfl.events.TouchEvent;
import com.simple.slot.models.reels.FixedResultVo;
import haxe.ui.components.CheckBox;
import haxe.ui.components.DropDown;
import haxe.ui.components.Label;
import haxe.ui.constants.VerticalAlign;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.core.Component;
import haxe.ui.data.ArrayDataSource;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
class FixedModeUI extends UIClip {
    public var fixedDataList(get, never):Array<FixedResultVo>;

    private var _enabled:Bool;
    private var _fixedDataList:Array<FixedResultVo> = new Array<FixedResultVo>();

    private var itemsContainer:VBox;

    private var itemUIList:Array<FixedModeItemUI> = new Array<FixedModeItemUI>();

    public function new(assets:Sprite) {
        super(assets);
    }

    override private function init():Void {
        super.init();

        var main:VBox = new VBox();
        main.scaleX = main.scaleY = 1.5;
        main.addComponent(createHeader());

        //TODO: DropDown bug
        main.x = _assets.x;
        main.y = _assets.y;
        _assets.x = _assets.y = 0;

        itemsContainer = new VBox();

        var itemUI:FixedModeItemUI;
        for (i in 0...3)
        {
            itemUI = new FixedModeItemUI(i);
            itemsContainer.addComponent(itemUI.component);
            itemUIList.push(itemUI);
        }

        main.addComponent(itemsContainer);
        _assets.addChild(main);

        enable(false);
    }

    private function checkChanged(e:Event):Void
    {
        var check:CheckBox = cast (e.currentTarget, CheckBox);

        enable(check.selected);
    }

    private function enable(value:Bool):Void
    {
        _enabled = value;

        itemsContainer.mouseEnabled = itemsContainer.mouseChildren = value;
        itemsContainer.alpha = value ? 1 : 0.5;
    }

    private function createHeader():Component
    {
        var box:HBox = new HBox();
        box.paddingTop = 5;

        var label:Label = new Label();
        label.verticalAlign = VerticalAlign.CENTER;
        label.text = "Fixed results enabled:";
        var check:CheckBox = new CheckBox();
        #if mobile
            check.scaleX = check.scaleY = 1.5;
            box.paddingBottom = 5;
        #end

        check.verticalAlign = VerticalAlign.CENTER;
        check.addEventListener(MouseEvent.CLICK, checkChanged);

        box.addComponent(label);
        box.addComponent(check);

        return box;
    }

    private function get_fixedDataList():Array<FixedResultVo> {
        untyped _fixedDataList.length = 0;

        if (_enabled)
        {
            for (itemUI in itemUIList)
            {
                _fixedDataList.push(itemUI.fixedResult);
            }
        }

        return _fixedDataList;
    }
}

class FixedModeItemUI {

    public var fixedResult(get, never):FixedResultVo;
    public var component(get, never):Component;

    private var box:HBox;
    private var symbolDropDown:DropDown;
    private var positionDropDown:DropDown;

    public function new(index:Int)
    {
        box = new HBox();

        var label:Label = new Label();
        label.verticalAlign = VerticalAlign.CENTER;
        label.text = "Reel " + (index + 1) + ":";

        var symbolId:Label = new Label();
        symbolId.verticalAlign = VerticalAlign.CENTER;
        symbolId.text = "Symbol";

        symbolDropDown = new DropDown();
        symbolDropDown.width = 90;
        symbolDropDown.listSize = 5;
        #if mobile
            symbolDropDown.listSize = 4;
        #end

        var data:ArrayDataSource<Dynamic> = new ArrayDataSource<Dynamic>();
        for (symbolId in ["3xBAR", "BAR", "2xBAR", "7", "CHERRY"])
        {
            data.add({value: symbolId});
        }
        symbolDropDown.dataSource = data;
        symbolDropDown.selectedIndex = 0;

        var positionLbl:Label = new Label();
        positionLbl.verticalAlign = VerticalAlign.CENTER;
        positionLbl.text = "on";

        positionDropDown = new DropDown();
        positionDropDown.width = 90;
        positionDropDown.listSize = 3;
        #if mobile
            positionDropDown.listSize = 2;
        #end

        var positionData:ArrayDataSource<Dynamic> = new ArrayDataSource<Dynamic>();
        for (line in [{lineId: "TOP", position: 1}, {lineId: "CENTER", position: 2}, {lineId: "BOTTOM", position: 3}])
        {
            positionData.add({value: line.lineId, position: line.position});
        }

        positionDropDown.dataSource = positionData;
        positionDropDown.selectedIndex = 0;

        var line:Label = new Label();
        line.verticalAlign = VerticalAlign.CENTER;
        line.text = "line";

        box.addComponent(label);
        box.addComponent(symbolId);
        box.addComponent(symbolDropDown);
        box.addComponent(positionLbl);
        box.addComponent(positionDropDown);
        box.addComponent(line);
    }

    private function get_fixedResult():FixedResultVo {
        return new FixedResultVo(symbolDropDown.value.toString(), positionDropDown.selectedItem.position);
    }

    private function get_component():Component {
        return box;
    }
}
