# Description

Sahara allows vagrant to operate in sandbox mode.

Typical usage:

- Enter sandbox mode: <pre>vagrant sandbox on</pre>
- Do some stuff: <pre>vagrant ssh </pre>
- If satisfied, apply the changes permanently: <pre>vagrant sandbox commit</pre>
- If not satisfied, rollback to the previous commit: <pre>vagrant sandbox rollback</pre>
- Exit sandbox mode: <pre>vagrant sandbox off</pre>

Many kudos go to the creators of [vagrant](http://vagrantup.com)

# Installation

This is now available as gem:

<pre>gem install sahara</pre>

# Windows Notes

It works on Windows, but you need to have:

- Vagrant 1.0.x installed (with patch for [issue#817](https://github.com/mitchellh/vagrant/issues/817))
- VBoxManage.exe in the PATH <pre>set PATH=C:\Program Files\Oracle\VirtualBox\;%PATH%</pre>
- grep.exe and cut.exe in the PATH: <pre>set PATH=D:\vagrant\embedded\bin;%PATH%</pre>