package {
	/**
	 * ...	テーブル内の列を表すクラスです。
	 */
	public class TextTableColumn {
		
		private var x:int = 0;
		public function get X():int { return x; }
		public function set X(posX:int):void {
			for each(var t:TextFieldForTable in textFields){
				t.x = posX;
				this.x = posX
			}
			
			//列の位置が変更されたら、隣の列が存在るなら、その位置も変更する。
			if (referenceToNextColumn){
				referenceToNextColumn.X = this.x + this.width;
			}
		}
		
		private var width:int = 0;
		public function get Width():int { return width; }
		public function set Width( w:int ):void {
			for each(var t:TextFieldForTable in textFields) { 
				t.width = w ;
				this.width = w;
			}
			
			//次の列への参照は保持しているでの、この列の幅変更に、全列の位置が追従する。
			if (referenceToNextColumn){
				referenceToNextColumn.X = this.x + this.width;
			}
		}
		
		private var referenceToNextColumn:TextTableColumn;
		
		/**
		 * この列の右側の列への参照です。
		 */
		public function get ReferenceToNextColumn():TextTableColumn { return referenceToNextColumn; }
		public function set ReferenceToNextColumn(nextColumn:TextTableColumn):void{
			referenceToNextColumn = nextColumn;
		}
		
		/** この列に属するセル群が数値専用のセルであるかどうかを表します。 */
		public var isNumericOnly:Boolean = false;
		
		private var textFields:Vector.<TextFieldForTable> = new Vector.<TextFieldForTable>;
		public function get TextFields():Vector.<TextFieldForTable> { return textFields; }
		
		public function TextTableColumn() {
			
		}
		
		/**	引数に入力したテキストフィールドを、この列クラスの管理下に加えます。
		 * @param	t	このメソッドを実行した時、引数のテキストフィールドのwidth,xフィールドが変化します。
		 */
		public function add(t:TextFieldForTable):void{
			t.x = x;
			t.width = width;
			textFields.push(t);
		}		
	}
}