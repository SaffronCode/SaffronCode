package contents.displayElements
	//contents.displayElements.LanguageUpdatorButton
{
	import appManager.event.AppEventContent;
	
	import contents.Contents;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class LanguageUpdatorButton extends MovieClip
	{
		private var myID:String ;
		
		public function LanguageUpdatorButton()
		{
			super();
			if(Contents.hasThisLanguage(this.name))
			{
				this.buttonMode = true ;
				this.addEventListener(MouseEvent.CLICK,changeToThisFont);
			}
		}
		
		private function changeToThisFont(e:MouseEvent)
		{
			Contents.changeLanguage(this.name);
			this.dispatchEvent(new AppEventContent(Contents.homeLink,false));
		}
	}
}