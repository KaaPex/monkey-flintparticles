#REM
'/*
 '* FLINT PARTICLE SYSTEM
 '* .....................
 '* 
 '* Author: Richard Lord
 '* Copyright (c) Richard Lord 2008-2011
 '* http://flintparticles.org
 '* 
 '* 
 '* Licence Agreement
 '* 
 '* Permission is hereby granted, free of charge, to any person obtaining a copy
 '* of this software and associated documentation files (the "Software"), to deal
 '* in the Software without restriction, including without limitation the rights
 '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 '* copies of the Software, and to permit persons to whom the Software is
 '* furnished to do so, subject to the following conditions:
 '* 
 '* The above copyright notice and this permission notice shall be included in
 '* all copies or substantial portions of the Software.
 '* 
 '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 '* THE SOFTWARE.
 '*/
#End
Strict

Import monkey.math

'/**
' * The Maths class contains a coupleof useful methods for use in maths functions.
' */
Class Maths 			

	'/**
	 '* Converts an angle from radians to degrees
	 '* 
	 '* @param radians The angle in radians
	 '* @return The angle in degrees
	 '*/
	Method AsDegrees( radians:Number ):Number
		return radians * RADTODEG;
	End Method
	
	'/**
	 '* Converts an angle from degrees to radians
	 '* 
	 '* @param radians The angle in degrees
	 '* @return The angle in radians
	 '*/
	Method AsRadians( degrees:Number ):Number
		return degrees * DEGTORAD;
	End Method
	
	Private 
		Const RADTODEG:Float = 180 / PI;
		Const DEGTORAD:Float = PI / 180;		
	
End Class

