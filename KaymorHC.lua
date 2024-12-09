import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";

MyPlugin = class(Turbine.UI.Window);

function MyPlugin:Constructor()
    Turbine.UI.Window.Constructor(self);

    self:SetSize(1920, 1080);
    self:SetPosition(0, 0); -- Position the window at the top-left corner
    self:SetVisible(true);
    self:SetMouseVisible(false);  -- Ignore mouse events for the main window
    
    -- Check if the character is already in a game-over state
    if self:IsGameOver() then
        self:DisplayGameOverScreen();
    end

    local button = Turbine.UI.Lotro.Button();
    button:SetParent(self);
    button:SetText("Survival");
    button:SetSize(100, 30);
    button:SetMouseVisible(true);  -- Ensure the button handles mouse events

    -- Load the saved position
    local buttonX, buttonY = self:LoadPosition();
    buttonX = (buttonX and buttonX >= 0 and buttonX <= 1920 - button:GetWidth()) and buttonX or 400; -- Ensure buttonX is within screen bounds
    buttonY = (buttonY and buttonY >= 0 and buttonY <= 1080 - button:GetHeight()) and buttonY or 300; -- Ensure buttonY is within screen bounds
    button:SetPosition(buttonX, buttonY);
    button:SetVisible(true); -- Ensure button is visible


    local dragging = false;
    local dragStartX, dragStartY;
    local buttonStartX, buttonStartY;

    local menu = nil; -- Variable to track the menu window

    button.MouseDown = function(sender, args)
        dragging = true;
        local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
        dragStartX = mouseX - button:GetLeft();
        dragStartY = mouseY - button:GetTop();
        buttonStartX, buttonStartY = button:GetPosition();
        self:SetWantsUpdates(true);  -- Enable updates for smooth dragging
    end

    button.MouseUp = function(sender, args)
        dragging = false;
        self:SetWantsUpdates(false);  -- Disable updates when not dragging
        -- Save the new position when dragging stops
        local newX = button:GetLeft();
        local newY = button:GetTop();
        self:SavePosition(newX, newY);
    end

    button.MouseMove = function(sender, args)
        if dragging then
            local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
            local newX = mouseX - dragStartX;
            local newY = mouseY - dragStartY;
            -- Clamp position to screen bounds (including top and left)
            newX = math.max(0, newX);
            newY = math.max(0, newY);
            newX = math.min(newX, 1920 - button:GetWidth());
            newY = math.min(newY, 1080 - button:GetHeight());
            button:SetPosition(newX, newY);
        end
    end

    self.Update = function(sender, args)
        if dragging then
            local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
            local newX = mouseX - dragStartX;
            local newY = mouseY - dragStartY;
            -- Clamp position to screen bounds (including top and left)
            newX = math.max(0, newX);
            newY = math.max(0, newY);
            newX = math.min(newX, 1920 - button:GetWidth());
            newY = math.min(newY, 1080 - button:GetHeight());
            button:SetPosition(newX, newY);
        end
    end

    button.Click = function(sender, args)
        if menu and menu:IsVisible() then
            menu:SetVisible(false); -- Close the existing menu window
            menu = nil;
        else
            menu = Turbine.UI.Lotro.Window();
            menu:SetSize(600, 550);
            menu:SetPosition(450, 350); -- Adjust position as needed
            menu:SetText("Survival Mode");
            menu:SetVisible(true);

            local closeButton = Turbine.UI.Lotro.Button();
            closeButton:SetParent(menu);
            closeButton:SetText("Close");
            closeButton:SetSize(100, 30);
            closeButton:SetPosition(250, 520);

            closeButton.Click = function(sender, args)
                menu:SetVisible(false);
                menu = nil; -- Ensure the variable is cleared
            end
            
            -- Create a label to display the centered title
            local titleLabel = Turbine.UI.Label();
            titleLabel:SetParent(menu);
            titleLabel:SetSize(580, 40); -- Adjust size as needed
            titleLabel:SetPosition(10, 10); -- Adjust position as needed
            titleLabel:SetText("\n\nWelcome to Survival LOTRO!");
            titleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); -- Center the title text
            titleLabel:SetForeColor(Turbine.UI.Color.White);
            titleLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
            titleLabel:SetVisible(true);

            -- Create a label to display the additional text
            local infoLabel = Turbine.UI.Label();
            infoLabel:SetParent(menu);
            infoLabel:SetSize(580, 260); -- Adjust size as needed
            infoLabel:SetPosition(10, 60); -- Position below the title
            infoLabel:SetText("In this mode, if your character's HP reaches zero, it's game over.\nBe cautious and enjoy the challenge! Designed in mind to be played level 1-max level without dying. Death is a failure and should result in starting over.");
            infoLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft); -- Left-align the additional text
            infoLabel:SetForeColor(Turbine.UI.Color.White);
            infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
            infoLabel:SetVisible(true);
			
            -- Create a label to display the additional text
            local infoLabel = Turbine.UI.Label();
            infoLabel:SetParent(menu);
            infoLabel:SetSize(580, 260); -- Adjust size as needed
            infoLabel:SetPosition(150, 110); 
            infoLabel:SetText("Choose your own difficulty honor system");
            infoLabel:SetForeColor(Turbine.UI.Color.White);
            infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
            infoLabel:SetVisible(true);
			
            -- Create a label to display the additional text
            local infoLabel = Turbine.UI.Label();
            infoLabel:SetParent(menu);
            infoLabel:SetSize(100, 100); -- Adjust size as needed
            infoLabel:SetPosition(250, 275); 
            infoLabel:SetText("Things to know");		
            infoLabel:SetForeColor(Turbine.UI.Color.White);
            infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
            infoLabel:SetVisible(true);

            -- Create a label to display the additional text
            local infoLabel = Turbine.UI.Label();
            infoLabel:SetParent(menu);
            infoLabel:SetSize(600, 215); -- Adjust size as needed
            infoLabel:SetPosition(10, 300); 
            infoLabel:SetText("This plugin monitors HP. When it reaches 0 it will trigger a game over screen.\nAbilities that simulate this will most likely cause it to trigger as well. You \ncan continue the challenge if this happens, you'll just have to honor system it.\n\nThere are known quests that force kill the player. You can try to avoid these as part of the challenge, or follow the honor system if it triggers false game over. \n\nKinship leaders and people playing survival together decide ruleset and everyone follows those rules. Solo players not in a survival kinship do your own rules.\n\nIf your button becomes inactive press F7 twice to reset it's location.\n\nThis plugin is about playing with who you want and how you want to play with set restrictions of choice trying to survive to the best of your ability.\n\nAs of right now, checkboxes don't do anything and don't save. They're just there for assistance. Maybe this can change in the future.");		
            infoLabel:SetForeColor(Turbine.UI.Color.White);
            infoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
            infoLabel:SetVisible(true);			
			   
		   -- Create and initialize checkboxes
           local checkBox1 = Turbine.UI.Lotro.CheckBox();
           checkBox1:SetParent(menu);
           checkBox1:SetText("You May Give But Not Take Anything From Other Players");
           checkBox1:SetPosition(15, 130);
		   checkBox1:SetSize(250, 50); -- Set the width to accommodate the text 
		   checkBox1:SetMultiline(true); -- Enable text wrapping
           checkBox1:SetChecked(self:LoadCheckBoxState("CheckBox1", true));
           checkBox1.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox1", checkBox1:IsChecked());
           end
		   
		   -- Create tooltip control
		   local tooltip = Turbine.UI.Window();
		   tooltip:SetSize(300, 65);
		   tooltip:SetPosition(35, 165);
		   tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
		   tooltip:SetVisible(false);

		   local tooltipLabel = Turbine.UI.Label();
		   tooltipLabel:SetParent(tooltip);
		   tooltipLabel:SetSize(280, 60);
		   tooltipLabel:SetPosition(10, 5);
		   tooltipLabel:SetText("Can't give to other players if they're playing survival unless: Survival Kinships and people playing survival together may trade amongst themselves if they wish.");
		   tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		   tooltipLabel:SetForeColor(Turbine.UI.Color.White);
		   tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		   tooltipLabel:SetVisible(true);

		   -- Show and move tooltip on mouse enter and move
		   checkBox1.MouseEnter = function(sender, args)
			   tooltip:SetVisible(true);
		   end

		   -- Hide tooltip on mouse leave
		   checkBox1.MouseLeave = function(sender, args)
			   tooltip:SetVisible(false);
		   end

		   -- Add the tooltip to the menu
		   tooltip:SetParent(menu);

           local checkBox2 = Turbine.UI.Lotro.CheckBox();
           checkBox2:SetParent(menu);
           checkBox2:SetText("Hardened Traveller Active");
           checkBox2:SetPosition(15, 165); -- Adjusted position
		   checkBox2:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox2:SetMultiline(true); -- Enable text wrapping
           checkBox2:SetChecked(self:LoadCheckBoxState("CheckBox2", true));
           checkBox2.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox2", checkBox2:IsChecked());
           end
		   
		   local checkBox3 = Turbine.UI.Lotro.CheckBox();
           checkBox3:SetParent(menu);
           checkBox3:SetText("No Grouping With People 6+ Levels Higher Than You");
           checkBox3:SetPosition(15, 190); -- Adjusted position
		   checkBox3:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox3:SetMultiline(true); -- Enable text wrapping
           checkBox3:SetChecked(self:LoadCheckBoxState("CheckBox3", true));
           checkBox3.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox3", checkBox3:IsChecked());
           end
		   
		   -- Create tooltip control
		   local tooltip = Turbine.UI.Window();
		   tooltip:SetSize(300, 65);
		   tooltip:SetPosition(35, 240);
		   tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
		   tooltip:SetVisible(false);

		   local tooltipLabel = Turbine.UI.Label();
		   tooltipLabel:SetParent(tooltip);
		   tooltipLabel:SetSize(280, 60);
		   tooltipLabel:SetPosition(10, 5);
		   tooltipLabel:SetText("You can group with anyone within 5 levels, whether playing survival or not. If they start to die, do anything it takes to survive.");
		   tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		   tooltipLabel:SetForeColor(Turbine.UI.Color.White);
		   tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		   tooltipLabel:SetVisible(true);

		   -- Show and move tooltip on mouse enter and move
		   checkBox3.MouseEnter = function(sender, args)
			   tooltip:SetVisible(true);
		   end

		   -- Hide tooltip on mouse leave
		   checkBox3.MouseLeave = function(sender, args)
			   tooltip:SetVisible(false);
		   end

		   -- Add the tooltip to the menu
		   tooltip:SetParent(menu);
		   
		   local checkBox4 = Turbine.UI.Lotro.CheckBox();
           checkBox4:SetParent(menu);
           checkBox4:SetText("No Stable Traveling");
           checkBox4:SetPosition(15, 215); -- Adjusted position
		   checkBox4:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox4:SetMultiline(true); -- Enable text wrapping
           checkBox4:SetChecked(self:LoadCheckBoxState("CheckBox4", true));
           checkBox4.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox4", checkBox4:IsChecked());
           end
		   
		   -- Create tooltip control
		   local tooltip = Turbine.UI.Window();
		   tooltip:SetSize(300, 50);
		   tooltip:SetPosition(35, 240);
		   tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
		   tooltip:SetVisible(false);

		   local tooltipLabel = Turbine.UI.Label();
		   tooltipLabel:SetParent(tooltip);
		   tooltipLabel:SetSize(280, 40);
		   tooltipLabel:SetPosition(10, 5);
		   tooltipLabel:SetText("This mostly refers to swift and mithral travel. Basic travel is up to you.");
		   tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		   tooltipLabel:SetForeColor(Turbine.UI.Color.White);
		   tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		   tooltipLabel:SetVisible(true);

		   -- Show and move tooltip on mouse enter and move
		   checkBox4.MouseEnter = function(sender, args)
			   tooltip:SetVisible(true);
		   end

		   -- Hide tooltip on mouse leave
		   checkBox4.MouseLeave = function(sender, args)
			   tooltip:SetVisible(false);
		   end

		   -- Add the tooltip to the menu
		   tooltip:SetParent(menu);
		   
		   local checkBox5 = Turbine.UI.Lotro.CheckBox();
           checkBox5:SetParent(menu);
           checkBox5:SetText("No Experiance Boosts Of Any Kind");
           checkBox5:SetPosition(15, 240); -- Adjusted position
		   checkBox5:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox5:SetMultiline(true); -- Enable text wrapping
           checkBox5:SetChecked(self:LoadCheckBoxState("CheckBox5", true));
           checkBox5.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox5", checkBox5:IsChecked());
           end
		   
		   local checkBox6 = Turbine.UI.Lotro.CheckBox();
           checkBox6:SetParent(menu);
           checkBox6:SetText("No Mailbox");
           checkBox6:SetPosition(250, 140); -- Adjusted position
		   checkBox6:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox6:SetMultiline(true); -- Enable text wrapping
           checkBox6:SetChecked(self:LoadCheckBoxState("CheckBox6", true));
           checkBox6.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox6", checkBox6:IsChecked());
           end
		   
		   local checkBox7 = Turbine.UI.Lotro.CheckBox();
           checkBox7:SetParent(menu);
           checkBox7:SetText("No Hobbit Gift");
           checkBox7:SetPosition(250, 165); -- Adjusted position
		   checkBox7:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox7:SetMultiline(true); -- Enable text wrapping
           checkBox7:SetChecked(self:LoadCheckBoxState("CheckBox7", true));
           checkBox7.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox7", checkBox7:IsChecked());
           end
		   
		   local checkBox8 = Turbine.UI.Lotro.CheckBox();
           checkBox8:SetParent(menu);
           checkBox8:SetText("No VIP Rewards");
           checkBox8:SetPosition(250, 190); -- Adjusted position
		   checkBox8:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox8:SetMultiline(true); -- Enable text wrapping
           checkBox8:SetChecked(self:LoadCheckBoxState("CheckBox8", true));
           checkBox8.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox8", checkBox8:IsChecked());
           end
		   
		   local checkBox9 = Turbine.UI.Lotro.CheckBox();
           checkBox9:SetParent(menu);
           checkBox9:SetText("No LOTRO Store");
           checkBox9:SetPosition(250, 215); -- Adjusted position
		   checkBox9:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox9:SetMultiline(true); -- Enable text wrapping
           checkBox9:SetChecked(self:LoadCheckBoxState("CheckBox9", true));
           checkBox9.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox9", checkBox9:IsChecked());
           end
		   
		   -- Create tooltip control
		   local tooltip = Turbine.UI.Window();
		   tooltip:SetSize(300, 50);
		   tooltip:SetPosition(270, 240);
		   tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
		   tooltip:SetVisible(false);

		   local tooltipLabel = Turbine.UI.Label();
		   tooltipLabel:SetParent(tooltip);
		   tooltipLabel:SetSize(280, 40);
		   tooltipLabel:SetPosition(10, 5);
		   tooltipLabel:SetText("Basic Riding Skill(95 points) and cosmetics are okay.");
		   tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		   tooltipLabel:SetForeColor(Turbine.UI.Color.White);
		   tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		   tooltipLabel:SetVisible(true);

		   -- Show and move tooltip on mouse enter and move
		   checkBox9.MouseEnter = function(sender, args)
			   tooltip:SetVisible(true);
		   end

		   -- Hide tooltip on mouse leave
		   checkBox9.MouseLeave = function(sender, args)
			   tooltip:SetVisible(false);
		   end

		   -- Add the tooltip to the menu
		   tooltip:SetParent(menu);
		   
		   local checkBox10 = Turbine.UI.Lotro.CheckBox();
           checkBox10:SetParent(menu);
           checkBox10:SetText("No Auction House");
           checkBox10:SetPosition(250, 240); -- Adjusted position
		   checkBox10:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox10:SetMultiline(true); -- Enable text wrapping
           checkBox10:SetChecked(self:LoadCheckBoxState("CheckBox10", true));
           checkBox10.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox10", checkBox10:IsChecked());
           end
		   
		   local checkBox11 = Turbine.UI.Lotro.CheckBox();
           checkBox11:SetParent(menu);
           checkBox11:SetText("Play On Legendary Server");
           checkBox11:SetPosition(400, 140); -- Adjusted position
		   checkBox11:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox11:SetMultiline(true); -- Enable text wrapping
           checkBox11:SetChecked(self:LoadCheckBoxState("CheckBox11", true));
           checkBox11.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox11", checkBox11:IsChecked());
           end
		   
		   local checkBox12 = Turbine.UI.Lotro.CheckBox();
           checkBox12:SetParent(menu);
           checkBox12:SetText("No Using Professions For 'EXP Only'");
           checkBox12:SetPosition(400, 165); -- Adjusted position
		   checkBox12:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox12:SetMultiline(true); -- Enable text wrapping
           checkBox12:SetChecked(self:LoadCheckBoxState("CheckBox12", true));
           checkBox12.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox12", checkBox12:IsChecked());
           end
		   
		   -- Create tooltip control
		   local tooltip = Turbine.UI.Window();
		   tooltip:SetSize(300, 65);
		   tooltip:SetPosition(425, 190);
		   tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
		   tooltip:SetVisible(false);

		   local tooltipLabel = Turbine.UI.Label();
		   tooltipLabel:SetParent(tooltip);
		   tooltipLabel:SetSize(280, 60);
		   tooltipLabel:SetPosition(10, 5);
		   tooltipLabel:SetText("Once your profession is maxed out, you can use it as normal, but not for EXP.");
		   tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		   tooltipLabel:SetForeColor(Turbine.UI.Color.White);
		   tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		   tooltipLabel:SetVisible(true);

		   -- Show and move tooltip on mouse enter and move
		   checkBox12.MouseEnter = function(sender, args)
			   tooltip:SetVisible(true);
		   end

		   -- Hide tooltip on mouse leave
		   checkBox12.MouseLeave = function(sender, args)
			   tooltip:SetVisible(false);
		   end

		   -- Add the tooltip to the menu
		   tooltip:SetParent(menu);
		   
		   local checkBox13 = Turbine.UI.Lotro.CheckBox();
           checkBox13:SetParent(menu);
           checkBox13:SetText("No Shared Storage");
           checkBox13:SetPosition(400, 190); -- Adjusted position
		   checkBox13:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox13:SetMultiline(true); -- Enable text wrapping
           checkBox13:SetChecked(self:LoadCheckBoxState("CheckBox13", true));
           checkBox13.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox13", checkBox13:IsChecked());
           end
		   
		   -- Create and initialize checkbox
		   local checkBox14 = Turbine.UI.Lotro.CheckBox();
		   checkBox14:SetParent(menu);
		   checkBox14:SetText("No Intentionally Getting Mob Tagged");
		   checkBox14:SetPosition(400, 215); -- Adjusted position
		   checkBox14:SetSize(200, 30); -- Set the width to accommodate the text
		   checkBox14:SetMultiline(true); -- Enable text wrapping
		   checkBox14:SetChecked(self:LoadCheckBoxState("CheckBox14", true));
		   checkBox14.CheckedChanged = function(sender, args)
		       self:SaveCheckBoxState("CheckBox14", checkBox14:IsChecked());
		   end

		   -- Create tooltip control
		   local tooltip = Turbine.UI.Window();
		   tooltip:SetSize(300, 50);
		   tooltip:SetPosition(420, 240);
		   tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
		   tooltip:SetVisible(false);

		   local tooltipLabel = Turbine.UI.Label();
		   tooltipLabel:SetParent(tooltip);
		   tooltipLabel:SetSize(280, 40);
		   tooltipLabel:SetPosition(10, 5);
		   tooltipLabel:SetText("Avoid intentionally tagging mobs for help from high-level players.");
		   tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		   tooltipLabel:SetForeColor(Turbine.UI.Color.White);
		   tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		   tooltipLabel:SetVisible(true);

		   -- Show and move tooltip on mouse enter and move
		   checkBox14.MouseEnter = function(sender, args)
			   tooltip:SetVisible(true);
		   end

		   -- Hide tooltip on mouse leave
		   checkBox14.MouseLeave = function(sender, args)
			   tooltip:SetVisible(false);
		   end

		   -- Add the tooltip to the menu
		   tooltip:SetParent(menu);
		   
		   local checkBox15 = Turbine.UI.Lotro.CheckBox();
           checkBox15:SetParent(menu);
           checkBox15:SetText("No One Left Behind");
           checkBox15:SetPosition(400, 240); -- Adjusted position
		   checkBox15:SetSize(200, 30); -- Set the width to accommodate the text 
		   checkBox15:SetMultiline(true); -- Enable text wrapping
           checkBox15:SetChecked(self:LoadCheckBoxState("CheckBox15", true));
           checkBox15.CheckedChanged = function(sender, args)
               self:SaveCheckBoxState("CheckBox15", checkBox15:IsChecked());
           end
		   -- Create tooltip control
		   local tooltip = Turbine.UI.Window();
		   tooltip:SetSize(300, 50);
		   tooltip:SetPosition(420, 270);
		   tooltip:SetBackColor(Turbine.UI.Color(1, 0, 0, 0)); -- solid black background
		   tooltip:SetVisible(false);

		   local tooltipLabel = Turbine.UI.Label();
		   tooltipLabel:SetParent(tooltip);
		   tooltipLabel:SetSize(280, 40);
		   tooltipLabel:SetPosition(10, 5);
		   tooltipLabel:SetText("If one person dies in your survival based followship(all party members are playing survival) you all die.");
		   tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		   tooltipLabel:SetForeColor(Turbine.UI.Color.White);
		   tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		   tooltipLabel:SetVisible(true);

		   -- Show and move tooltip on mouse enter and move
		   checkBox15.MouseEnter = function(sender, args)
			   tooltip:SetVisible(true);
		   end

		   -- Hide tooltip on mouse leave
		   checkBox15.MouseLeave = function(sender, args)
			   tooltip:SetVisible(false);
		   end

		   -- Add the tooltip to the menu
		   tooltip:SetParent(menu);
		   
        end
    end

    -- Add a key event to reset the button position
    self:SetWantsKeyEvents(true);
    self.KeyDown = function(sender, args)
        if args.Action == 268435637 then -- Correctly identifying the "F7" key using the Turbine.UI.Lotro.Key enumeration
            button:SetPosition(400, 300); -- Reset to the default position
            self:SavePosition(400, 300); -- Save the reset position
            button:SetVisible(true); -- Ensure button is visible
        end
    end

    -- Monitor player HP
    local player = Turbine.Gameplay.LocalPlayer:GetInstance();
    player.MoraleChanged = function(sender, args)
        local currentHP = player:GetMorale();
        if currentHP <= 0 then
            self:DisplayGameOverScreen();
        end
    end
