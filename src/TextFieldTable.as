package {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class TextFieldTable extends Sprite{
		
		private var textFields:Vector.<Vector.<TextFieldForTable>> = new Vector.<Vector.<TextFieldForTable>>;
		public function get TextFields():Vector.<Vector.<TextFieldForTable>> { return textFields };
		
		private var dataSource:Array
		public function set DataSource(dataSource:Array):void{ 
			this.dataSource = dataSource;
			writeVisibleRange();
		};
		
		private var columnPropertyNames:Vector.<String> = new Vector.<String>();
		public function set ColumnPropertyNames(names:Vector.<String>):void{ columnPropertyNames = names };
		
		private var visibleRange:Rectangle;
		
		public function getValue(rowIndex:int , columnIndex:int):String{
			return String(dataSource[rowIndex][columnPropertyNames[columnIndex]]);
		}
		
		public function TextFieldTable(initialRowCount:int ,initialColumnCount:int) {
			for (var i:int = 0; i < initialRowCount; i++){
				var newRow:Vector.<TextFieldForTable> = new Vector.<TextFieldForTable>;
				for (var j:int = 0; j < initialColumnCount; j++){
					var tFld:TextFieldForTable = new TextFieldForTable();
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
				
		public function scrollDown(moveDistance:uint):void{
			if (visibleRange.y + visibleRange.height + moveDistance >= dataSource.length -1)
			{
				visibleRange.y = dataSource.length - visibleRange.height;
				writeVisibleRange();
				return;
			}
			visibleRange.y += moveDistance;
			writeVisibleRange();
		}
		
		public function scrollUp(moveDistance:uint):void{
			if (visibleRange.y - moveDistance < 0) {
				visibleRange.y = 0;
				writeVisibleRange();
				return;
			}
			visibleRange.y -= moveDistance;
			writeVisibleRange();
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