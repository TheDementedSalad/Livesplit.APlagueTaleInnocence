// Contains functionality for load removal, autostart, and autosplitting.

state("APlagueTaleInnocence_x64", "Steam")
{
    bool loading 	: "WwiseLibPCx64R.dll", 0x262521;
    int playerControl   : 0x152E91C;
    string50 Map 	: 0x015206E0, 0x88, 0x0, 0xD0, 0x990, 0x260;
}

state("APlagueTaleInnocence_x64", "Epic")
{
    bool loading 	: "WwiseLibPCx64R.dll", 0x262521;
    int playerControl   : 0x152E6DC;
    string50 Map 	: 0x016AADC0, 0x10, 0x110, 0xD8, 0x10, 0x30, 0x170, 0x260;
}

state("APlagueTaleInnocence_x64", "Xbox")
{
    bool loading 	: "WwiseLibPCx64R.dll", 0x262521; 
    int playerControl   : 0x1744EBC;
    string50 Map 	: "MessageBus.dll", 0x005C0DE0, 0x340, 0x668; 
}

init
{
    switch (modules.First().ModuleMemorySize) { // This is to know what version you are playing on
        case  25473024: version = "Steam"; // Meta add the module size here
            break;
        case    25284608: version = "Epic"; 
            break;
        case    27566080: version = "Xbox"; 
            break;
        default:        version = ""; 
            break;
    }
    vars.doneMaps = new List<string>();
}

startup
{
    settings.Add("APT", true, "All Chapters");

    vars.Chapters = new Dictionary<string,string> 
	{
        // { "DOMAIN",        "Chapter 1 - The de Rune Legacy" },
        { "VILLAGE",          "Chapter 2 - The Strangers" },
        { "VILLAGE2",         "Chapter 3 - Retribution" },
        { "FARM",             "Chapter 4 - The Apprentice" },
        { "BATTLEFIELD",      "Chapter 5 - The Ravens' Spoils" },
        { "BATTLEFIELD2",     "Chapter 6 - Damaged Goods" },
        { "SHELTER_FOREST",   "Chapter 7 - The Path Before Us" },
        { "SHELTER_MORNING",  "Chapter 8 - Our Home" },
        { "UNIVERSITY",       "Chapter 9 - In the Shadow of Ramparts" },
        { "UNIVERSITY2",      "Chapter 10 - The Way of Roses" },
        { "SHELTER_SAFE",     "Chapter 11 - Alive" },
        { "CORRUPTED_DOMAIN", "Chapter 12 - All That Remains" },
        { "ILLUSION",         "Chapter 13 - Penance" },
        { "INQUISITION",      "Chapter 14 - Blood Ties" },
        { "SHELTER_SIEGE",    "Chapter 15 - Remembrance" },
        { "CATHEDRAL",        "Chapter 16 - Coronation" },
        { "EPILOGUE",         "Chapter 17 - For Each Other" }
    };
    foreach (var Tag in vars.Chapters)
		{
			settings.Add(Tag.Key, true, Tag.Value, "APT");
    	};

    vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
            vars.doneMaps.Add(current.Map.Split('>')[1]); // Adding for the starting map because it's also bad
        });
    timer.OnStart += vars.onStart; 

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
    return (current.Map.Contains("DOMAIN") && current.playerControl == 4024 && old.playerControl == 4025);
}

update
{
//DEBUG CODE
//  print(current.loading.ToString());  
// print(current.Map.Split('>')[1].ToString());
}        

split
{
    if (settings[current.Map.Split('>')[1]] && (!vars.doneMaps.Contains(current.Map.Split('>')[1])))
    {
        vars.doneMaps.Add(current.Map.Split('>')[1]);
        return true;
    }
}

isLoading
{
    return current.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}

shutdown
{
    timer.OnStart -= vars.OnStart;
}
