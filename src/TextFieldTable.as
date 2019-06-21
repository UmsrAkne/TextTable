package {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class TextFieldTable extends Sprite{
		
		private var textFields:Vector.<Vector.<TextField>> = new Vector.<Vector.<TextField>>;
		public function get TextFields():Vector.<Vector.<TextField>> { return textFields };
		
		private var dataSource:Array
		public function set DataSource(dataSource:Array):void{ 
			this.dataSource = dataSource;
			writeVisibleRange();
		};
		
		private var columnPropertyNames:Vector.<String> = new Vector.<String>();
		public function set ColumnPropertyNames(names:Vector.<String>):void{ columnPropertyNames = names };
		
		private var visibleRange:Rectangle;
		
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
			
			visibleRange = new Rectangle(0, 0, initialColumnCount , initialRowCount);
		}
		
		private function writeVisibleRange():void{
			var txFldRowCount:int = 0;
			for (var i:int = visibleRange.y; i < visibleRange.height + visibleRange.y; i++){
				for (var j:int = 0; j < columnPropertyNames.length; j++){
					textFields[ txFldRowCount ][j].text = dataSource[i][columnPropertyNames[j]];
				}
				txFldRowCount++;
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