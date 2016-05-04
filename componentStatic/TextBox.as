package componentStatic
{

	
	import componentStatic.TextBoxEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.SoftKeyboardType;
	import flash.utils.Timer;
	
	


	public class TextBox extends MovieClip
	{
		private var target:MovieClip;
		
		private var value:String;
		private var softKeyFormat:String,
					priceMode:Boolean;
		
		public function TextBox(target_p:MovieClip,value_p:String="",SoftKeyFormat_p:String = SoftKeyboardType.DEFAULT,clearAfterClicked_p:Boolean=false,PriceMode_p=false,ConvertArabic_p:Boolean=true,CorrectingArabicNumbers_p:Boolean=true,JustShowNativeText_p:Boolean=false)
		{
			target = target_p
			value = value_p
			softKeyFormat = SoftKeyFormat_p	
			priceMode = PriceMode_p	
			target.valueText.addEventListener(Event.CHANGE,changeTextBox_Fun);
			FarsiInputCorrection.clear(target.valueText)
			target.valueText.text = value
			FarsiInputCorrection.setUp(target.valueText,softKeyFormat,ConvertArabic_p,CorrectingArabicNumbers_p,clearAfterClicked_p,JustShowNativeText_p)

		}
		private function setValueText_fun():void
		{
			
			this.dispatchEvent(new TextBoxEvent(TextBoxEvent.TEXT,target.valueText.text));
		}
		public function reset():void
		{
			target.valueText.text=""
			setValueText_fun()
		}
		public function setValueTextByeCod_fun(Value_p:String):void
		{			
			FarsiInputCorrection.clear(target.valueText)
			target.valueText.text = Value_p
			FarsiInputCorrection.setUp(target.valueText)		

			setValueText_fun()
		}
		public function setText(Value_p:String):void
		{
			target.valueText.text = Value_p
		}
		private function changeTextBox_Fun(evt:Event):void
		{
			if(priceMode)
			{
				setPrice()
			}
			else
			{
				setValueText_fun()
			}
						
		}
		private function setPrice():void
		{	
			var valueSrt:String = target.valueText.text
				valueSrt = valueSrt.split(',').join('')
			this.dispatchEvent(new TextBoxEvent(TextBoxEvent.TEXT,valueSrt));
			target.valueText.text = SplitNumberRange.split(valueSrt,3,',',SplitNumberRange.RIGHT)
		}
	}
}