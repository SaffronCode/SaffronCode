package nativeClasses.purchase
{	
	import com.milkmangames.nativeextensions.ios.*;
	import com.milkmangames.nativeextensions.ios.events.*;
	
	import dataManager.GlobalStorage;
	
	public class Purchase
	{
		/**0: purchese done, 1:Purchese canseled, 2:Purchese permition fails, 3:Native error, 4:OS not supports, 5:Connection fails, 6:Purchase done but it was bought earler*/
		public static var lastStatus:int = -1 ;
		
		private static const debugIos:Boolean=true,debugAndroid:Boolean=false;
		
		private static var onDone:Function,
							onFails:Function;
							
		/**Is storekit already initialized*/
		private static var isStoreKitInitialized:Boolean = false ;
		
		/**Ticket id to buy*/
		private static var ticketId:String,
							howManyTickets;
							
		private static const bought_flag:String = "bought_flag" ;
		
		/**Returns true if purchusing can start<br>
		 * call userTicket to clear bout tickets<br>
		 * If you request to by tickets befor and tickets was ready, you have to call useTicket to make the cash clear, otherwise, shopping will not start<br>
		 * <br>
		 * <br>
		 * Android:
		 * Add this permission to the <![CDATA[ <manifest android:installLocation="auto"> <uses-sdk android:minSdkVersion="8" android:targetSdkVersion="19"/>]]>
tag <br><br><bold><![CDATA[ <uses-permission android:name="com.android.vending.BILLING" />]]></bold>*/
		public static function buyTicket(hoManyTicketsDoINeed:uint,yourTicketId:String,onTicketBought:Function,onFaildToBuy:Function):Boolean
		{
			onDone = onTicketBought ;
			onFails = onFaildToBuy ;
			
			ticketId = yourTicketId ;
			howManyTickets = hoManyTicketsDoINeed ;
			
			if(GlobalStorage.load(bought_flag) == true)
			{
				done(6);
				return true ;
			}
			
			if(DevicePrefrence.isIOS())
			{
				if(!isStoreKitInitialized)
				{
					if(StoreKit.isSupported()) 
					{ 
						StoreKit.create();
						trace("*Srore kit is initialized now. continue to shop");
						return continueShoppTickets();
					} 
					else 
					{
						trace("StoreKit only works on iOS!"); 
						faild(3);
						return false ;
					}
				}
				else
				{
					trace("*storeKit was initialized earlier, now controll the shop");
					return continueShoppTickets();
				}
			}
			else if(DevicePrefrence.isAndroid())
			{
				//TODO android shopping
				faild(3);
				return false ;
			}
			faild(4);
			return false ;
		}
		
		/**Tickets are used and the purchase done. now you can request for more tickets to buy*/
		public static function useTickets():void
		{
			GlobalStorage.save(bought_flag,false);
		}
		
		/**0: purchese done, 1:Purchese canseled, 2:Purchese permition fails, 3:Native error, 4:OS not supports, 5:Connection fails, 6:Purchase done but it was bought earler*/
		private static function faild(failId:int):void
		{
			removeListeners();
			lastStatus = failId ;
			onFails();
		}
		
		/**0: purchese done, 1:Purchese canseled, 2:Purchese permition fails, 3:Native error, 4:OS not supports, 5:Connection fails, 6:Purchase done but it was bought earler*/
		private static function done(doneId:uint):void
		{
			removeListeners();
			lastStatus = doneId ;
			GlobalStorage.save(bought_flag,true);
			onDone();
		}
		
		/**Remove all purchess permitions listener*/
		private static function removeListeners():void
		{
			if(isStoreKitInitialized)
			{
				StoreKit.storeKit.removeEventListener(StoreKitEvent.PURCHASE_DEFERRED,onPurchaseDeferred); 
				StoreKit.storeKit.removeEventListener(StoreKitEvent.PURCHASE_CANCELLED,onPurchaseCancel);
				StoreKit.storeKit.removeEventListener(StoreKitErrorEvent.PURCHASE_FAILED, onPurchaseFailed); 
				StoreKit.storeKit.removeEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
			}
		}
		
		/**Continue to shop tickets*/
		private static function continueShoppTickets():Boolean
		{
			if(controll_PurchessPermition())
			{
				trace("* usser has permition to shop");
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_DEFERRED,onPurchaseDeferred); 
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED,onPurchaseCancel); 
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED, onPurchaseFailed); 
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess); 
				
				StoreKit.storeKit.purchaseProduct(ticketId,howManyTickets); 
				return true;
			}
			else
			{
				trace("* user has no permition to shop");
				faild(2);
				return false ;
			}
		}

			/**Nothing happens. onlye parent permitions requireds. after this, default success of fal will dispatch*/
			private static function onPurchaseDeferred(e:StoreKitEvent):void 
			{ 
				trace("* Waiting for permission to buy: "+e.productId); 
				//Nothing happpend here
			} 
		
			/**User canseled shopping*/
			private static function onPurchaseCancel(e:StoreKitEvent):void
			{
				trace("* User canseled shopping: "+e.productId);
				faild(1);
			}
			
			/**Connection fails to complete shopping*/
			private static function onPurchaseFailed(e:StoreKitEvent):void
			{
				trace("* Purchess fails by no clear purpose");
				faild(5);
			}
			
			private static function onPurchaseSuccess(e:StoreKitEvent):void
			{
				trace("* Purchase Done!");
				done(0);
			}
		
		
		
		/**Returns true if user can purchess any thing. no Event dispatches here*/
		private static function controll_PurchessPermition():Boolean
		{
			if(DevicePrefrence.isIOS())
			{
				if(!StoreKit.storeKit.isStoreKitAvailable()) 
				{ 
					trace("this device has purchases disabled.");
					return false; 
				}
				else
				{
					trace("* ios user had the shop permition");
					return true ;
				}
			}
			else if(DevicePrefrence.isAndroid())
			{
				//TODO controll android permitions
				return false 
			}
			return false ;
		}
	}
}