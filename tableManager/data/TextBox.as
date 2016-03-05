package tableManager.data
{
	import eventMovie.ThumbnailEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;


	public class TextBox extends MovieClip
	{
		private var target:MovieClip;
		
		private var value:String;
		
		public function TextBox(target_p:MovieClip,value_p:String="")
		{
			
			var textFormat:TextFormat = new TextFormat()
				
			textFormat.font = CreatPage.target.Font;
			textFormat.size = CreatPage.target.Size
			textFormat.color = CreatPage.target.Color
			if(CreatPage.target.Format == "en")textFormat.align = "justify"
			if(CreatPage.target.Format == "fa")textFormat.align = CreatPage.target.AlignParag
			var newTextField = new TextField();
			newTextField.text = '-';
			newTextField.defaultTextFormat = textFormat;

			
			
			
			
			target = target_p
			value = value_p
			target.valueText.addEventListener(Event.CHANGE,changeTextBox_Fun);
			FarsiInputCorrection.clear(target.valueText)
			target.valueText.text = value
			FarsiInputCorrection.setUp(target.valueText)		
		}
		private function setValueText_fun():void
		{
			this.dispatchEvent(new ThumbnailEvent(ThumbnailEvent.THUMB_CLICKED,target.valueText.text));
		}
		public function reset():void
		{
			target.valueText.text=""
			setValueText_fun()
		}
		private function changeTextBox_Fun(evt:Event):void
		{
			setValueText_fun()			
		}
	}
}