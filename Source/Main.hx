package;

import openfl.display.StageScaleMode;
import com.derivco.slot.context.AppContext;
import haxe.ui.Toolkit;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

//		stage.scaleMode = StageScaleMode.SHOW_ALL;

		Toolkit.init();
		new AppContext(this);
	}
}
