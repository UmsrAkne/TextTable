package {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextWriting extends Event {
		
		public static const TEXT_WRITING:String = "TextWriting";
		public var originalValue:*;
		
		public function TextWriting(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new TextWriting(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("TextWriting", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}