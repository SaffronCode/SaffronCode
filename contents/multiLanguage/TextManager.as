package contents.multiLanguage
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	internal class TextManager
	{
		private static var texts:Vector.<TextField> = new Vector.<TextField>(),
							TextManagers:Vector.<TextManager> = new Vector.<TextManager>();
		
		public static function addThis(tf:TextField):TextManager
		{
			return new TextManager(tf);
		}
		
		
		public var _format:TextFormat ;
		
		public function get format():TextFormat
		{
			var f:TextFormat = _format ;
			var copiedFormat:TextFormat = new TextFormat(f.font,f.size,f.color,f.bold,f.italic,f.underline,f.url,f.target,f.align,f.leftMargin,f.rightMargin,f.indent,f.leading);
			//trace("Format copied : "+copiedFormat.font);
			return copiedFormat ;
		}
		
		public function TextManager(tf:TextField)
		{
			var I:int = texts.indexOf(tf);
			if(I==-1)
			{
				//trace("******** This is a new text");
				tf.addEventListener(Event.REMOVED_FROM_STAGE,removeThisText);
				
				var f:TextFormat = tf.defaultTextFormat ;
				_format = new TextFormat(f.font,f.size,f.color,f.bold,f.italic,f.underline,f.url,f.target,f.align,f.leftMargin,f.rightMargin,f.indent,f.leading);
				
				texts.push(tf);
				TextManagers.push(this);
			}
			else
			{
				//trace("******** This text is old");
				_format = TextManagers[I].format ;
			}
		}
		
		protected function removeThisText(event:Event):void
		{
			
			var tf:TextField = event.currentTarget as TextField ;
			var I:int = texts.indexOf(tf);
			if(I!=-1)
			{
				trace("Some fonts removed form stage now");
				texts.splice(I,1);
				TextManagers.splice(I,1);
			}
		}
	}
}