module iota.controls.types;

public import core.time;
/*
 * If version `iota_uint_as_timestamp` is supplied, then uint will be used as the type for timestamps. If not, then 
 * MonoTime will be used instead, wuth greater resolution.
 */
version (iota_uint_as_timestamp) {
	alias Timestamp = uint;
} else {
	alias Timestamp = MonoTime;
}
/** 
 * Defines the types of the input devices.
 */
public enum InputDeviceType : ubyte {
	init,
	Keyboard,
	Mouse,
	GameController,		///Joysticks, gamepads, etc.
	Pen,				///Graphics tablet, etc.
	TouchScreen,
	Gyro,				///Built-in Gyro device
	System,				///Misc. system related input device
	MIDI,				///If enabled, MIDI devices can function as regular input devices creating regular input events from key press and control change commands
}
/**
 * Defines possible input event types.
 */
public enum InputEventType {
	init,
	Keyboard,
	TextInput,
	TextEdit,
	MouseClick,
	MouseMove,
	MouseScroll,
	GCButton,
	GCAxis,
	GCHat,
	Pen,
}
/**
 * Contains basic info about the input device.
 * Child classes might also contain references to OS variables and pointers.
 */
public abstract class InputDevice {
	protected InputDeviceType	_type;		/// Defines the type of the input device
	protected ubyte				_devNum;	/// Defines the number of the input device
	/// Status flags of the device.
	/// Bits 0-7 are common, 8-15 are special to each device/interface type.
	/// Note: flags related to indicators/etc should be kept separately.
	protected ushort			status;
	/**
	 * Defines common status codes
	 */
	public enum StatusFlags : ushort {
		IsConnected		=	1<<0,
		IsInvalidated	=	1<<1,
		HasBattery		=	1<<2,
		IsAnalog		=	1<<3,
	}
	public InputDeviceType type() @nogc @safe pure nothrow const @property {
		return _type;
	}
	public ubyte devNum() @nogc @safe pure nothrow const @property {
		return _devNum;
	}
}
/** 
 * Defines a button (keyboard, game controller) event data.
 */
public struct ButtonEvent {
	ushort		dir;	///Up or down
	ushort		aux;	///Used to identify modifier keys on keyboard, etc.
	uint		id;		///Button ID
}
public struct AxisEvent {
	uint		id;
	float		val;
}

/**
 * Contains data generated by input devices.
 */
public struct InputEvent {
	InputDevice				source;
	const Timestamp			timestamp;
	const InputEventType	type;
	union {
		ButtonEvent			button;
	}
}