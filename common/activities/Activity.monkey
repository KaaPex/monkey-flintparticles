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

import flintparticles.common.behaviours.Behaviour
import flintparticles.common.emitters.Emitter	

'/**
 '* The Activity interface must be implemented by all emitter activities.
 '* 
 '* <p>An Activity is a class that is used to continuously modify an aspect 
 '* of an emitter by updating the emitter every frame. Activities may, for 
 '* example, move or rotate the emitter.</p>
 '* 
 '* <p>Activities are associated with emitters by using the emitter's 
 '* addActivity method. Activities are removed from the emitter by using 
 '* the emitter's removeActivity method.</p>
 '* 
 '* @see org.flintparticles.common.emitters.Emitter#addActivity()
 '* @see org.flintparticles.common.emitters.Emitter#removeActivity()
 '*/
Interface Activity Extends Behaviour

	'/**
	 '* The initialize Method is used by the emitter To start the activity.
	 '* It is called within the emitter's start method and need not
	 '* be called by the user.
	 '* 
	 '* @param emitter The Emitter that is using the activity.
	 '*/
	Method Initialize:Void( emitter:Emitter )
	
	'/**
	 '* The update Method is used by the emitter To apply the activity.
	 '* It is the key feature of the activity And is used To update the state
	 '* of the emitter. This Method is called within the emitter's update loop 
	 '* And need Not be called by the user.
	 '* 
	 '* @param emitter The Emitter that is using the activity.
	 '* @param time The duration of the frame (in seconds) - used For time based 
	 '* updates.
	 '*/
	Method Update:Void( emitter:Emitter, time:Number )
	
End Interface
