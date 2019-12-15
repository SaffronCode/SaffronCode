package contents.displayElements.camera
//contents.displayElements.camera.CameraMovieClip
{
    import flash.events.Event;
    import com.mteamapp.camera.MTeamCamera;
    import flash.display.MovieClip;

    public class CameraMovieClip extends MovieClip
    {
        private var myCamera:MTeamCamera ;

        public function CameraMovieClip()
        {
            super();
            if(this.stage!=null)
            {
                activateCamera(null);
            }
            else
            {
                this.addEventListener(Event.ADDED_TO_STAGE,activateCamera);
            }
        }

        private function activateCamera(e:Event):void
        {
            myCamera = new MTeamCamera(this);
            this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
        }

        private function unLoad(event:Event):void
        {
            trace("Camera element remved from stage")
        }
    }
}