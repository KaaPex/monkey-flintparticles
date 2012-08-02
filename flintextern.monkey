Import "native/flintparticles.${TARGET}.${LANG}"

Extern

#If LANG<>"cpp"
	Function Lsr:Int( number:Int, shiftBy:Int ) = "flintparticles.Lsr"
	Function Lsl:Int( number:Int, shiftBy:Int ) = "flintparticles.Lsl"
#Else
	Function Lsr:Int( number:Int, shiftBy:Int ) = "flintparticles::Lsr"
	Function Lsl:Int( number:Int, shiftBy:Int ) = "flintparticles::Lsl"
#End