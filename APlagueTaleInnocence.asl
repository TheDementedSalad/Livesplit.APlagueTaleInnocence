// Contains functionality for load removal, autostart, and autosplitting.
// Thanks to LongerWarrior for new pointers that helped smooth out cutscene issues, as well as the solution for pausing the timer on crashes

state("APlagueTaleInnocence_x64")
{
    bool loading : "WwiseLibPCx64R.dll", 0x262521;
    int menuState : "WwiseLibPCx64R.dll", 0x00262108, 0x80, 0xC8, 0x0, 0x1E8, 0x108, 0x70c; // obsolete, chapterState || playerControl can be used for autostart instead
    int chapterState : 0x01944240, 0x818, 0x518;
    int playerControl : 0x1744EBC;
}

init
{
    vars.menuState = false;
}

startup
  {
		if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | A Plague Tale Innocence",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

start
{
    return (current.playerControl == 4024 && old.playerControl == 4025);
}

update
{     
//DEBUG CODE
//  print(current.loading.ToString());  
//  print(current.menuState.ToString());
//  print(current.chapterState.ToString());
//  print(current.playerControl.ToString());
}        

split
{
    return (current.menuState != 0 && current.chapterState != old.chapterState);
}

isLoading
{
    return current.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}