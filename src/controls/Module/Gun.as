package controls.Module
{
	import controls.base.Equipment;
	import sandy.parser.Parser;
	import flash.filesystem.File;
	
	public class Gun extends Equipment
	{
		public function Gun(p_sName:String="")
		{
			super(p_sName, File.applicationDirectory.nativePath.toString()+"/asset/mar_rifle.3ds",Parser.MAX_3DS, "JPG",1);
		}
	}
}