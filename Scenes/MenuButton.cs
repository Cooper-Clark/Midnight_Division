using Godot;
using System;

public partial class MenuButton : Button
{
    // The menu that will be shown when this button is pressed.\
    [Export]
    public Godot.Control otherMenu;

    override public void _Ready()
    {
        Connect("pressed", new Callable(this, nameof(OnPressed)));
    }   

    void OnPressed()
    {
        ChangeMenu();
    }

    void ChangeMenu()
    {
        Visible = false;
        otherMenu.Visible = true;
    }
}
