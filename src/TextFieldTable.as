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
	}
}