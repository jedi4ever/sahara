# Notice

- Sahara does not work with Vagrant 1.0 or lower.
- If you want to install an old version for Vagrant 1.0, you have to run the command like "gem install sahara -v 0.0.13"
- But I strongly recommend you to upgrade your Vagrant to latest version.

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

From source:
<pre>
bundle install
rake build
vagrant plugin install pkg/sahara-0.0.xx.gem
</pre>

This is now available as gem:
<pre>
vagrant plugin install sahara
</pre>

# Supported providers
- VirtualBox
- VMware Fusion
- libvirt
- Parallels

# License
This is licensed under the MIT license.
