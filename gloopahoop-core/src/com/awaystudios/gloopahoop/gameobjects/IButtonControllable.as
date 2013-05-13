package com.awaystudios.gloopahoop.gameobjects
{
	public interface IButtonControllable
	{
		function get buttonGroup() : uint;
		function toggleOn() : void;
		function toggleOff() : void;
	}
}