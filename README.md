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

It works on Windows with Vagrant 1.0.x installed and patch for [issue#817](https://github.com/mitchellh/vagrant/issues/817)