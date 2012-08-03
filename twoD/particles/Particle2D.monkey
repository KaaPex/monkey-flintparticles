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
 #End

	Import flintparticles.common.particles.Particle
	Import flintparticles.common.particles.ParticleFactory
	Import monkey.math
	'Import flash.geom.Matrix;	

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
	Class Particle2D Extends Particle

		'/**
		 '* The x coordinate of the particle in pixels.
		 '*/
		Public x:Float = 0
		'/**
		 '* The y coordinate of the particle in pixels.
		 '*/
		Public y:Float = 0
		'/**
		 '* The x coordinate of the particle prior to the latest update.
		 '*/
		Public previousX:Float = 0
		'/**
		 '* The y coordinate of the particle prior To the latest update.
		 '*/
		Public previousY:Float = 0
		'/**
		 '* The x coordinate of the velocity of the particle in pixels per second.
		 '*/
		Public velX:Float = 0
		'/**
		 '* The y coordinate of the velocity of the particle in pixels per second.
		 '*/
		Public velY:Float = 0
		
		'/**
		 '* The rotation of the particle in radians.
		 '*/
		Public rotation:Float = 0
		'/**
		 '* The angular velocity of the particle in radians per second.
		 '*/
		Public angVelocity:Float = 0

		Private _previousMass:Float
		Private _previousRadius:Float
		Private _inertia:Float
		
		'/**
		 '* The moment of inertia of the particle about its center point
		 '*/
		Method GetInertia:Float()
			If( mass <> _previousMass || collisionRadius <> _previousRadius ) Then
			    _inertia = mass * collisionRadius * collisionRadius * 0.5
				_previousMass = mass
				_previousRadius = collisionRadius
			Endif
			Return _inertia
		End Method

		'/**
		 '* The position in the emitter's horizontal spacial sorted array
		 '*/
		sortID:int = -1
		
		'/**
		 '* Creates a particle. Alternatively particles can be reused by using the ParticleCreator to create
		 '* and manage them. Usually the emitter will create the particles and the user doesn't need
		 '* to create them.
		 '*/
		Method Particle2D()
			super()
		End Method
		
		'/**
		 '* Sets the particles properties to their default values.
		 '*/
		Method Initialize:void()
			super.initialize()
			x = 0
			y = 0
			previousX = 0
			previousY = 0
			velX = 0
			velY = 0
			rotation = 0
			angVelocity = 0
			sortID = -1
		End Method
		
		'/**
		 '* A transformation matrix for the position, scale and rotation of the particle.
		 '*/
		 ' TO-DO matrix as array(6)
		'Method get matrixTransform:Matrix()
		'	Local cos:Float = scale * Math.cos( rotation )
		'	Local sin:Float = scale * Math.sin( rotation )
		'	return new Matrix( cos, sin, -sin, cos, x, y )
		'End Method
		
		'/**
		 '* @inheritDoc
		 '*/
		Method Clone:Particle( factory:ParticleFactory = Null )
			Local p:Particle2D
			If( factory <> Null )
				p = (Particle2D)factory.CreateParticle()
			Else
				p = New Particle2D()
			Endif
			CloneInto( p )
			p.x = x
			p.y = y
			p.velX = velX
			p.velY = velY
			p.rotation = rotation
			p.angVelocity = angVelocity
			Return p
		End Method
		
	End Method
