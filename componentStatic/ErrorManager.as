package componentStatic
{
	import contents.Contents;
	
	import flash.display.MovieClip;
	

	public class ErrorManager extends MovieClip
	{
		public static const MOBILE:String = "MOBILE";
		public static const EMAIL:String = "EMAIL";
		public static const TEL:String = "TEL";	
		public static const PRICE:String = "PRICE";
		public static const DATE:String = "DATE";
		public static const EMPTY:String = "EMPTY"
		public static const DATE_ERROR:String = "DATE_ERROR"	
		public static var ignoreList:Array;	
		
		public static const noErrorId:int=0
		public static const mobileId:int = 1
		public static const emailId:int = 2
		public static const telId:int = 3
		public static const priceId:int = 4
		public static const dateId:int = 5
		public static const filedEmptyId:int = 6
		
			
			
		
		private var messageTitle:Array = new Array()
		private static var errorObj:Object;	
		public function ErrorManager()
		{	
			if(Contents.lang.t.noErrorId!=null)
			{
				messageTitle[noErrorId]= Contents.lang.t.noErrorId;
			}
			else
			{
				messageTitle[noErrorId]= 'هیچ خطایی در سیستم رخ نداده است';
			}
			if(Contents.lang.t.mobileId!=null)
			{
				messageTitle[mobileId] = Contents.lang.t.mobileId;
			}
			else
			{
				messageTitle[mobileId] = 'شماره تلفن همراه اشتباه می باشد';
			}
			if(Contents.lang.t.emailId!=null)
			{
				messageTitle[emailId] = Contents.lang.t.emailId;
			}
			else
			{
				messageTitle[emailId] = 'ایمیل وارد شده صحیح نمی باشد';
			}
			if(Contents.lang.t.telId!=null)
			{
				messageTitle[telId] = Contents.lang.t.telId;
			}
			else
			{
				messageTitle[telId] = 'شماره تلفن وارد شده صحیح نمی باشد';
			}
			if(Contents.lang.t.priceId!=null)
			{
				messageTitle[priceId] = Contents.lang.t.priceId;
			}
			else
			{
				messageTitle[priceId] = 'مبلغ وارد شده صحیح نمی باشد';
			}
			if(Contents.lang.t.dateId!=null)
			{
				messageTitle[dateId] = Contents.lang.t.dateId;
			}
			else
			{
				messageTitle[dateId] = 'تاریخ وارد شده صحیح نمی باشد';
			}
			if(Contents.lang.t.filedEmptyId!=null)
			{
				messageTitle[filedEmptyId]= Contents.lang.t.filedEmptyId;
			}
			else
			{
				messageTitle[filedEmptyId]='لطفا موارد خواسته شده را تکمیل نمایید';
			}	
		}
		public function setup():void
		{
			errorObj = new Object()
		}
		
		public function getError():Vector.<ErrorItem>
		{
			var _error:Vector.<ErrorItem> = new Vector.<ErrorItem>()
			for(var index in errorObj)
			{
				//SaffronLogger.log(index+':::::::::::::::::::::::::::::::::::',errorObj[index])
				if(errorObj[index]!=noErrorId)
				{
					var item:ErrorItem = new ErrorItem()
						item.id = errorObj[index]
						item.message = messageTitle[errorObj[index]]
					_error.push(item)
				}
			}
			return _error
		}
		private function ignore(Index_p:String):Boolean
		{
			var value:Boolean = ignoreList.indexOf(Index_p)>-1
			//SaffronLogger.log('index name :',Index_p,' value :',value)	
			return value	
		}
		public function chekError(CatcherObject_p:Object,Name_p:String,Type_p:String):Boolean
		{	
			//SaffronLogger.log('chek errorrrrrrrrrrrrrrrrrrrrrrr :',Name_p)
			errorObj[Name_p] = noErrorId
			if(CatcherObject_p==null || String(CatcherObject_p[Name_p])=='' || CatcherObject_p[Name_p]==null || CatcherObject_p[Name_p]==undefined )
			{
				if(!ignore(Name_p))
				{				
					errorObj[Name_p] =  filedEmptyId
					return true
				}
			}

			switch(Type_p)
			{
				case MOBILE:
					if(isNaN(Number(CatcherObject_p[Name_p]))){				
						errorObj[Name_p] = mobileId;	
						return true;
					}
					if(String(CatcherObject_p[Name_p]).length!=11 && !ignore(Name_p))
					{
						errorObj[Name_p] = mobileId;	
						return true;
					}
				break;
				case EMAIL:
					if(!EmailValidation.check(CatcherObject_p[Name_p],true)){
						
						errorObj[Name_p] = emailId
						return true
					}
				break;
				case TEL: 
					if(isNaN(Number(CatcherObject_p[Name_p]))){
						errorObj[Name_p] = telId
						return true
					}
				break;	
				case PRICE: 
					if(isNaN(Number(CatcherObject_p[Name_p]))){
						errorObj[Name_p] = priceId
						return true
					}
					break;
				case DATE:

					if(chekDate(String(CatcherObject_p[Name_p]))){
						errorObj[Name_p] = dateId
						return true
					}
					
					break;
			}	

			return false	

		}
		private function chekDate(Date_p:String):Boolean
		{
			if(Date_p == DATE_ERROR)
			{
				return true
			}
			return false
		}
	}
}