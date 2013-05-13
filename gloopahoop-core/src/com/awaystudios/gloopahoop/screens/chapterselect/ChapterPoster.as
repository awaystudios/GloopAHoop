package com.awaystudios.gloopahoop.screens.chapterselect
{
	
	import com.awaystudios.gloopahoop.level.*;
	import com.away3d.gloop.lib.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;

	public class ChapterPoster extends Sprite
	{
		private var _ui : ChapterPosterUI;
		private var _data : ChapterData;
		
		public function ChapterPoster(w:uint, h:uint, data : ChapterData)
		{
			super();
			
			_data = data;
			
			//calc bitmap scaling based on screen w & h
			var bitmapScale:Number = h/768;
			var bmp:Bitmap;
			
			if (bitmapScale > 1) {
				bmp = _data.posterBitmap;
				//bmp.scaleX = bitmapScale; TODO: sort out slow displaylist on retina display
				//bmp.scaleY = bitmapScale;
			} else {
				bmp = new Bitmap(new BitmapData(_data.posterBitmap.width*bitmapScale, _data.posterBitmap.height*bitmapScale, true, 0x0), "auto", true);
				bmp.bitmapData.draw(_data.posterBitmap, new Matrix(bitmapScale, 0, 0, bitmapScale));
			}
			
			bmp.x = -(bmp.width/2);
			bmp.y = -(bmp.height/2);
			addChild(bmp);
			
			_ui = new ChapterPosterUI();
			_ui.titleTextfield.autoSize = TextFieldAutoSize.LEFT;
			_ui.titleTextfield.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, "center");
			_ui.titleTextfield.text = _data.title;
			_ui.scaleX = bitmapScale;
			_ui.scaleY = bitmapScale;
			_ui.x = -(_ui.width/2);
			_ui.y = bmp.getBounds(this).bottom - 40;
			addChild(_ui);
			
			//enable hardware acceleration on rendering of chapter poster
			//cacheAsBitmap = true;
		}
		
		
		public function get chapterData() : ChapterData
		{
			return _data;
		}
	}
}