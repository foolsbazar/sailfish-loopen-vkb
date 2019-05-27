Name: 		sailfish-loopen-vkb
Version: 	1.1.1
Release: 	8
Summary: 	The most amazing swiping keyboard ever created
License: 	GPLv3+
URL: 		  http://www.openrepos.net/content/foolsbazar/loopen-keyboard-fork
Source0: 	https://github.com/foolsbazar/sailfish-loopen-vkb
Group:		System/Tools
BuildArch: 	noarch
Requires: 	jolla-keyboard >= 0.7.2

%description 	
The most amazing swiping keyboard ever created
How to use it
The keyboard is composed by a central disk and N-Sectors separated by N-arms, plus some additional (intuitive) buttons. For simplicity, consider only the case with 4 sectors.
The swipe gesture should starts from the central disk.
To type a letter swipe first in the sector where the letter is located (for instance, for the “s” letter it would mean from the center to the upper sector).
Once you are in the sector you can access to two set of letters, organized in two separated arms: one on the left of the sector and one on the right.
If the letter you choose is on the right arm, start swiping on the right (clockwise order), if it is on the left one, start swiping in anticlockwise order.
To choose the first letter of the arm cross with the swipe only one other sector (for the “s” letter it would mean from the upper sector to the left one)
To choose the second letter cross with the swipe two sectors (i.e. for the “d” letter it would mean from the upper sector, cross the left one and reach the bottom one)
Once you chose the proper letter, confirm by going back to the center or by releasing the touchscreen.

If the swipe gesture does not start from the center, you will commit Capital letters.

Each sector has two additional functions: One is activated if you swipe from the center to the sector and back to the center; the other one by tapping on the sector.
Because the typing experience depends on each one’s habit, I strongly encourage personalization of these functions, because not everyone might agree with me for what it is necessary or not. Anyway, by default they are: four arrows when tapping; space when swiping on the right; backspace on the left; accents view on the bottom; symbols view on the top.

In order to add an accented letter, just like the SailfishEase keyboard, first type the letter (for instance “A”) then type the symbol of the accent (for instance “`”) and the keyboard automatically substitutes the accented letter (“À” in the example).

The central disk works also as a normal spacebar.

There is also an emoji view that appears when keeping the symbol button pressed (maybe useless since SFOS 3).
%install
rm -rf %{buildroot}

mkdir -p %{buildroot}/usr/share/maliit/plugins/com/jolla/%{name}
cp -r %{name}/* %{buildroot}/usr/share/maliit/plugins/com/jolla/%{name}

mkdir -p %{buildroot}/usr/share/maliit/plugins/com/jolla/layouts
cp -r layouts/* %{buildroot}/usr/share/maliit/plugins/com/jolla/layouts

mkdir -p %{buildroot}/usr/share/icons/hicolor/256x256/apps/
cp %{name}.png %{buildroot}/usr/share/icons/hicolor/256x256/apps/

%post
systemctl-user restart maliit-server.service

%postun
systemctl-user restart maliit-server.service

%files
%defattr(-,root,root,-)
%{_datadir}/maliit/plugins/com/jolla/%{name}
%{_datadir}/maliit/plugins/com/jolla/layouts/loopen4_en.qml
%{_datadir}/maliit/plugins/com/jolla/layouts/loopen4_it.qml
%{_datadir}/maliit/plugins/com/jolla/layouts/loopen6_en.qml
%{_datadir}/maliit/plugins/com/jolla/layouts/loopen4_example.qml
%{_datadir}/maliit/plugins/com/jolla/layouts/%{name}.conf
%{_datadir}/icons/hicolor/256x256/apps/%{name}.png
