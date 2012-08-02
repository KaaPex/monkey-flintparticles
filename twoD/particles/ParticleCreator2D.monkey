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
Import monkey.list
Import flintparticles.common.debug.ParticleFactoryStats
Import flintparticles.common.particles.Particle
Import flintparticles.common.particles.ParticleFactory

'/**
 '* The ParticleCreator is used by the Emitter class to manage the creation and reuse of particles.
 '* To speed up the particle system, the ParticleCreator class maintains a pool of dead particles 
 '* and reuses them when a new particle is needed, rather than creating a whole new particle.
 '*/

Public Class ParticleCreator2D Implements ParticleFactory

	Private 
		Field _particles:List<Particle>
	
	'/**
	 '* The constructor creates a ParticleCreator object.
	 '*/
	Public Method ParticleCreator2D()
		_particles = New List<Particle>()
	End Method
	
	'/**
	 '* Obtains a new Particle object. The createParticle method will return
	 '* a dead particle from the poll of dead particles or create a new particle if none are
	 '* available.
	 '* 
	 '* @return a Particle object.
	 '*/
	Public Method CreateParticle:Particle()
		ParticleFactoryStats.numParticles += 1
		If ( _particles.Count() <> 0 ) Then
			Local p:Particle = _particles.LastNode()
			_particles.RemoveLast()
			Return _particles.pop()
		Else
			Return New Particle2D()
		Endif
	End Method
	
	'/**
	 '* Returns a particle to the particle pool for reuse
	 '* 
	 '* @param particle The particle to return for reuse.
	 '*/
	public Method DisposeParticle:void( particle:Particle )
		ParticleFactoryStats.numParticles -= 1
		If( Particle2D(particle) <> Null ) Then
			particle.initialize()
			_particles.AddLast( particle )
		Endif
	End Method

	'/**
	 '* Empties the particle pool.
	 '*/
	Public Method ClearAllParticles:Void()
		_particles = new List<Particle>()
	End Method
End Class
