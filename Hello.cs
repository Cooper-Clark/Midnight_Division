using Godot;
using System;

public partial class Hello : Node
{
    public override void _Ready()
    {
        GD.Print("Hello, World!"); 
        GD.Print("Welcome to Godot with C#!");
        GD.Print("This is a simple script to demonstrate C# scripting in Godot.");
    }
}
