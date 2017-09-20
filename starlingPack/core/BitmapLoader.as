/**
 * Created by mes on 20/09/2017.
 */
package starlingPack.core {
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

public class BitmapLoader {

    private var loader:Loader ;
    private var urlRequest:URLRequest ;

    private var onLoaded:Function ;
    private var onError:Function ;

    public var loadedBitmap:Bitmap ;

    public function BitmapLoader() {
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, urlWasWrong)
    }

    private function urlWasWrong(event:IOErrorEvent):void {
        trace("*** requested url was wrong ***")
        callError();
    }

    private function imageLoaded(event:Event):void {
        if(loader.content is Bitmap)
        {
            loadedBitmap = loader.content as Bitmap ;
        }
        else
        {
            trace("*** The loaded file was not a bitmap ***");
            callError();
            return ;
        }
        if(onLoaded!=null)
        {
            if(onLoaded.length==0)
            {
                onLoaded();
            }
            else
            {
                onLoaded(loadedBitmap);
            }
        }
    }

    private function callError():void {
        if(onError!=null)
        {
            onError();
        }
    }

    public function disopose():void
    {
        onLoaded = null ;
        onError = null ;
        try {
            loader.close();
        }catch (e){};
    }

    /**You can take the bitmap directly from an input on the onLoadedFunction or loadedBitmap variable*/
    public function load(imageURL:String,onLoadedFunction:Function,onErrorFunction:Function=null):void
    {
        trace("*** Load "+imageURL+" on BitmapLoader class ***");
        onLoaded = onLoadedFunction ;
        onError = onErrorFunction ;
        loader.load(new URLRequest(imageURL));
    }
}
}
