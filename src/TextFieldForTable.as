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
		
		/**
		 * 引数に取ったテキストフィールドのプロパティを、このオブジェクトのプロパティにコピーします。
		 * @param	baseTextField コピーする情報をセットしたオブジェクトです。
		 */
		public function copyProperties(baseTextField:TextField):void{
			this.defaultTextFormat = baseTextField.defaultTextFormat;
			this.width = baseTextField.width;
			this.height = baseTextField.height;
			this.text = baseTextField.text;
			this.multiline = baseTextField.multiline;
			this.border = baseTextField.border;
			this.background = baseTextField.background;
			this.x = baseTextField.x;
			this.y = baseTextField.y;
		}
	}

}