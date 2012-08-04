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
 
Import monkey.stack
Import monkey.list
Import flintparticles.common.actions.Action
Import flintparticles.common.activities.Activity
Import flintparticles.common.behaviours.Behaviour
Import flintparticles.common.counters.Counter
Import flintparticles.common.counters.ZeroCounter
'Import org.flintparticles.common.events.EmitterEvent;
'Import org.flintparticles.common.events.ParticleEvent;
'Import org.flintparticles.common.events.UpdateEvent;
Import flintparticles.common.initializers.Initializer
Import flintparticles.common.particles.Particle
Import flintparticles.common.particles.ParticleFactory
'	import org.flintparticles.common.utils.FrameUpdater;

'import flash.events.EventDispatcher

'/**
 '* The Emitter class is the base class for the Emitter2D and Emitter3D classes.
 '* The emitter class contains the common behavioour used by these two concrete
 '* classes.
 '* 
 '* <p>An Emitter manages the creation and ongoing state of particles. It uses 
 '* a number of utility classes to customise its behaviour.</p>
 '* 
 '* <p>An emitter uses Initializers to customise the initial state of particles
 '* that it creates; their position, velocity, color etc. These are added to the 
 '* emitter using the addInitializer method.</p>
 '* 
 '* <p>An emitter uses Actions to customise the behaviour of particles that
 '* it creates; to apply gravity, drag, fade etc. These are added to the emitter 
 '* using the addAction method.</p>
 '* 
 '* <p>An emitter uses Activities to alter its own behaviour, to move it or rotate
 '* it for example.</p>
 '* 
 '* <p>An emitter uses a Counter to know when and how many particles to emit.</p>
 '* 
 '* <p>All timings in the emitter are based on actual time passed, 
 '* independent of the frame rate of the flash movie.</p>
 '* 
 '* <p>Most functionality is best added to an emitter using Actions,
 '* Initializers, Activities and Counters. This offers greater 
 '* flexibility to combine behaviours without needing to subclass 
 '* the Emitter classes.</p>
 '*/

