package;

import haxe.ui.backend.ToolkitOptions;
import com.simple.slot.context.AppContext;
import haxe.ui.Toolkit;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.geom.Rectangle;
import utils.RectangleUtil;
import utils.ScaleMode;

class Main extends Sprite
{
	private var visibleRect:Rectangle = new Rectangle(0, 0, 1280, 720);
	private var stageRect:Rectangle = new Rectangle();
	private var outRect:Rectangle = new Rectangle();

	private var viewRoot:DisplayObjectContainer = new Sprite();

	public function new()
	{
		super();

		addChild(viewRoot);

		scaleContent();

		Toolkit.init();

		new AppContext(viewRoot);
	}

	private function scaleContent():Void
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;

		var fill:Sprite = new Sprite();
		fill.graphics.beginFill(0, 0.0);
		fill.graphics.drawRect(0, 0, visibleRect.width, visibleRect.height);
		fill.graphics.endFill();
        addChild(fill);

		stage.addEventListener(Event.RESIZE, onResize);
        onResize();
	}

	private function onResize(event:Event = null):Void
	{
		removeChild(viewRoot);

		stageRect.width = stage.stageWidth;
		stageRect.height = stage.stageHeight;

		RectangleUtil.fit(visibleRect, stageRect, ScaleMode.SHOW_ALL, false, outRect);

		x = outRect.x;
		y = outRect.y;
		width = outRect.width;
		height = outRect.height;

		addChild(viewRoot);

		trace(stage.stageHeight);
	}
}