end

function MyPlugin:SaveCheckBoxState(key, state)
    local success, err = pcall(function()
        Turbine.PluginData.Save(Turbine.DataScope.Character, key, state);
    end)
    if not success then
        Turbine.Shell.WriteLine("Error saving checkbox state for " .. key .. ": " .. err)
    end
end

function MyPlugin:LoadCheckBoxState(key)
    local success, result = pcall(function()
        return Turbine.PluginData.Load(Turbine.DataScope.Character, key)
    end)
    if not success then
        return false -- Default to unchecked
    end
    return result ~= nil and result or false -- Default to unchecked if no saved data
end

-- Function to save the game-over state
function MyPlugin:SaveGameOverState()
    Turbine.PluginData.Save(Turbine.DataScope.Character, "KaymorHC_GameOver", true);
end

-- Function to check if the game-over state is set
function MyPlugin:IsGameOver()
    local state = Turbine.PluginData.Load(Turbine.DataScope.Character, "KaymorHC_GameOver");
    return state == true;
end

-- Function to display the game-over screen
function MyPlugin:DisplayGameOverScreen()
    -- Save the game-over state
    self:SaveGameOverState();
    -- Create a full-screen semi-transparent overlay
    local overlay = Turbine.UI.Window();
    overlay:SetSize(1920, 1080);
    overlay:SetPosition(0, 0);
    overlay:SetBackColor(Turbine.UI.Color(0.5, 0, 0, 0)); -- Semi-transparent black
    overlay:SetVisible(true);
    overlay:SetZOrder(100); -- Ensure it appears on top

    -- Create the game-over message
    local gameOverLabel = Turbine.UI.Label();
    gameOverLabel:SetParent(overlay);
    gameOverLabel:SetSize(1920, 200);
    gameOverLabel:SetPosition(0, (1080 - 200) / 2); -- Center vertically
    gameOverLabel:SetText("Game Over");
    gameOverLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    gameOverLabel:SetForeColor(Turbine.UI.Color(1, 0, 0)); -- Red color
    gameOverLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold36);

    -- Add a "Close" button (optional)
    local closeButton = Turbine.UI.Lotro.Button();
    closeButton:SetParent(overlay);
    closeButton:SetText("Try again");
    closeButton:SetSize(150, 40);
    closeButton:SetPosition((1920 - 150) / 2, (1080 - 200) / 2 + 220); -- Position below the text
    closeButton.Click = function(sender, args)
        overlay:SetVisible(false); -- Hide the overlay
        overlay = nil; -- Allow it to be garbage-collected
    end
end


function MyPlugin:SavePosition(x, y)
    Turbine.PluginData.Save(Turbine.DataScope.Character, "KaymorHC_ButtonPosition", { x = x, y = y });
end

function MyPlugin:LoadPosition()
    local position = Turbine.PluginData.Load(Turbine.DataScope.Character, "KaymorHC_ButtonPosition");
    if position then
        return position.x, position.y;
    else
        return nil, nil;
    end
end

myPlugin = MyPlugin();