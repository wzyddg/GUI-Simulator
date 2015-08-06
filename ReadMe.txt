==================================================================
HCI Final Project
Read Me File (Tongji University SSE Wang Zeyu)
==================================================================

Thank you for checking my final project. This readme file contains some detail information that you make need to use my project correctly and efficiently.

==================================================================
CONTENTS
==================================================================

1. System Requirements
2. How To Use it
3. Tips

==================================================================
1. System Requirements
==================================================================

To run my project, your system must meet the following requirements:

- Processing V2.2 with JAVA Runtime.

- Displayer with 1440*900 or higher resolution.

- Camera connected to the computer.

==================================================================
2. How To Use it
==================================================================

1. Open Final.pde and import the required packages

2. Press Run Button.

3. Follow the instructions and use it as you wish.


Instructions:

1. When the program is running, the screen will be separated into two sub-windows.

2. On the left window, when the hand is detected, there will be a rectangular shown on the screen to indicate the current position of the hand.

3. There will be four folder images shown in the right window when the program is initiated. The folder name will be properly placed under the corresponding folder image.

4. A cursor will be shown on the right window and move on the screen with the movement of the detected hand.

5. When the cursor hovers over a folder image, the image will be highlighted, which indicates that the folder is selected.

6. When a folder is selected, press key "C" to copy the selected folder: a new folder will appears on the right window with a predefined name, such as "Copy of folder_X". The new folder and its name will be properly placed on the screen.

7. When a folder is selected, press key "M" to move the selected folder: the selected folder (and its name) should move with the hand and can be drop down on the screen when key "M" is released.The folder with be placed at the nearest block that you release it.

8. Press key "N" to create a new folder: a new folder will appears on the right window with a predefined name, such as "folder_X". The new folder's name will not be the same as the existing folder names. The new folder and its name will be properly placed on the screen.

9. Press key "D" to delete the selected folder: the selected folder and its name will disappear from the screen.

==================================================================
3. Tips
==================================================================

The aGest.xml is not good enough to detect a fist all the time ,sometime the project ignore my fist and sometimes it regard other things as a fist, like a mouth or an eyebrow.

But we did find a way to do with it.If you use a piece of white paper(about A4) as the background of your fist , it will strongly improve the situation.