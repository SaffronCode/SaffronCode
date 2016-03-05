package tableManager.data
{
	import eventMovie.ThumbnailEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import tableManager.graphic.Align;
	import tableManager.graphic.Cell;
	import tableManager.graphic.Language;
	import tableManager.graphic.Location;

	public class Paragraph extends MovieClip
	{
		private var _text:String;
		public function get text():String
		{
			return _text
		}
		public function set text(value:String):void
		{
			_text = value
		}
		private var _font:String;
		public function get font():String
		{
			return _font
		}
		public function set font(value:String):void
		{
			_font = value	
		}
		private var _fontSize:int;
		public function get fontSize():int
		{
			return _fontSize
		}
		public function set fontSize(value:int):void
		{
			_fontSize = value
		}
		private var _fontColor:uint;
		public function get fontColor():uint
		{
			return _fontColor
		}
		public function set fontColor(value:uint):void
		{
			_fontColor = value
		}
		private var _align:String;
		public function get align():String
		{
			return _align
		}
		public function set align(value:String):void
		{
			_align = value
		}
		private var _autoSize:String;
		public function get autoSize():String
		{
			return _autoSize
		}
		public function set autoSize(value:String):void
		{
			_autoSize = value
		}
		private var _width:Number
		public function get widthFont():Number
		{
			return _width
		}
		public function set widthFont(value:Number):void
		{
			_width = value
		}
		private var _language:String;
		public function language():String
		{
			return _language
		}
		private var _justify:Boolean;
		public function get justify():Boolean
		{
			return _justify
		}
		public function Paragraph(Text_p:String,Font_p:String,FontSize_p:int,Width_p:Number,FontColor_p:uint,Align_p:String,AutoSize_p:String,Language_p:String = "farsi",Justify_p:Boolean=true)
		{
			_text = Text_p
			_font = Font_p
			_fontSize = FontSize_p
			_fontColor = FontColor_p
			_align = Align_p
			_autoSize = AutoSize_p
			_width = Width_p
			_language = Language_p
			_justify = Justify_p
			this.dispatchEvent(new ThumbnailEvent(ThumbnailEvent.THUMB_CLICKED,"test value"))

		}
		public function getTextField(locationCell_p:Location,ClumSpan_p:Boolean,RowSpan_p:Boolean,Fix_p:Boolean,Cell_p:Cell):TextField
		{
			
			var textFormat:TextFormat = new TextFormat()
	
			textFormat.font = _font
			textFormat.size = _fontSize
				
			textFormat.color = _fontColor
				
			textFormat.align = _align
					
				
			var newTextField = new TextField();
			newTextField.text = '-';
			newTextField.defaultTextFormat = textFormat;

			newTextField.multiline = true
			newTextField.selectable = false;
			newTextField.wordWrap = true
				
			if(!ClumSpan_p && Fix_p && Cell_p.LoacationCell==null)
			{
				newTextField.width = locationCell_p.rectangle.width
			}
			else if(!ClumSpan_p && Cell_p.LoacationCell!=null && Fix_p)
			{
				newTextField.width = Cell_p.LoacationCell.rectangle.width
			}
			else if(!Fix_p)
			{
				newTextField.width = _width
			}
			
			
			if(!RowSpan_p  && Fix_p)
			{
				//_bitmap.height = _locationCell.rectangle.height
			}

				
				
			
	
		
			newTextField.height = newTextField.textHeight
		
			newTextField.autoSize = _autoSize
				
			newTextField.embedFonts = true;
			
		

			if(_language == Language.FARSI)
			{
				UnicodeStatic.htmlText(newTextField,_text,false,false,_justify);
			}
			else if(_language == Language.ENGLISH)
			{
				newTextField.text = _text
			}
				
			return 	newTextField
		}
		public function thm():void
		{
			
		}
		
	}
}