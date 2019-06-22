package {
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextFieldForTable extends TextField {
		
		private var pointOfShowingValue:Point = new Point(0,0);
		public function get PointOfShowingValue():Point{ return pointOfShowingValue };
		public function set PointOfShowingValue(val:Point):void{
			if(val.x < 0 || val.y < 0) throw ArgumentError("このプロパティにセットする座標はx,yの両方が正の数でなければなりません。")
		}
		
		public function TextFieldForTable() {
			super();
		}
		
	}

}