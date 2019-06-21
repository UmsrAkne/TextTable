package{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite {
		
		public function Main() {
			var textFieldTable:TextFieldTable = new TextFieldTable(20 , 15);
			addChild(textFieldTable);
			var textFieldTableTest:TextFieldTableTest = new TextFieldTableTest();
			addChild(textFieldTableTest);
		}
		
	}	
}