Public Class Emitter
	'/**
	 '* @private
	 '*/
	Field _particleFactory:ParticleFactory
	
	'/**
	 '* @private
	 '*/
	Field _initializers:Stack<Initializer>
	'/**
	 '* @Private
	 '*/
	Field _actions:Stack<Action>
	'/**
	 '* @private
	 '*/
	Field _activities:Stack<Activity>
	'/**
	 '* @private
	 '*/
	Field _particles:Stack<Particle>
	'/**
	 '* @private
	 '*/
	Field _counter:Counter

	'/**
	 '* @private
	 '*/
	'Field _useInternalTick:Bool = true
	'/**
	 '* @private
	 '*/
	Field _fixedFrameTime:Float = 0
	'/**
	 '* @private
	 '*/
	Field _running:Bool = false
	'/**
	 '* @private
	 '*/
	Field _started:Bool = false
	'/**
	 '* @private
	 '*/
	Field _updating:Bool = false
	'/**
	 '* @private
	 '*/
	Field _maximumFrameTime:Float = 0.1
	'/**
	 '* Indicates if the emitter should dispatch a counterComplete event at the
	 '* end of the next update cycle.
	 '*/
	'Field _dispatchCounterComplete:Bool = false
	'/**
	 '* Used to alternate the direction in which the particles in the particles
	 '* array are processed, to iron out errors from always processing them in
	 '* the same order.
	 '*/
	Field _processLastFirst:Bool = false

	'/**
	 '* The constructor creates an emitter.
	 '* 
	 '* @param useInternalTick Indicates whether the emitter should use its
	 '* own tick event to update its state. The internal tick process is tied
	 '* to the framerate and updates the particle system every frame.
	 '*/
	Method New()
		_particles = New List<Particle>()
		_actions = new Stack<Action>()
		_initializers = new Stack<Initializer>()
		_activities = new Stack<Activity>()
		_counter = New ZeroCounter()
	End Method

	'/**
	 '* The maximum duration for a single update frame, in seconds.
	 '* 
	 '* <p>Under some circumstances related to the Flash player (e.g. on MacOSX, when the 
	 '* user right-clicks on the flash movie) the flash movie will freeze for a period. When the
	 '* freeze ends, the current frame of the particle system will be calculated as the time since 
	 '* the previous frame,  which encompases the duration of the freeze. This could cause the 
	 '* system to generate a single frame update that compensates for a long period of time and 
	 '* hence moves the particles an unexpected long distance in one go. The result is usually
	 '* visually unacceptable and certainly unexpected.</p>
	 '* 
	 '* <p>This property sets a maximum duration for a frame such that any frames longer than 
	 '* this duration are ignored. The default value is 0.5 seconds. Developers don't usually
	 '* need to change this from the default value.</p>
	 '*/
	Method GetMaximumFrameTime:Float()
		Return _maximumFrameTime
	End Method
	Method SetMaximumFrameTime:Void( value:Float ) 
		_maximumFrameTime = value
	End Method
	
	'/**
	 '* The array of all initializers being used by this emitter.
	 '*/
	Method GetInitializers:Stack<Initializer>()
		Return _initializers
	End Method
	Method SetInitializers:Void( value:Stack<Initializer> )
		Local initializer:Initializer
		For initializer = Eachin _initializers
			initializer.RemovedFromEmitter( Self )
		Next
		For initializer = Eachin value
		    _initializers.Push(initializer)
		Next
		'_initializers = value.slice();
		'_initializers.sort( prioritySort );
		For initializer = Eachin value
			initializer.AddedToEmitter( Self )
		Next
	End Method

	'/**
	 '* Adds an Initializer object to the Emitter. Initializers set the
	 '* initial state of particles created by the emitter.
	 '* 
	 '* @param initializer The Initializer to add
	 '* 
	 '* @see removeInitializer()
	 '* @see org.flintParticles.common.initializers.Initializer.getDefaultPriority()
	 '*/
	Method AddInitializer:Void( initializer:Initializer )
		Local len:Int = _initializers.Length()
		Local i:Int
		For i = 0 Until len
			If( _initializers.get(i).GetPriority() < initializer.GetPriority() ) Then
				Exit
			Endif
		Next
		
		_initializers.Insert( i, initializer )
		initializer.AddedToEmitter( Self )
	End Method
	
	'/**
	 '* Removes an Initializer from the Emitter.
	 '* 
	 '* @param initializer The Initializer to remove
	 '* 
	 '* @see addInitializer()
	 '*/
	Method RemoveInitializer:Void( initializer:Initializer )
		If( _initializers.Contains( initializer ) ) Then
			_initializers.RemoveEach(initializer)
			initializer.RemovedFromEmitter( Self )
		Endif
	End Method
	
	'/**
	 '* Detects if the emitter is using a particular initializer or not.
	 '* 
	 '* @param initializer The initializer to look for.
	 '* 
	 '* @return true if the initializer is being used by the emitter, false 
	 '* otherwise.
	 '*/
	Method HasInitializer:Bool( initializer:Initializer )
		Return _initializers.Contains( initializer )
	End Method
	
	'/**
	 '* Detects if the emitter is using an initializer of a particular class.
	 '* 
	 '* @param initializerClass The type of initializer to look for.
	 '* 
	 '* @return true if the emitter is using an instance of the class as an
	 '* initializer, false otherwise.
	 '*/
	 ' TO-DO I dont think this is correct
	Method HasInitializerOfType:Bool( initializerClass:Object )
		Local len:Int = _initializers.Length()
		For Local i:Int = 0 Until len
			If( initializerClass(_initializers.Get(i)) <> Null ) Then
				Return True;
			Endif
		Next
		Return False
	End Method

	'/**
	 '* The array of all actions being used by this emitter.
	 '*/
	Method GetActions:Stack<Action>()
		Return _actions
	End Method
	Method SetActions:Void( value:Stack<Action> )
		Local action:Action
		For action = Eachin _actions
			action.RemovedFromEmitter( Self )
		Next
		For action = Eachin value
		    _actions.Push(action)
		Next
		For action = Eachin value
			action.AddedToEmitter( Self )
		Next
	End Method

	'/**
	 '* Adds an Action to the Emitter. Actions set the behaviour of particles 
	 '* created by the emitter.
	 '* 
	 '* @param action The Action to add
	 '* 
	 '* @see removeAction();
	 '* @see org.flintParticles.common.actions.Action.getDefaultPriority()
	 '*/
	Method AddAction:Void( action:Action )
		Local len:Int = _actions.Length()
		Local i:Int
		For i = 0 Until len
			If( _actions.get(i).GetPriority() < action.GetPriority() ) Then
				Exit
			Endif
		Next
		
		_initializers.Insert( i, action )
		action.AddedToEmitter( Self )
	
	End Method
	
	'/**
	 '* Removes an Action from the Emitter.
	 '* 
	 '* @param action The Action to remove
	 '* 
	 '* @see addAction()
	 '*/
	Method RemoveAction:Void( action:Action )
		If( _actions.Contains( action ) ) Then
			_actions.RemoveEach(action)
			action.RemovedFromEmitter( Self )
		Endif
	End Method
	
	'/**
	 '* Detects if the emitter is using a particular action or not.
	 '* 
	 '* @param action The action to look for.
	 '* 
	 '* @return true if the action is being used by the emitter, false 
	 '* otherwise.
	 '*/
	Method HasAction:Bool( action:Action )
		Return _actions.Contains( action )
	End Method
	
	'/**
	 '* Detects if the emitter is using an action of a particular class.
	 '* 
	 '* @param actionClass The type of action to look for.
	 '* 
	 '* @return true if the emitter is using an instance of the class as an
	 '* action, false otherwiseFalse'*/
	Method HasActionOfType:Bool( actionClass:Object )
		Local len:Int = _actions.Length()
		For Local i:Int = 0 Until len
			If( actionClass(_actions.Get(i)) <> Null ) Then
				Return True
			Endif
		Next
		Return False
	End Method

	'/**
	 '* The array of all actions being used by this emitter.
	 '*/
	Method GetActivities:Stack<Activity>()
		Return _activities
	End Method
	Method SetActivities:Void( value:Stack<Activity> )
		Local activity:Action
		For activity = Eachin _activities
			activity.RemovedFromEmitter( Self )
		Next
		For activity = Eachin value
		    _activities.Push(activity)
		Next
		For activity = Eachin value
			activity.AddedToEmitter( Self )
		Next
	End Method

	'/**
	 '* Adds an Activity to the Emitter. Activities set the behaviour
	 '* of the Emitter.
	 '* 
	 '* @param activity The activity to add
	 '* 
	 '* @see removeActivity()
	 '* @see org.flintParticles.common.activities.Activity.getDefaultPriority()
	 '*/
	Method AddActivity:Void( activity:Activity )
		Local len:Int = _activities.Length()
		Local i:Int
		For i = 0 Until len
			If( _activities.get(i).GetPriority() < activity.GetPriority() ) Then
				Exit
			Endif
		Next
		
		_activities.Insert( i, activity )
		activity.AddedToEmitter( Self )
	End Method
	
	'/**
	 '* Removes an Activity from the Emitter.
	 '* 
	 '* @param activity The Activity to remove
	 '* 
	 '* @see addActivity()
	 '*/
	Method RemoveActivity:Void( activity:Activity )
		If( _activities.Contains( activity ) ) Then
			_activities.RemoveEach(action)
			activity.RemovedFromEmitter( Self )
		Endif
	End Method
	
	'/**
	 '* Detects if the emitter is using a particular activity or not.
	 '* 
	 '* @param activity The activity to look for.
	 '* 
	 '* @return true if the activity is being used by the emitter, false 
	 '* otherwise.
	 '*/
	Method HasActivity:Bool( activity:Activity )
		Return _activities.Contains( activity )
	End Method
	
	'/**
	 '* Detects if the emitter is using an activity of a particular class.
	 '* 
	 '* @param activityClass The type of activity to look for.
	 '* 
	 '* @return true if the emitter is using an instance of the class as an
	 '* activity, false otherwise.
	 '*/
	Method HasActivityOfType:Bool( activityClass:Object )
		Local len:Int = _activities.Length()
		For Local i:Int = 0 Until len
			If( activityClass(_activities.Get(i)) <> Null ) Then
				Return True
			Endif
		Next
		Return False
	End Method

	'/**
	 '* The Counter for the Emitter. The counter defines when and
	 '* with what frequency the emitter emits particles.
	 '*/		
	Method GetCounter:Counter()
		return _counter
	End Method
	Method SetCounter:Void( value:Counter )
		_counter = value
		If( running ) Then
			_counter.StartEmitter( Self )
		Endif
	End Method
	
	'/**
	 '* Used by counters to tell the emitter to dispatch a counter complete event.
	 '*/
	'Method dispatchCounterComplete:void()
	'	_dispatchCounterComplete = true
	'End Method
	
	#rem
	' TO-DO Don't know now if it need
	'/**
	 '* Indicates whether the emitter should manage its own internal update
	 '* tick. The internal update tick is tied to the frame rate and updates
	 '* the particle system every frame.
	 '* 
	 '* <p>If users choose not to use the internal tick, they have to call
	 '* the emitter's update method with the appropriate time parameter every
	 '* time they want the emitter to update the particle system.</p>
	 '*/		
	Method GetUseInternalTick:Bool()
		return _useInternalTick
	End Method
	Method SetUseInternalTick:void( value:Bool )
		If( _useInternalTick <> value ) Then
			_useInternalTick = value
			If( _started ) Then
				If( _useInternalTick ) Then
					'FrameUpdater.instance.addEventListener( UpdateEvent.UPDATE, updateEventListener, False, 0, True );
				Else
					'FrameUpdater.instance.removeEventListener( UpdateEvent.UPDATE, updateEventListener );
				Endif
			Endif
		Endif
	End Method
	
	/**
	 * Indicates a fixed time (in seconds) to use for every frame. Setting 
	 * this property causes the emitter to bypass its frame timing 
	 * functionality and use the given time for every frame. This enables
	 * the particle system to be frame based rather than time based.
	 * 
	 * <p>To return to time based animation, set this value to zero (the 
	 * default).</p>
	 * 
	 * <p>This feature only works if useInternalTick is true (the default).</p>
	 * 
	 * @see #useInternalTick
	 */		
	Method get fixedFrameTime():Number
		return _fixedFrameTime;
	End Method
	Method set fixedFrameTime( value:Number ):void
		_fixedFrameTime = value;
	End Method
	#End
	
	'/**
	 '* Indicates if the emitter is currently running.
	 '*/
	Method GetRunning:Bool()
		return _running
	End Method
	
	'/**
	 '* This is the particle factory used by the emitter to create and dispose 
	 '* of particles. The 2D and 3D libraries each have a default particle
	 '* factory that is used by the Emitter2D and Emitter3D classes. Any custom 
	 '* particle factory should implement the ParticleFactory interface.
	 '* @see org.flintparticles.common.particles.ParticleFactory
	 '*/		
	Method GetParticleFactory:ParticleFactory()
		return _particleFactory
	End Method
	Method SetParticleFactory:Void( value:ParticleFactory )
		_particleFactory = value
	End Method
	
	'/**
	 '* The collection of all particles being managed by this emitter.
	 '*/
	Method GetParticles:Stack<Particle>()
		Return Stack<Particle>( _particles )
	End Method
	Method SetParticles:Void( value:Stack<Particle> )
		KillAllParticles()
		AddParticles( value, False )
	End Method

	'/**
	 '* The actual array of particles used internally by this emitter. You may want to use this to manipulate
	 '* the particles array directly or to provide optimized access to the array inside a custom
	 '* behaviour. If you don't need the actual array, using the particles property is slightly safer.
	 '* 
	 '* @see #particles
	 '*/
	Method GetParticlesArray:Particle[]()
		Return _particles.ToArray()
	End Method

	'/*
	 '* Used internally to create a particle.
	 '*/
	Method CreateParticle:Particle()
		Local particle:Particle = _particleFactory.CreateParticle()
		Local len:Int = _initializers.Length()
		InitParticle( particle )
		For Local i:Int = 0 Until len
			Initializer( _initializers.Get(i) ).Initialize( Self, particle )
		Next
		_particles.Push( particle )
		'if( hasEventListener( ParticleEvent.PARTICLE_CREATED ) )
		'{
		'	dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_CREATED, particle ) );
		'}
		Return particle
	End Method
	
	'/**
	 '* Emitters do their own particle initialization here - usually involves 
	 '* positioning and rotating the particle to match the position and rotation 
	 '* of the emitter. This method is called before any initializers that are
	 '* assigned to the emitter, so initializers can override any properties set 
	 '* here.
	 '* 
	 '* <p>The implementation of this method in this base class does nothing.</p>
	 '*/
	Method InitParticle:Void( particle:Particle )

	End Method
	
	'/**
	 '* Add a particle to the emitter. This enables users to create a
	 '* particle externally to the emitter and then pass the particle to this
	 '* emitter for management. Or remove a particle from one emitter and add
	 '* it to another.
	 '* 
	 '* @param particle The particle to add to this emitter
	 '* @param applyInitializers Indicates whether to apply the emitter's
	 '* initializer behaviours to the particle (true) or not (false).
	 '* 
	 '* @see #removeParticle()
	 '*/
	Method AddParticle:Void( particle:Particle, applyInitializers:Bool = False )
		If( applyInitializers ) Then
			Local len:Int = _initializers.Length()
			For Local i:Int = 0 Until len
				_initializers.Get(i).Initialize( Self, particle )
			Next
		Endif
		_particles.Push( particle )
		'If ( hasEventListener( ParticleEvent.PARTICLE_ADDED ) ) Then
		'	dispatchEvent( New ParticleEvent( ParticleEvent.PARTICLE_ADDED, particle ) );
		'Endif
	End Method
	
	'/**
	 '* Adds existing particles to the emitter. This enables users to create 
	 '* particles externally To the emitter And Then pass the particles To the
	 '* emitter for management. Or remove particles from one emitter and add
	 '* them to another.
	 '* 
	 '* @param particles The particles to add to this emitter
	 '* @param applyInitializers Indicates whether to apply the emitter's
	 '* initializer behaviours to the particle (true) or not (false).
	 '* 
	 '* @see #removeParticles()
	 '*/
	Method AddParticles:Void( particles:Stack<Particle>, applyInitializers:Bool = False )
		Local len:Int = particles.Length()
		If( applyInitializers ) Then
			Local len2:Int = _initializers.Length()
			For Local j:Int = 0 Until len2
				For Local i:Int = 0 Until len
					_initializers.Get(j).Initialize( Self, particles.Get(i) )
				Next
			Next
		Endif
		'if ( hasEventListener( ParticleEvent.PARTICLE_ADDED ) )
		'{
		'	for( i = 0; i < len; ++i )
		'	{
		'		_particles.push( particles[i] );
		'		dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_ADDED, particles[i] ) );
		'	}
		'}
		'else
		'{
			For Local i:Int = 0 Until len
				_particles.Push( particles.Get(i) )
			Next
		'}
	End Method
	
	'/**
	 '* Remove a particle from this emitter.
	 '* 
	 '* @param particle The particle to remove.
	 '* @return true if the particle was removed, false if it wasn't on this emitter in the first place.
	 '*/
	Method RemoveParticle:Bool( particle:Particle )
		Local index:int = _particles.indexOf( particle )
		If( _particles.Contains(particle) ) Then
			If( _updating ) Then
				addEventListener( EmitterEvent.EMITTER_UPDATED, function( e:EmitterEvent ) : void
				{
					removeEventListener( EmitterEvent.EMITTER_UPDATED, arguments.callee );
					removeParticle( particle );
				});
			Else
				_particles.splice( index, 1 );
				dispatchEvent( New ParticleEvent( ParticleEvent.PARTICLE_REMOVED, particle ) );
			Endif
			Return True
		Endif
		Return False
	End Method
	
	'/**
	 '* Remove a collection of particles from this emitter.
	 '* 
	 '* @param particles The particles to remove.
	 '*/
	Method RemoveParticles:Void( particles:Stack<Particle> )
		If( _updating )
		{
			addEventListener( EmitterEvent.EMITTER_UPDATED, function( e:EmitterEvent ) : void
			{
				removeEventListener( EmitterEvent.EMITTER_UPDATED, arguments.callee );
				removeParticles( particles );
			});
		}
		else
		{
			for( var i:int = 0, len:int = particles.length; i < len; ++i )
			{
				var index:int = _particles.indexOf( particles[i] );
				if( index != -1 )
				{
					_particles.splice( index, 1 );
					dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_REMOVED, particles[i] ) );
				}
			}
		}
	End Method

	'/**
	 '* Kill all the particles on this emitter.
	 '*/
	Method KillAllParticles:void()
		Local len:Int = _particles.Length()

		'If ( hasEventListener( ParticleEvent.PARTICLE_DEAD ) )
		'{
		'	for ( i = 0; i < len; ++i )
		'	{
		'		dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_DEAD, _particles[i] ) );
		'		_particleFactory.disposeParticle( _particles[i] );
		'	}
		'}
		'else
		'{
			For Local i:Int = 0 Until len Then
				_particleFactory.DisposeParticle( _particles.Get(i) )
			Endif
		'}
		_particles.length = 0;
	End Method
	
	'/**
	 '* Starts the emitter. Until start is called, the emitter will not emit or 
	 '* update any particles.
	 '*/
	Method Start:Void()
		_started = True;
		_running = True;
		Local len:Int = _activities.Length()
		For Local i:Int = 0 Until len
			Activity( _activities.Get(i) ).Initialize( Self )
		Next
		len = _counter.StartEmitter( Self )
		For i = 0 Until len
			CreateParticle()
		Next
	End Method
	
	'/**
	 '* Update event listener used to fire the update function when using teh internal tick.
	 '*/
	'Method updateEventListener:Void( ev:UpdateEvent )
	'	If( _fixedFrameTime )
	'	{
	'		update( _fixedFrameTime );
	'	}
	'	else
	'	{
	'		update( ev.time );
	'	}
	'End Method
	
	'/**
	 '* Used to update the emitter. If using the internal tick, this method
	 '* will be called every frame without any action by the user. If not
	 '* using the internal tick, the user should call this method on a regular
	 '* basis to update the particle system.
	 '* 
	 '* <p>The method asks the counter how many particles to create then creates 
	 '* those particles. Then it calls sortParticles, applies the activities to 
	 '* the emitter, applies the Actions to all the particles, removes all dead 
	 '* particles, and finally dispatches an emitterUpdated event which tells 
	 '* any renderers to redraw the particles.</p>
	 '* 
	 '* @param time The duration, in seconds, to be applied in the update step.
	 '* 
	 '* @see sortParticles();
	 '*/
	Method Update:void( time:Number )
		If( _running <> True ) Then
			Return
		Endif
		If( time > _maximumFrameTime ) Then
			time = _maximumFrameTime
		Endif
		Local i:Int
		Local particle:Particle
		_updating = True
		Locale len:Int = _counter.UpdateEmitter( Self, time )
		For i = 0 Until len
			CreateParticle()
		Next
		SortParticles()
		len = _activities.Length()
		For i = 0 Until len
			Activity( _activities.Get(i) ).Update( Self, time )
		Next
		
		If ( _particles.Length() > 0 ) Then
			
			'// update particle state
			len = _actions.Length()
			var action:Action
			var len2:Int = _particles.Length()
			var j:int
			If( _processLastFirst ) Then
				For( j = 0; j < len; ++j )
				{
					action = _actions[j];
					For ( i = len2 - 1; i >= 0; --i )
					{
						particle = _particles[i];
						action.update( Self, particle, time );
					}
				}
			Else
			{
				For( j = 0; j < len; ++j )
				{
					action = _actions[j];
					For ( i = 0; i < len2; ++i )
					{
						particle = _particles[i];
						action.update( Self, particle, time );
					}
				}
			Endif
			_processLastFirst = Not _processLastFirst
			
			'// remove dead particles
			
				for ( i = len2; i--; )
				{
					particle = _particles[i];
					if ( particle.isDead )
					{
						_particles.splice( i, 1 );
						_particleFactory.DisposeParticle( particle );
					}
				}
		Endif

		_updating = False
		
	End Method
	
	'/**
	 '* Used to sort the particles as required. In this base class this method 
	 '* does nothing.
	 '*/
	'Method SortParticles:Void()
	'End Method
	
	'/**
	 '* Pauses the emitter.
	 '*/
	Method Pause:Void()
		_running = False
	End Method
	
	'/**
	 '* Resumes the emitter after a pause.
	 '*/
	Method Resume:Void()
		_running = True
	End Method
	
	'/**
	 '* Stops the emitter, killing all current particles And returning them To the 
	 '* particle factory For reuse.
	 '*/
	Method Stop:Void()
		'if( _useInternalTick )
		'{
		'	FrameUpdater.instance.removeEventListener( UpdateEvent.UPDATE, updateEventListener );
		'}
		_started = False
		_running = False
		KillAllParticles()
	End Method
	
	'/**
	 '* Makes the emitter skip forwards a period of time with a single update.
	 '* Used when you want the emitter to look like it's been running for a while.
	 '* 
	 '* @param time The time, in seconds, to skip ahead.
	 '* @param frameRate The frame rate for calculating the new positions. The
	 '* emitter will calculate each frame over the time period to get the new state
	 '* for the emitter and its particles. A higher frameRate will be more
	 '* accurate but will take longer to calculate.
	 '*/
	Method RunAhead:Void( time:Float, frameRate:Float= 10 )
		Local maxTime:Float = _maximumFrameTime
		Local ustep:Float = 1 / frameRate
		_maximumFrameTime = ustep
		While ( time > 0 ) Then
			time -= ustep
			update( ustep )
		Wend
		_maximumFrameTime = maxTime
	End Method
	
	'Method PrioritySort:Float( b1:Behaviour, b2:Behaviour )
	'	return b1.priority - b2.priority
	'End Method
End Class