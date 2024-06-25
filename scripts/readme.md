## How to use th updateScreenContents script

1. Change the location where the data is located. In my case it is in AximmetrySessionData\media folder
2. Inside that folder every folder corresponds to a different screen
3. The script is called from the companion as follows `pwsh $(internal:custom_scripts_directory)"\updateMovingScreenContents.ps1" page_number "screen_name"`
4. Page Number is the page number in the streamdeck. We will be changing those pages buttons.
5. Running the above command will store in custom_temp variable (in companion) The required osc message value
6. We then need a "Send to Aximmetry" button. It will have 2 actions, both "osc: Send message with multiple arguments".

- the path is the path we have defined inside the compound
- The first Arguments is a series of 16 empty "" , to empty all the values from previous entries.
- for the second action, we put as arguments `$(internal:custom_temp)`. These are the contents of the message we have just created.

Now inside that media\screen_name folder we have screen_name.txt. So if the folder name was center_screen, the file name is center_screen.txt
It should have up to 16 rows with the simple format media_file_name;title_for_the_button and the media should be in that same folder.

It is very easy to have another 16 files. Just create another button (that creates the osc message) and attach the command `pwsh $(internal:custom_scripts_directory)"\updateMovingScreenContents.ps1" page_number "another_screen_name"`
So we target the same page, read from different folder and create that osc_message parameters. Then the **same** button (send to aximmetry) will update correctly those video slots

## Using the updateAudioContents script

Its exactly the same script, it just expects data to be in the audio folder (not the media) and he actual data are inside subfolders.
For example bank1, bank2. One button creates the osc_message and another one sends it to aximmetry.
