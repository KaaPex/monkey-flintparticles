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

'Import flash.geom.ColorTransform
'Import flash.utils.Dictionary	
Import flintparticles.flintextern
Import flintparticles.common.particles.ParticleFactory
Import flintparticles.twoD.particles.ParticleCreator2D

'/**
 '* The Particle class is a set of public properties shared by all particles.
 '* It is deliberately lightweight, with only one method. The Initializers
 '* and Actions modify these properties directly. This means that the same
 '* particles can be used in many different emitters, allowing Particle 
 '* objects to be reused.
 '* 
 '* Particles are usually created by the ParticleCreator class. This class
 '* just simplifies the reuse of Particle objects which speeds up the
 '* application. 
 '*/
Class Particle

Public
	'/**
	 '* The 32bit ARGB color of the particle. The initial value is 0xFFFFFFFF (white).
	 '*/
	Field color:Int = $FFFFFFFF
	
	'//TO-DO ColorTransform Class
	'Private	Field _colorTransform:ColorTransform = Null
	'Private Field _previousColor:Int
	
	'/**
	 '* The scale of the particle ( 1 is normal size ).
	 '*/
	Field scale:Float = 1
	
	'/**
	 '* The mass of the particle ( 1 is the default ).
	 '*/
	Field mass:Float = 1
	
	'/**
	 '* The radius of the particle, for collision approximation
	 '*/
	Field collisionRadius:Float = 1

	'/**
	 '* The object used to display the image. In a 2D particle, this is usually
	 '* a DisplayObject. In a 3D particle, this may be a DisplayObject, for 
	 '* displaying on a billboard or similar, or a 3D object in the form used
	 '* by the render system.
	 '*/
	Field image:Object = Null
	
	'/**
	 '* The lifetime of the particle, in seconds.
	 '*/
	Field lifetime:Float = 0
	'/**
	 '* The age of the particle, in seconds.
	 '*/
	Field age:Float = 0
	'/**
	 '* The energy of the particle.
	 '*/
	Field energy:Float = 1
	
	'/**
	 '* Whether the particle is dead And should be removed from the stage.
	 '*/
	Field isDead:Bool = False
	
	'/**
	 '* The dictionary object enables actions and activities to add additional properties to the particle.
	 '* Any object adding properties to the particle should use a reference to itself as the dictionary
	 '* key, thus ensuring it doesn't clash with other object's properties. If multiple properties are
	 '* needed, the dictionary value can be an object with a number of properties.
	 '*/	
	 '//TO-DO Dictionary class 
	'Public Method get dictionary:Dictionary()
	'	If( _dictionary = Null )Then
	'		_dictionary = New Dictionary( True );
	'	Endif
	'	Return _dictionary;
	'End Method
	'Private _dictionary:Dictionary = Null;
	
		'/**
	 '* Creates a particle. Alternatively particles can be reused by using the ParticleCreator To create
	 '* And manage them. Usually the emitter will create the particles And the user doesn't need
	 '* To create them.
	 '*/
	Method New()
	End Method
	
	'/**
	 '* Sets the particle's properties to their default values.
	 '*/
	Method Initialize:Void()
		color = $FFFFFFFF
		scale = 1
		mass = 1
		collisionRadius = 1
		lifetime = 0
		age = 0
		energy = 1
		isDead = False
		image = Null
		'_dictionary = Null;
		'_colorTransform = Null;
	End Method
	
	'/**
	 '* A ColorTransform Object that converts white To the colour of the particle.
	 '*/
	'Public Function get colorTransform():ColorTransform
	'{
	'	If( !_colorTransform || _previousColor != color )
	'	{
	'		_colorTransform = New ColorTransform( ( ( color >>> 16 ) & 255 ) / 255,
	'	                           ( ( color >>> 8 ) & 255 ) / 255,
	'	                           ( ( color ) & 255 ) / 255,
	'	                           ( ( color >>> 24 ) & 255 ) / 255,
	'	                           0,0,0,0 );
	'	    _previousColor = color;
	'	}
	'	Return _colorTransform;
	'}
	
	Method Alpha:Float()
		Return Lsr( color & $FF000000 , 24 ) / 255
	End Method

	'/**
	 '* @Private
	 '*/
	Method CloneInto:Particle( p:Particle )
		p.color = color
		p.scale = scale
		p.mass = mass
		p.collisionRadius = collisionRadius
		p.lifetime = lifetime
		p.age = age
		p.energy = energy
		p.isDead = isDead
		p.image = image
		'If( _dictionary )
		'{
		'	p._dictionary = New Dictionary( True );
		'	For( var key:Object in _dictionary )
		'	{
		'		p._dictionary[ key ] = _dictionary[ key ];
		'	}
		'}
		Return p
	End Method	
	
	'/**
	 '* Creates a New particle with all the same properties as this one.
	 '* 
	 '* <p>Note that the New particle will use the same image Object as the one you're cloning.
	 '* This is fine If the particles are used with a Bitmaprenderer, but If they are used with a 
	 '* DisplayObjectRenderer you will need To replace teh image Property with a New image, otherwise
	 '* only one of the particles (original Or clone) will be displayed.</p>
	 '*/
	Method Clone:Particle( factory:ParticleCreator2D = Null )
		Local p:Particle
		If( factory ) Then
			p = factory.CreateParticle()

		Else
			p = new Particle()
		Endif
		return CloneInto( p )
	End Method
	
	Method Revive:Void()
		lifetime = 0
		age = 0
		energy = 1
		isDead = false
	End Method

End Class
