package com.awaystudios.gloopahoop.screens
{
	
	import com.away3d.gloop.lib.*;
	
	import flash.display.*;
	import flash.geom.*;

	public class LoadingScreen extends ScreenBase
	{
		private var _bmp : Bitmap;
		
		public function LoadingScreen()
		{
			super();
			
			_musicTheme = null;
		}
		
		
		protected override function initScreen() : void
		{
			var bitmapScale:Number = _h/768;
			
			var loadingBitmap:Bitmap = new Bitmap(new LoadingBitmap(), "auto", true);
			var bmp:Bitmap = new Bitmap(new BitmapData(loadingBitmap.width*bitmapScale, loadingBitmap.height*bitmapScale, true, 0x0));
			
			bmp.smoothing = true;
			bmp.bitmapData.draw(loadingBitmap, new Matrix(bitmapScale, 0, 0, bitmapScale));
			bmp.x = -(bmp.width/2);
			bmp.y = -(bmp.height/2);
			_ctr.addChild(bmp);
		}
	}
}