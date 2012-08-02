Import flintparticles

Import mojo

Class Game Extends App

    Method OnCreate()
        Print "hello"
        Print(InterpolateColors( $FF0000, $00FF00, 0.5))
    End

End

Function Main()
    New Game()
End