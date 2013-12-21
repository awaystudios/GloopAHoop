package com.awaystudios.gloopahoop.utils
{
	public class EmbeddedResources
	{
		// Gloop
		[Embed("/../resources/gloop/flying/flying.awd", mimeType="application/octet-stream")]
		public static var FlyingAWDAsset : Class;
		
		[Embed("/../resources/gloop/splat/splat.3ds", mimeType="application/octet-stream")]
		public static var GloopSplat3DSAsset : Class;
		
		[Embed("/../resources/gloop/splat/diff.png")]
		public static var GloopSplatDiffusePNGAsset : Class;

		//

		[Embed("/../resources/gloop/snotblob_Smile-Grin.png")]
		public static var GloopDiffuseSmileGrin:Class;

		[Embed("/../resources/gloop/snotblob_Sad.png")]
		public static var GloopDiffuseSad:Class;

		[Embed("/../resources/gloop/snotblob_Ouch.png")]
		public static var GloopDiffuseOuch:Class;

		[Embed("/../resources/gloop/snotblob_Yipeee.png")]
		public static var GloopDiffuseYippee:Class;

		//

//		[Embed("/../resources/gloop/diff.png")]
//		public static var GloopDiffusePNGAsset : Class;

//		[Embed("/../resources/gloop/spec.png")]
//		public static var GloopSpecularPNGAsset : Class;

		
		// Cannon
		[Embed("/../resources/cannon/cannon4.3ds", mimeType="application/octet-stream")]
		public static var Cannon3DSAsset : Class;
		
		[Embed("/../resources/cannon/diff4.png")]
		public static var CannonDiffusePNGAsset : Class;
		
		
		// Target
		[Embed("/../resources/props/target/target.3ds", mimeType="application/octet-stream")]
		public static var Target3DSAsset : Class;
		
		[Embed("/../resources/props/target/diff.png")]
		public static var TargetDiffusePNGAsset : Class;


		// Boxes
		[Embed("/../resources/props/box/box.awd", mimeType="application/octet-stream")]
		public static var Box3DSAsset : Class;

		[Embed("/../resources/props/box/BOX-DM.png")]
		public static var BoxDiffusePNGAsset : Class;
		
		
		// Monitor
		[Embed("/../resources/props/monitor/monitor.3ds", mimeType="application/octet-stream")]
		public static var Monitor3DSAsset : Class;
		
		[Embed("/../resources/props/monitor/MONITORS_1_2_512.png")]
		public static var MonitorDiffusePNGAsset : Class;
		
		
		// Misc props
		[Embed("/../resources/props/fan/fan.3ds", mimeType="application/octet-stream")]
		public static var Fan3DSAsset : Class;
		
		[Embed("/../resources/props/fan/PROPELLER_128.png")]
		public static var FanDiffusePNGAsset : Class;
		
		[Embed("/../resources/props/button/button.3ds", mimeType="application/octet-stream")]
		public static var Button3DSAsset : Class;
		
		[Embed("/../resources/props/star/star.3ds", mimeType="application/octet-stream")]
		public static var Star3DSAsset : Class;
		
		[Embed("/../resources/props/hoop/hoop.3ds", mimeType="application/octet-stream")]
		public static var Hoop3DSAsset : Class;
	}
}