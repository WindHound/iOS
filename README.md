# iOS Map  
  
Map page for iOS app

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

## The Vision

This is what we have planed for the second release of our app ![](https://cdn.rawgit.com/jongracecox/anybadge/master/examples/awesomeness.svg)

<p align="center">
<img align="center" src="iOS_Map_Demo.gif" width="100%" alt="iOS Map Demo"/>
</p>

<a href="https://media.giphy.com/media/1irfUpkCCMLrnYUji8/giphy.gif"><img src ="https://media.giphy.com/media/1irfUpkCCMLrnYUji8/giphy.gif" title="iOS Demo Gif"/></a>
![](https://media.giphy.com/media/1irfUpkCCMLrnYUji8/giphy.gif)

<div style="width:100%;height:0;padding-bottom:179%;position:relative;"><iframe src="https://giphy.com/embed/1irfUpkCCMLrnYUji8" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/1irfUpkCCMLrnYUji8">via GIPHY</a></p>

<iframe src="https://giphy.com/embed/1irfUpkCCMLrnYUji8" width="268" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/1irfUpkCCMLrnYUji8">via GIPHY</a></p>


### Prerequisites

To download (http://blog.osteele.com/2008/05/my-git-workflow/)

```
$ cd dir
$ git pull origin
```

You will also need to use

```
Xcode 9.2 (9C40b)
Command line tools for Xcode 9.2
```

Should work on older Xcode but since Swift 4 is required 9.0 is the oldest supported version (I used 4.1; some features might not be supported in Swift 4 although this is unlikely)


### iOS Version

The code was tested on iPhone 6 and newer with 3 iOS versions 

```
iOS 10.0
iOS 10.3.1
iOS 11.1
```

### Coding style

Try and have max 100 characters per line. Makes it easier to work with the Assistant editor. You can set a vertical guide at

```
Preferences > Text Editing > Page guide at column: 100
```

Function defs and variables are lower camel case; Classes and Extensions are upper camel case

Please use width 4 soft tabs and adhere to the NASA SOFTWARE ENGINEERING LABORATORY SERIES SEL-94-003 C STYLE GUIDE (http://homepages.inf.ed.ac.uk/dts/pm/Papers/nasa-c-style.pdf). Something like this:

```swift
let totalFooBar = 3.25

func greetPerson(person: String) -> String
{
    let greeting = "Hello, " + person + "!"
    return greeting
}

print(greet(person: "Anna"))
```

## Deployment

Current deployment target is 

```
iOS 10.3
```

The device type is set to Universal. Before we deploy, we need to integrate it

## Built With

```
LLVM LTO (FINAL RELEASE)
LLVM VECTORIZATION (FINAL RELEASE)
```

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests.

## Authors

* **Matei Sterian** - *Initial work* - [Grakkus](https://github.com/Grakkus)

* **David Shin** - *Edits and Additions* - [Dongnamu](https://github.com/Dongnamu)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Future Work

Issues:
```
MKPolyline not always rendering  
Map resize and drag on smaller devices
Storyboard constraints - Auto Layout
```  
Nice to have:
```
UI
```
