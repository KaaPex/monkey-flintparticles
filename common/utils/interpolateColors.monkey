#REM
'/*
 '* FLINT PARTICLE SYSTEM
 '* .....................
 '* 
 '* Author: Richard Lord
 '* Copyright (c) Richard Lord 2008-2011
 '* http://flintparticles.org
 '* Copyright: Monkey port - 2012 Aleksey 'KaaPex' Kazantsev
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

'/**
 '* This function is used to find a color between two other colors.
 '* 
 '* @param color1 The first color.
 '* @param color2 The second color.
 '* @param ratio The proportion of the first color to use. The rest of the color 
 '* is made from the second color.
 '* @return The color created.
 '*/

Import flintparticles.flintextern

Function InterpolateColors:Int( color1:Int, color2:Int, ratio:Float )
	Local inv:Float = 1 - ratio;
	Local red:Int = Int( ( Lsr( color1 , 16) & 255 ) * ratio + ( Lsr(color2, 16) & 255 ) * inv );
	Local green:Int = Int( ( Lsr(color1, 8) & 255 ) * ratio + ( Lsr(color2, 8) & 255 ) * inv );
	Local blue:Int = Int( ( ( color1 ) & 255 ) * ratio + ( ( color2 ) & 255 ) * inv );
	Local alpha:Int = Int( ( Lsr(color1, 24) & 255 ) * ratio + ( Lsr(color2, 24) & 255 ) * inv );
	return ( alpha Shl 24 ) | ( red Shl 16 ) | ( green Shl 8 ) | blue;
End

