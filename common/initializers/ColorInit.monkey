 #REM
 '*
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
 '*
 #end
Strict

Import flintparticles.common.emitters.Emitter
Import flintparticles.common.particles.Particle
Import flintparticles.common.utils.interpolateColors	

'/**
 '* The ColorInit Initializer sets the color of the particle.
 '*/

Class ColorInit Extends InitializerBase
	Field _min:Int
	Field _max:Int
	
	'/**
	 '* The constructor creates a ColorInit initializer for use by 
	 '* an emitter. To add a ColorInit to all particles created by an emitter, use the
	 '* emitter's addInitializer method.
	 '* 
	 '* <p>The color of particles initialized by this class
	 '* will be a random value between the two values pased to
	 '* the constructor. For a fixed value, pass the same color
	 '* in for both parameters.</p>
	 '* 
	 '* @param color1 the 32bit (ARGB) color at one end of the color range to use.
	 '* @param color2 the 32bit (ARGB) color at the other end of the color range to use.
	 '* 
	 '* @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 '*/
	Method New( color1:Int= $FFFFFFFF, color2:Int = $FFFFFFFF )
		_min = color1
		_max = color2
	End Method
	
	'/**
	 '* The minimum color value for particles initialised by 
	 '* this initializer. Should be between 0 and 1.
	 '*/
	Method GetMinColor:Int()
		Return _min
	End Method
	
	Method SetMinColor:Void( value:Int )
		_min = value
	End Method
	
	'/**
	 '* The maximum color value for particles initialised by 
	 '* this initializer. Should be between 0 and 1.
	 '*/
	Method GetMaxColor():Int
		Return _max
	End Method
	Method SetMaxColor:Void( value:Int )
		_max = value
	End Method
	
	'/**
	 '* When reading, returns the average of minColor and maxColor.
	 '* When writing this sets both maxColor and minColor to the 
	 '* same color.
	 '*/
	Method GetColor:Int()
		If( _max == _min ) Then
			Return _min
		Else
			Return interpolateColors( _max, _min, 0.5 )
		Endif
	End Method
	
	Method SetColor:void( value:int )
		_max = _min = value
	End Method
	
	'/**
	 '* @inheritDoc
	 '*/
	Method Initialize:void( emitter:Emitter, particle:Particle )
		If( _max == _min ) Then
			particle.color = _min
		Else
			particle.color = interpolateColors( _min, _max, Math.random() )
		Endif	
	End Method
End Class
