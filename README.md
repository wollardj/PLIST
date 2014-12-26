# PLIST

`PLIST` is a `JSON`-like interface for plist strings packaged for
Meteor.

**NOTE:** _This is not 100% stable, most notably for `data` types._
Having said that, if you need a quick and dirty way to convert
plist strings and JavaScript objects that works on the server and
in the browser, this will likely suit your needs.


### PLIST.stringify()

    plistString = PLIST.stringify({
        name:'Bill',
        age:47,
        single: false,
        preference: "✓ à la mode"
    });

...will output...

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
        <dict>
            <key>name</key>
            <string>Bill</string>
            <key>age</key>
            <integer>47</integer>
            <key>single</key>
            <false/>
            <key>preference</key>
            <string>&#10003; &#224; la mode</string>
        </dict>
    </plist>


### PLIST.parse()

    obj = PLIST.parse(
            '<plist>' +
                '<dict>' +
                    '<key>name</key>' +
                    '<string>Bill</string>' +
                '</dict>' +
            '</plist>');

... will output ...

    {
        name: "Bill"
    }


## Limitations

Of course it's not possible to convert a plist structure to a
JavaScript object and back again with 100% reliability in all
scenarios. `PLIST` does its best to figure out the appropriate data
type, but especially in the case of `data`, it could be doing much
more.

If you parse a plist string that contains a `<data>` element, that
data will be decoded as you'd expect, but once that's happened,
there's really no way to know that the value needs to be `data`
once it's stringified again. If it's truly binary data, it's easy
enough, but the value _might_ decode to an ASCII string - how would
we know that this otherwise normal string should be base64 encoded?
