package com.awaystudios.gloopahoop.gameobjects.components
{

	import away3d.*;
	import away3d.animators.*;
	import away3d.animators.data.*;
	import away3d.animators.nodes.*;
	import away3d.core.base.*;
	import away3d.entities.*;

	use namespace arcane;

	public class VertexAnimationComponent
	{
		private var _animator : VertexAnimator;
		private var _animationSet : VertexAnimationSet;
		
		public function VertexAnimationComponent(mesh : Mesh)
		{
			_animationSet = new VertexAnimationSet(2, VertexAnimationMode.ABSOLUTE);
			
			_animator = new VertexAnimator(_animationSet);
			
			mesh.animator = _animator;
		}
		
		
		public function play(sequenceName : String, offset:Number = NaN) : void
		{
			_animator.play(sequenceName, null, offset);
		}
		
		public function stop() : void
		{
			_animator.stop();
		}
		
		public function addClip(name : String, frames : Array, frameDuration : uint = 200, loop : Boolean = true) : void
		{
			var frame : Geometry;
			var clip : VertexClipNode;
			clip = new VertexClipNode();
			clip.name = name;
			clip.looping = loop;
			for each (frame in frames) {
				clip.addFrame(frame, frameDuration);
				// avoid hick ups during game play ( assumes 1 subgeom per geom )
//				var vertexDummy:VertexBuffer3D = frame.subGeometries[ 0 ].getVertexBuffer( GameScreen.instance.view.stage3DProxy );
//				var indexDummy:IndexBuffer3D = frame.subGeometries[ 0 ].getIndexBuffer( GameScreen.instance.view.stage3DProxy );
//				GameScreen.instance.view.stage3DProxy._context3D.setVertexBufferAt( 0, vertexDummy );
			}
			
			_animationSet.addAnimation(clip);
//			_animator.play(name);
		}
	}
}