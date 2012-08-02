class flintparticles
{
	public static function Lsr( number:Number, shiftBy:Number ):Number
	{
		return number >>> shiftBy;
	}
	public static function Lsl( number:Number, shiftBy:Number ):Number
	{
		return number << shiftBy;
	}
}