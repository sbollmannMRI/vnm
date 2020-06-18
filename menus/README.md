# Modifying LXDE menus

| File(s) | Description |
|--|--|
| lxde-applications.menu | merges with vnm-applications.menu |
| vnm-applications.menu | add submenus entries here |
| submenus/* | add submenus entries here |
| applications/* | add app config files here |
| icons/* | add icons here |

## How to add a new application to menu 

### Create Sub-menu (optional)

Add the sub-menu block to vnm-applications.menu. Example submenu block below:

    <Menu>
	    <Name>VNM Placeholder</Name>
	    <Directory>vnm-placeholder.directory</Directory>
	    <Include>
		    <And>
			    <Category>VNM-Placeholder</Category>
		    </And>
	    </Include>
    </Menu>
Sub-menus can be nested within other sub-menus
*For an application to appear in this sub-menu, Add this `<Category>`field to the application's `Categories` entry*

Create a vnm-submenu.directory and add to ./submenus/
Add icon to ./icons/ (accessed from /home/neuro/.config/lxpanel/LXDE/icons/)

    [Desktop Entry]
    Name=VNM Placeholder
    Comment=VNM Placeholder
    Icon=/home/neuro/.config/lxpanel/LXDE/icons/vnm.png
    Type=Directory

### Application
Create vnm-placeholder.desktop file and add to ./applications/
Add icon to ./icons/ (accessed from /home/neuro/.config/lxpanel/LXDE/icons/)

    [Desktop Entry]
    Name=vnm-Placeholder
    GenericName=vnm-Placeholder
    Comment=Placeholder
    TryExec=/usr/bin/placeholder
    Exec=/usr/bin/placeholder
    Icon=/home/neuro/.config/placeholder/LXDE/icons/vnm.png
    Type=Application
    Categories=VNM-Placeholder
    Keywords=placeholder
