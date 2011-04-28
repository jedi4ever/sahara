# Description

Sahara allows vagrant to operate in sandbox mode

Typical usage:

- Enter sandbox mode: <pre>vagrant sandbox on</pre>
- Do some stuff: <pre>vagrant ssh </pre>
- If satisfied apply the changes: <pre>vagrant sandbox commit</pre>
- If not satisfied you can rollback: <pre>vagrant sandbox rollback</pre>
- To leave sandbox mod: <pre>vagrant sandbox off</pre>

Many kudos go to the creators of [vagrant](http://vagrantup.com)

# Installation

This is now available as gem:

<pre>gem install sahara</pre>