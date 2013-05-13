package
{
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.utils.*;
	
	import flash.display.*;
	
	[SWF(backgroundColor="#000000", frameRate="60")]
	public class Main extends Sprite
	{
		public function Main()
		{
			addChild(new GameContainer(new BrowserSaveStateManager()));
		}
	}
}