package {
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class TextFieldTable extends Sprite{
		
		private var textFields:Vector.<Vector.<TextField>> = new Vector.<Vector.<TextField>>;
		public function get TextFields():Vector.<Vector.<TextField>> { return textFields };
		
		private var dataSource:Array
		public function set DataSource(dataSource:Array):void{ this.dataSource = dataSource };
		
		public function TextFieldTable(initialRowCount:int ,initialColumnCount:int) {
			for (var i:int = 0; i < initialRowCount; i++){
				var newRow:Vector.<TextField> = new Vector.<TextField>;
				for (var j:int = 0; j < initialColumnCount; j++){
					var tFld:TextField = new TextField();
					tFld.x = j * 20;
					tFld.y = i * 20;
					addChild(tFld);
					newRow.push(tFld);
				}
				textFields.push(newRow)
			}
		}
		
		/** 
		 * 関数オブジェクトを表内の全テキストフィールドに対して実行します。
		 * @param	callBackFunc	関数オブジェクトの仕様は　callBack(t:TextField)　です
		 */
		public function applyToAll(callBackFunc:Function):void{
			for (var i:int = 0; i < textFields.length; i++){
				for (var j:int = 0; j < textFields[i].length; j++){
					callBackFunc( textFields[i][j] );
				}
			}
		}
	}
}