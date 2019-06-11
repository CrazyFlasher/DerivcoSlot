package;

import com.derivco.slot.context.AppContext;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		new AppContext(this);
	}
}
