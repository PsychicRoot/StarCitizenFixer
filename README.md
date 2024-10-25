# StarCitizenFixer
Star Citizen Fixer MISC


This a .BAT script that runs some of the known fixes. And some of the not so known fixes.

I only recommend to use this if you aren't able to fix your game yourself. 
Please note this is only for the LIVE build not for, HOTFIX, EVO Or PTU.

To run just download place anywhere run and let finish. It will ask you if you want to do the things before doing it. Simply type either y for yes or n for no.



P.s
If star citizen is not in your C drive change this line in the bat file

for /f "delims=" %%i in ('dir "C:\" /s /b /ad ^| findstr /i "\\LIVE\\user$" 2^>nul') do (

To say what drive it's on. 
