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
Strict
 
Import flintparticles.common.emitters.Emitter
Import flintparticles.common.particles.Particle
Import flintparticles.common.particles.ParticleFactory
Import flintparticles.common.utils.Maths
Import flintparticles.twoD.particles.Particle2D
Import flintparticles.twoD.particles.ParticleCreator2D

#REM
'/**
 '* The Emitter class manages the creation and ongoing state of particles. It uses a number of
 '* utility classes to customise its behaviour.
 '* 
 '* <p>An emitter uses Initializers to customise the initial state of particles
 '* that it creates, their position, velocity, color etc. These are added to the 
 '* emitter using the addInitializer  method.</p>
 '* 
 '* <p>An emitter uses Actions to customise the behaviour of particles that
 '* it creates, to apply gravity, drag, fade etc. These are added to the emitter 
 '* using the addAction method.</p>
 '* 
 '* <p>An emitter uses Activities to customise its own behaviour in an ongoing manner, to 
 '* make it move or rotate.</p>
 '* 
 '* <p>An emitter uses a Counter to know when and how many particles to emit.</p>
 '* 
 '* <p>An emitter uses a Renderer to display the particles on screen.</p>
 '* 
 '* <p>All timings in the emitter are based on actual time passed, not on frames.</p>
 '* 
 '* <p>Most functionality is best added to an emitter using Actions,
 '* Initializers, Activities, Counters and Renderers. This offers greater 
 '* flexibility to combine behaviours witout needing to subclass 
 '* the Emitter itself.</p>
 '* 
 '* <p>The emitter also has position properties - x, y, rotation - that can be used to directly
 '* affect its location in the particle system.</p>
 '*/
 #END

Class Emitter2D Extends Emitter

Private	
	'/**
	 '* @private
	 '* 
	 '* default factory to manage the creation, reuse and destruction of particles
	 '*/
	Field _creator:ParticleCreator2D = new ParticleCreator2D()
	
	'/**
	 '* @private
	 '*/
	Field _x:Float = 0
	'/**
	 '* @private
	 '*/
	Field _y:Float = 0
	'/**
	 '* @private
	 '*/
	Field _rotation:Float = 0 '// N.B. Is in radians
	
Public	
	'/**
	 '* Identifies whether the particles should be arranged
	 '* into spacially sorted arrays - this speeds up proximity
	 '* testing for those actions that need it.
	 '*/
	Float spaceSort:Bool = False
	'/**
	 '* Makes the emitter skip forwards a period of time at teh start. Use this property
	 '* when you want the emitter to look like it's been running for a while.
	 '*/
	Field runAheadTime:Float = 0	
	'/**
	 '* The frame=-rate to use when running the emitter ahead at the start.
	 '* 
	 '* @see #runAheadTime
	 '*/
	Field runAheadFrameRate:Float = 10	
	'/**
	 '* Indicates If the emitter should start automatically Or wait For the start methood To be called.
	 '*/
	Field autoStart:Bool = True
	
	'/**
	 '* The default particle factory used to manage the creation, reuse and destruction of particles.
	 '*/
	Method GetDefaultParticleFactory:ParticleFactory()
		Return _creator;
	End Method
	
	'/**
	 '* The constructor creates an emitter.
	 '*/
	Method New()
		Super.New()
		_particleFactory = _creator
	End Method
	
	'/**
	 '* Indicates the x coordinate of the Emitter within the particle system's coordinate space.
	 '*/
	Method GetX:Float()
		Return _x
	End Method
	Method SetX:Void( value:Float )
		_x = value
	End Method
	'/**
	 '* Indicates the y coordinate of the Emitter within the particle system's coordinate space.
	 '*/
	Method GetY:Float()
		Return _y
	End Method
	Method SetY:Void( value:Float )
		_y = value
	End Method
	'/**
	 '* Indicates the rotation of the Emitter, in degrees, within the particle system's coordinate space.
	 '*/
	Method GetRotation:Float()
		Return Maths.AsDegrees( _rotation )
	}
	Method SetRotation:Void( value:Float )
		_rotation = Maths.AsRadians( value )
	End Method
	'/**
	 '* Indicates the rotation of the Emitter, in radians, within the particle system's coordinate space.
	 '*/
	Method GetRotRadians:Float()
		Return _rotation
	End Method
	Method SetRotRadians:void( value:Float )
		_rotation = value
	End Method

	'/**
	 '* Used internally to initialise the position and rotation of a particle relative to the emitter.
	 '*/
	Method InitParticle:Void( particle:Particle )
		Local p:Particle2D = Particle2D( particle )
		p.x = _x
		p.y = _y
		p.previousX = _x
		p.previousY = _y
		p.rotation = _rotation
	End Method
		
	'/**
	 '* 
	 '*/
	Method Initialize:void()
		If( autoStart ) Then
			Start()
		Endif
		If( runAheadTime ) Then
			RunAhead( runAheadTime, runAheadFrameRate )
		Endif
	End Method
	
	'/**
	 '* Used internally and in derived classes to update the emitter.
	 '* @param time The duration, in seconds, of the current frame.
	 '*/
	'Method sortParticles():void
	'	if( spaceSort )
	'	{
	'		_particles.sortOn( "x", Array.NUMERIC );
	'		var len:int = _particles.length;
	'		for( var i:int = 0; i < len; ++i )
	'		{
	'			Particle2D( _particles[ i ] ).sortID = i;
	'		}
		}
	'End Method
End Class