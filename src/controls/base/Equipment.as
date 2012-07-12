package controls.base
{
	import flash.events.*;
	
	import sandy.core.scenegraph.Geometry3D;
	import sandy.core.scenegraph.Shape3D;
	import sandy.core.scenegraph.TransformGroup;
	import sandy.materials.Appearance;
	import sandy.materials.attributes.*;
	import sandy.parser.*;
	import sandy.util.*;
	
	public class Equipment extends TransformGroup
	{
		protected var parserStack:ParserStack;
		protected var loaderQueue:LoaderQueue;
		private var filePath:*;
		private var parserType:String;
		private var textureXtension:String;
		private var modelScale:Number;
		public static var PARSER_COMPLETE:String="parserComplete";
		public static var PARSER_ERROR:String="parserError";
		private var parserDone:Boolean=false;
		private var model3D:Shape3D;
		
		public function Equipment(p_sName:String="",p_sFile:*=null,p_sParserType:String='3DS',p_sTextureX:String='JPG',p_nScale:Number=1)
		{
			super(p_sName);
			filePath=p_sFile;
			parserType=p_sParserType;
			textureXtension=p_sTextureX;
			modelScale=p_nScale;
			
			if(filePath!=null)
			{
				var parser:IParser=Parser.create(filePath,parserType,modelScale,textureXtension);
				parserStack=new ParserStack();
				parserStack.add(this.name,parser);
				parserStack.addEventListener(ParserStack.COMPLETE,parserComplete);
				parserStack.start();
			}
			else
			{
				parserStack.dispatchEvent.call(this,new Event(Equipment.PARSER_ERROR));
			}
		}
		
		public function get FilePath():*
		{
			return filePath;
		}
		
		public function get ParserType():String
		{
			return parserType;
		}
		
		public function get TextureExtension():String
		{
			return textureXtension;
		}
		
		public function get ModelScale():Number
		{
			return modelScale;
		}
		
		public function get ParserComplete():Boolean
		{
			return parserDone;
		}
		
		public function get Model3D():Shape3D
		{
			return model3D;
		}
		
		protected function parserComplete(evt:Event):void
		{
			var materialAttr:MaterialAttributes = new MaterialAttributes(
				new LineAttributes( 0, 0x2111BB, 0 ),
				new LightAttributes( true, 0.1)
			);
			model3D=parserStack.getGroupByName(this.name).children[0] as Shape3D;
			model3D.appearance.lightingEnable=true;
			model3D.material.attributes=materialAttr;
			model3D.x=0;
			model3D.y=0;
			this.addChild(model3D);
			parserStack.dispatchEvent.call(this,new Event(Equipment.PARSER_COMPLETE));
		}
	}
}






