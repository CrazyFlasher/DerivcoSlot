package;

import com.derivco.slot.context.AppContext;
import haxe.ui.Toolkit;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Toolkit.init();
		new AppContext(this);
	}
}
