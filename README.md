# Product Catalogue

<!-- [![](https://assets.contentful.com/7clmb9ye18e7/9prTbbpxsWgQ0K6qAEyY6/cd3d2a09a6110ce61d06cea59d4cf62a/download-store.svg)](https://itunes.apple.com/app/id963680410) -->

This is an iOS application example for the [Contentful][1] product
catalogue space template. The app should be built using Xcode 7.3 or newer and works on iOS >= 8.

The app uses the [Contentful][1] [Swift SDK][4] and [persistence library][5].

[Contentful][1] is a content management platform for web applications, mobile apps and connected devices. It allows you to create, edit & manage content in the cloud and publish it anywhere via powerful API. Contentful offers tools for managing editorial teams and enabling cooperation between organizations.

## Usage

Run the following command:

```
$ make setup
```

This will install all necessary RubyGems, create a new space on [Contentful][1] using
[Contentful Bootstrap][3], install all necessary [CocoaPods][2] and setup API keys automatically.

Note: This requires bundler and CMake, which you may already have. In case you are running this on a freshly installed OS X, please run `sudo gem install bundler` and install CMake with Homebrew first.

Now you're ready to use it!

## Customizing

You can easily drop the [Contentful][1] related branding by removing 'ContentfulDialogs' and 'ContentfulStyle' from the Podfile. You will need to remove the "About Us" scene from the storyboard, as well as replace usages of our fonts and colors.

## License

Copyright (c) 2016 Contentful GmbH. See LICENSE for further details.


[1]: https://www.contentful.com
[2]: http://cocoapods.org
[3]: https://github.com/contentful-labs/contentful-bootstrap.rb
[4]: https://github.com/contentful/contentful.swift
[5]: https://github.com/contentful/contentful-persistence.swift
